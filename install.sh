#!/bin/bash
set -e -o pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
echo_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
echo_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running as root
if [ "$(id -u)" = 0 ]; then
    MYROOT=""
    echo_warn "Running as root"
else
    MYROOT="sudo"
fi

# Detect OS and set package manager
echo_info "Detecting operating system..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo_error "Cannot detect OS. /etc/os-release not found."
    exit 1
fi

case "$OS" in
    ubuntu|debian|linuxmint|pop)
        PKG_MANAGER="apt"
        PKG_UPDATE="apt-get update"
        PKG_INSTALL="apt-get install -y"
        PKG_CHECK="dpkg -s"
        PKG_EXT="deb"
        INSTALL_LOCAL="apt install -y"
        NFS_PKG="nfs-common"
        ;;
    fedora|rhel|centos|rocky|almalinux)
        PKG_MANAGER="dnf"
        PKG_UPDATE="dnf check-update || true"
        PKG_INSTALL="dnf install -y"
        PKG_CHECK="rpm -q"
        PKG_EXT="rpm"
        INSTALL_LOCAL="dnf install -y"
        NFS_PKG="nfs-utils"
        ;;
    *)
        echo_error "Unsupported OS: $OS"
        echo_error "This script supports: Ubuntu, Debian, Fedora, RHEL, CentOS, Rocky, AlmaLinux"
        exit 1
        ;;
esac

echo_info "Detected OS: $OS"
echo_info "Using package manager: $PKG_MANAGER"
echo

# ============================================================================
# STEP 1: Configure visudo for passwordless sudo
# ============================================================================
echo_info "Step 1: Configure visudo for passwordless sudo"
echo
echo "To enable passwordless sudo, you need to run:"
echo "  sudo visudo"
echo
echo "Then add this line (replace 'abrax' with your username):"
echo "  $USER ALL=(ALL:ALL) NOPASSWD: ALL"
echo
read -p "Press Enter after you've configured visudo, or Ctrl+C to skip..." -t 60

# ============================================================================
# STEP 2: Install basic utilities
# ============================================================================
echo_info "Step 2: Installing basic utilities..."

BASIC_PACKAGES=(
    curl
    git
    unzip
    xsel
    fzf
    jq
    $NFS_PKG
)

echo_info "Updating package manager..."
$MYROOT $PKG_UPDATE

missing_packages=()
for pkg in "${BASIC_PACKAGES[@]}"; do
    $PKG_CHECK "$pkg" >/dev/null 2>&1 || missing_packages+=("$pkg")
done

# Check for wget or wget2-wget separately
if ! command -v wget &> /dev/null; then
    if [ "$PKG_MANAGER" = "dnf" ]; then
        # On Fedora, wget2-wget is often pre-installed
        if ! $PKG_CHECK wget2-wget >/dev/null 2>&1; then
            missing_packages+=("wget")
        fi
    else
        missing_packages+=("wget")
    fi
fi

if [ ${#missing_packages[@]} -gt 0 ]; then
    echo_info "Installing missing packages: ${missing_packages[*]}"
    set +e  # Temporarily disable exit on error
    $MYROOT $PKG_INSTALL "${missing_packages[@]}"
    set -e
else
    echo_info "All basic utilities already installed"
fi

# Install gron separately (not in all distro repos)
if ! command -v gron &> /dev/null; then
    echo_info "Installing gron from GitHub..."
    set +e  # Temporarily disable exit on error
    GRON_URL=$(curl -sL "https://api.github.com/repos/tomnomnom/gron/releases/latest" | \
        grep "browser_download_url" | \
        grep "linux" | \
        grep -v "arm" | \
        head -n1 | \
        sed 's/.*"browser_download_url": "\(.*\)".*/\1/')

    if [ -n "$GRON_URL" ]; then
        wget -O /tmp/gron.tgz "$GRON_URL" 2>/dev/null
        tar -xzf /tmp/gron.tgz -C /tmp/ 2>/dev/null
        $MYROOT mv /tmp/gron /usr/local/bin/ 2>/dev/null || true
        $MYROOT chmod +x /usr/local/bin/gron 2>/dev/null || true
        rm -f /tmp/gron.tgz
        if command -v gron &> /dev/null; then
            echo_info "gron installed successfully"
        else
            echo_warn "Could not install gron, continuing without it"
        fi
    else
        echo_warn "Could not find gron release, continuing without it"
    fi
    set -e
else
    echo_info "gron is already installed"
fi

# Install GitHub CLI (gh)
if ! command -v gh &> /dev/null; then
    echo_info "Installing GitHub CLI (gh)..."
    set +e  # Temporarily disable exit on error

    case "$PKG_MANAGER" in
        apt)
            # Official GitHub CLI repository for Debian/Ubuntu
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | $MYROOT dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
            $MYROOT chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
                $MYROOT tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            $MYROOT $PKG_UPDATE
            $MYROOT $PKG_INSTALL gh
            ;;
        dnf)
            # Official GitHub CLI repository for Fedora/RHEL
            $MYROOT dnf install -y 'dnf-command(config-manager)' 2>/dev/null || true
            $MYROOT dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo 2>/dev/null || \
                $MYROOT wget -O /etc/yum.repos.d/gh-cli.repo https://cli.github.com/packages/rpm/gh-cli.repo
            $MYROOT $PKG_INSTALL gh
            ;;
    esac

    if command -v gh &> /dev/null; then
        echo_info "GitHub CLI (gh) installed successfully"
    else
        echo_warn "Could not install GitHub CLI (gh), continuing without it"
    fi
    set -e
