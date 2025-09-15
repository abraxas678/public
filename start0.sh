#!/bin/bash
if [ "$(id -u)" = 0 ]; then
    MYROOT=""
else
    MYROOT="sudo"
fi

# Modern styled logging helpers
if [ -t 1 ]; then
    C_RESET="\033[0m"
    C_RED="\033[31m"
    C_GREEN="\033[32m"
    C_YELLOW="\033[33m"
    C_CYAN="\033[36m"
else
    C_RESET=""
    C_RED=""
    C_GREEN=""
    C_YELLOW=""
    C_CYAN=""
fi

log_info() { printf "%b\n" "${C_CYAN}ℹ${C_RESET}  $*"; }
log_success() { printf "%b\n" "${C_GREEN}✔${C_RESET}  $*"; }
log_warn() { printf "%b\n" "${C_YELLOW}⚠${C_RESET}  $*"; }
log_error() { printf "%b\n" "${C_RED}✖${C_RESET}  $*"; }

wget 
# Install prerequisites only if missing
missing_packages=()
for pkg in wget curl coreutils nfs-common; do
    dpkg -s "$pkg" >/dev/null 2>&1 || missing_packages+=("$pkg")
done
if [ ${#missing_packages[@]} -gt 0 ]; then
    $MYROOT apt-get update
    $MYROOT apt-get install -y "${missing_packages[@]}"
fi

THORIUM="$(command -v thorium-browser || true)"
if [ -z "$THORIUM" ]; then
  ./github_latest_release_url_install.sh Alex313031 thorium
fi


TAILSCALE="$(command -v tailscale || true)"
if [ -z "$TAILSCALE" ]; then
  echo
  wget tailscale.com/install.sh
  source install.sh
fi

# Check if Tailscale is logged in
if [ -n "$TAILSCALE" ]; then
    TAILSCALE_STATUS="$($TAILSCALE status --json 2>/dev/null || echo '{}')"
    if echo "$TAILSCALE_STATUS" | grep -q '"Self"'; then
        log_success "Tailscale is logged in and connected"
    else
        log_warn "Tailscale is installed but not logged in"
        sudo tailscale up --ssh --accept-dns=false
    fi
else
    log_info "Tailscale not found - it will be installed above"
fi

mkdir -p $HOME/tmp
cd $HOME/tmp
mkdir ./starttmp && mount -t tmpfs -o size=500m tmpfs ./starttmp
cd starttmp

wget http://hetzner15.donkey-elevator.ts.net:3000/start.sh
chmod +x start.sh
./start.sh