else
    echo_info "GitHub CLI (gh) is already installed"
fi

# ============================================================================
# STEP 3: Install Claude Code
# ============================================================================
echo_info "Step 3: Installing Claude Code..."

if command -v claude &> /dev/null; then
    echo_info "Claude Code is already installed"
else
    echo_info "Downloading and installing Claude Code..."

    # Get latest release URL
    CLAUDE_URL=$(curl -sL "https://api.github.com/repos/anthropics/claude-code/releases/latest" | \
        grep "browser_download_url" | \
        grep "$PKG_EXT" | \
        grep -v "arm" | \
        head -n1 | \
        sed 's/.*"browser_download_url": "\(.*\)".*/\1/')

    if [ -n "$CLAUDE_URL" ]; then
        echo_info "Downloading from: $CLAUDE_URL"
        wget -O /tmp/claude-code.$PKG_EXT "$CLAUDE_URL"
        $MYROOT $INSTALL_LOCAL /tmp/claude-code.$PKG_EXT
        rm /tmp/claude-code.$PKG_EXT
        echo_info "Claude Code installed successfully"
    else
        echo_warn "Could not find Claude Code package for $PKG_EXT format"
    fi
fi

# ============================================================================
# STEP 4: Install Thorium Browser
# ============================================================================
echo_info "Step 4: Installing Thorium Browser..."

if command -v thorium-browser &> /dev/null; then
    echo_info "Thorium Browser is already installed"
else
    echo_info "Downloading and installing Thorium Browser..."

    # Get latest release URL
    THORIUM_URL=$(curl -sL "https://api.github.com/repos/Alex313031/thorium/releases/latest" | \
        grep "browser_download_url" | \
        grep "$PKG_EXT" | \
        grep -v "arm" | \
        grep -v "AVX" | \
        head -n1 | \
        sed 's/.*"browser_download_url": "\(.*\)".*/\1/')

    if [ -n "$THORIUM_URL" ]; then
        echo_info "Downloading from: $THORIUM_URL"
        wget -O /tmp/thorium.$PKG_EXT "$THORIUM_URL"
        $MYROOT $INSTALL_LOCAL /tmp/thorium.$PKG_EXT
        rm /tmp/thorium.$PKG_EXT
        echo_info "Thorium Browser installed successfully"
    else
        echo_warn "Could not find Thorium package for $PKG_EXT format"
    fi
fi

# ============================================================================
# STEP 4b: Install Vivaldi Browser
# ============================================================================
echo_info "Step 4b: Installing Vivaldi Browser..."

if command -v vivaldi &> /dev/null; then
    echo_info "Vivaldi Browser is already installed"
else
    echo_info "Installing Vivaldi Browser..."

    case "$PKG_MANAGER" in
        apt)
            # Vivaldi's official repository for Debian/Ubuntu
            wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | $MYROOT gpg --dearmor -o /usr/share/keyrings/vivaldi-browser.gpg
            echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | \
                $MYROOT tee /etc/apt/sources.list.d/vivaldi-archive.list
            $MYROOT $PKG_UPDATE
            $MYROOT $PKG_INSTALL vivaldi-stable
            ;;
        dnf)
            # Vivaldi's official repository for Fedora/RHEL
            set +e  # Temporarily disable exit on error
            # Install dnf-plugins-core if not present
            $MYROOT $PKG_INSTALL dnf-plugins-core >/dev/null 2>&1

            # Add Vivaldi repository
            $MYROOT dnf config-manager --add-repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo 2>/dev/null || \
                $MYROOT wget -O /etc/yum.repos.d/vivaldi-fedora.repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo

            # Import GPG key
            $MYROOT rpm --import https://repo.vivaldi.com/archive/linux_signing_key.pub 2>/dev/null || true

            $MYROOT $PKG_INSTALL vivaldi-stable
            set -e
            ;;
    esac

    echo_info "Vivaldi Browser installed successfully"
fi

# ============================================================================
# STEP 5: Install additional utilities
# ============================================================================
echo_info "Step 5: Installing additional utilities..."

UTILITY_PACKAGES=(restic rclone keepassxc copyq ansible)

missing_packages=()
for pkg in "${UTILITY_PACKAGES[@]}"; do
    $PKG_CHECK "$pkg" >/dev/null 2>&1 || missing_packages+=("$pkg")
done

if [ ${#missing_packages[@]} -gt 0 ]; then
    echo_info "Installing: ${missing_packages[*]}"
    set +e  # Temporarily disable exit on error
    $MYROOT $PKG_INSTALL "${missing_packages[@]}"
    set -e
else
    echo_info "All utilities are already installed"
fi

# ============================================================================
# Installation Complete
# ============================================================================
echo
echo_info "============================================"
echo_info "Installation Complete!"
echo_info "============================================"
echo
echo_info "Installed components:"
echo "  - Basic utilities (curl, wget, git, jq, fzf, xsel, etc.)"
echo "  - GitHub CLI (gh)"
echo "  - gron (JSON processor)"
echo "  - Claude Code"
echo "  - Thorium Browser"
echo "  - Vivaldi Browser"
echo "  - restic (backup tool)"
echo "  - rclone (cloud sync tool)"
echo "  - KeePassXC (password manager)"
echo "  - CopyQ (clipboard manager)"
echo "  - Ansible (automation tool)"
echo
echo_info "You can now use these applications!"
