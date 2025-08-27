#!/bin/bash
while true; do
# Multi-Design Futuristic Interface System

VERSION="0.5.0"
APP_TITLE="PUBLIC STARTER"

# Set terminal window title
printf "\033]0;%s v%s\007" "$APP_TITLE" "$VERSION"

# Color definitions
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[93m"
BLUE="\033[34m"
MAGENTA="\033[95m"
CYAN="\033[96m"
WHITE="\033[97m"
GRAY="\033[90m"
LIGHT_GRAY="\033[37m"
BRIGHT_GREEN="\033[92m"
BLACK_BG="\033[40m"
PURPLE="\033[35m"

show_design1_matrix() {
    clear
    echo
    echo -e "${BLACK_BG}${BRIGHT_GREEN}  ╔═══════════════════════════════════╗  ${RESET}"
    echo -e "${BLACK_BG}${BRIGHT_GREEN}  ║ ${BOLD}${WHITE}>>> ${APP_TITLE} <<<${RESET}${BLACK_BG}${BRIGHT_GREEN} ║  ${RESET}"
    echo -e "${BLACK_BG}${GREEN}  ║ ${DIM}MATRIX v${VERSION} INITIALIZED${RESET}${BLACK_BG}${GREEN}    ║  ${RESET}"
    echo -e "${BLACK_BG}${BRIGHT_GREEN}  ╚═══════════════════════════════════╝  ${RESET}"
    echo
    echo -e "  ${GREEN}[${BRIGHT_GREEN}*${GREEN}] ${WHITE}EXECUTE MAIN PROTOCOL${RESET}"
    echo -e "  ${DIM}${GREEN}    └─ Press any key to hack the system...${RESET}"
    echo
}

show_design2_holographic() {
    clear
    echo
    echo -e "  ${MAGENTA}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${RESET}"
    echo -e "  ${CYAN}▓▓▒▒${BOLD}${WHITE} ${APP_TITLE} ${RESET}${CYAN}▒▒▓▓${RESET}"
    echo -e "  ${YELLOW}◈◈◈${DIM} HOLOGRAM v${VERSION} ACTIVE ${RESET}${YELLOW}◈◈◈${RESET}"
    echo -e "  ${MAGENTA}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${RESET}"
    echo
    echo -e "  ${PURPLE}◇${RESET} ${BOLD}${CYAN}ACTIVATE CORE SEQUENCE${RESET}"
    echo -e "    ${DIM}${MAGENTA}✦ Neon interface ready ✦${RESET}"
    echo
}

show_design3_geometric() {
    clear
    echo
    echo -e "    ${WHITE}◢${RESET}${BOLD}${WHITE}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■${RESET}${WHITE}◣${RESET}"
    echo -e "    ${WHITE}◥${RESET}  ${BOLD}${WHITE}${APP_TITLE}${RESET}  ${WHITE}◤${RESET}"
    echo -e "      ${DIM}${GRAY}△ SYSTEM ${VERSION} △${RESET}"
    echo -e "    ${WHITE}◢${RESET}${LIGHT_GRAY}■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■${RESET}${WHITE}◣${RESET}"
    echo
    echo -e "    ${WHITE}▶${RESET} ${BOLD}LAUNCH SEQUENCE${RESET}"
    echo -e "      ${DIM}${GRAY}geometric interface loaded${RESET}"
    echo
}

show_design4_space() {
    clear
    echo
    echo -e "  ${BLUE}╭─────────────────────────────────────╮${RESET}"
    echo -e "  ${BLUE}│${RESET} ${YELLOW}★${RESET} ${BOLD}${WHITE}${APP_TITLE}${RESET} ${YELLOW}★${RESET} ${BLUE}│${RESET}"
    echo -e "  ${BLUE}│${RESET}   ${DIM}${CYAN}STARSHIP TERMINAL v${VERSION}${RESET}     ${BLUE}│${RESET}"
    echo -e "  ${BLUE}╰─────────────────────────────────────╯${RESET}"
    echo
    echo -e "  ${CYAN}◉${RESET} ${WHITE}ENGAGE WARP DRIVE${RESET}"
    echo -e "    ${DIM}${GRAY}[Navigation systems online]${RESET}"
    echo -e "    ${DIM}${YELLOW}★ ★ ★ Ready for launch ★ ★ ★${RESET}"
    echo
}

show_design5_cyberpunk() {
    clear
    echo
    echo -e "  ${RED}▓▓▓▓${CYAN}░░░░${MAGENTA}▓▓▓▓${CYAN}░░░░${RED}▓▓▓▓${RESET}"
    echo -e "  ${CYAN}░${RESET} ${BOLD}${WHITE}${APP_TITLE}${RESET} ${CYAN}░${RESET}"
    echo -e "  ${MAGENTA}▓${RESET} ${DIM}${YELLOW}NEURAL NET v${VERSION}${RESET} ${MAGENTA}▓${RESET}"
    echo -e "  ${RED}▓▓▓▓${CYAN}░░░░${MAGENTA}▓▓▓▓${CYAN}░░░░${RED}▓▓▓▓${RESET}"
    echo
    echo -e "  ${RED}▶▶${RESET} ${BOLD}${CYAN}JACK INTO THE MATRIX${RESET}"
    echo -e "     ${DIM}${GRAY}cyberpunk protocol active${RESET}"
    echo -e "     ${MAGENTA}◈${RESET} ${YELLOW}Data streams flowing${RESET} ${MAGENTA}◈${RESET}"
    echo
}

show_design6_material() {
    clear
    echo
    echo -e "  ${BLUE}╭─────────────────────────────────╮${RESET}"
    echo -e "  ${BLUE}│${RESET}                                 ${BLUE}│${RESET}"
    echo -e "  ${BLUE}│${RESET}    ${BOLD}${WHITE}${APP_TITLE}${RESET}    ${BLUE}│${RESET}"
    echo -e "  ${BLUE}│${RESET}    ${DIM}${GRAY}Version ${VERSION}${RESET}              ${BLUE}│${RESET}"
    echo -e "  ${BLUE}│${RESET}                                 ${BLUE}│${RESET}"
    echo -e "  ${BLUE}╰─────────────────────────────────╯${RESET}"
    echo
    echo -e "  ${BLUE}●${RESET} ${WHITE}Launch Application${RESET}"
    echo -e "    ${DIM}${GRAY}Material Design Interface${RESET}"
    echo -e "    ${BLUE}▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔${RESET}"
    echo
}

show_design7_corporate() {
    clear
    echo
    echo -e "  ${BOLD}${WHITE}${APP_TITLE}${RESET}"
    echo -e "  ${GRAY}────────────────────────────────────────${RESET}"
    echo -e "  ${DIM}${GRAY}Enterprise Solution v${VERSION}${RESET}"
    echo
    echo -e "  ${WHITE}▸${RESET} ${BOLD}Initialize System${RESET}"
    echo -e "  ${WHITE}▸${RESET} ${DIM}Professional Interface Ready${RESET}"
    echo
    echo -e "  ${GRAY}© 2024 Public Starter Solutions${RESET}"
    echo
}

show_design8_swiss() {
    clear
    echo
    echo -e "    ${BOLD}${WHITE}${APP_TITLE}${RESET}"
    echo -e "    ${GRAY}${VERSION}${RESET}"
    echo
    echo -e "    ${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
    echo -e "    ${WHITE}→${RESET} Start"
    echo -e "      ${DIM}${GRAY}Clean. Simple. Effective.${RESET}"
    echo
}

show_design9_gradient() {
    clear
    echo
    echo -e "  ${MAGENTA}◦${RESET}${CYAN}◦${RESET}${BLUE}◦${RESET} ${BOLD}${WHITE}${APP_TITLE}${RESET} ${BLUE}◦${RESET}${CYAN}◦${RESET}${MAGENTA}◦${RESET}"
    echo -e "     ${DIM}${GRAY}~ v${VERSION} ~${RESET}"
    echo
    echo -e "  ${CYAN}∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿${RESET}"
    echo
    echo -e "  ${MAGENTA}◉${RESET} ${WHITE}Begin Journey${RESET}"
    echo -e "    ${DIM}${CYAN}Soft modern interface${RESET}"
    echo -e "    ${BLUE}◦${RESET} ${CYAN}◦${RESET} ${MAGENTA}◦${RESET} ${DIM}Ready to start${RESET} ${MAGENTA}◦${RESET} ${CYAN}◦${RESET} ${BLUE}◦${RESET}"
    echo
}

show_design10_card() {
    clear
    echo
    echo -e "  ${WHITE}┌─────────────────────────────────────┐${RESET}"
    echo -e "  ${WHITE}│${RESET}                                     ${WHITE}│${RESET}"
    echo -e "  ${WHITE}│${RESET}  ${BOLD}${WHITE}${APP_TITLE}${RESET}                  ${WHITE}│${RESET}"
    echo -e "  ${WHITE}│${RESET}  ${DIM}${GRAY}v${VERSION}${RESET}                              ${WHITE}│${RESET}"
    echo -e "  ${WHITE}│${RESET}                                     ${WHITE}│${RESET}"
    echo -e "  ${WHITE}│${RESET}  ${GRAY}┌─────────────────────────────────┐${RESET}  ${WHITE}│${RESET}"
    echo -e "  ${WHITE}│${RESET}  ${GRAY}│${RESET} ${WHITE}Launch Application${RESET}          ${GRAY}│${RESET}  ${WHITE}│${RESET}"
    echo -e "  ${WHITE}│${RESET}  ${GRAY}└─────────────────────────────────┘${RESET}  ${WHITE}│${RESET}"
    echo -e "  ${WHITE}│${RESET}                                     ${WHITE}│${RESET}"
    echo -e "  ${WHITE}└─────────────────────────────────────┘${RESET}"
    echo
}

show_menu() {
    clear
    echo
    echo -e "  ${BOLD}${WHITE}${APP_TITLE} v${VERSION}${RESET}"
    echo -e "  ${DIM}${GRAY}Design Selection Menu${RESET}"
    echo
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
    echo -e "  ${DIM}${GRAY}FUTURISTIC DESIGNS:${RESET}"
    echo -e "  ${WHITE}1.${RESET} ${GREEN}Matrix/Hacker Style${RESET}"
    echo -e "  ${WHITE}2.${RESET} ${MAGENTA}Holographic/Neon Style${RESET}"
    echo -e "  ${WHITE}3.${RESET} ${GRAY}Minimalist Geometric${RESET}"
    echo -e "  ${WHITE}4.${RESET} ${BLUE}Space/Terminal Style${RESET}"
    echo -e "  ${WHITE}5.${RESET} ${RED}Cyberpunk Grid Style${RESET}"
    echo
    echo -e "  ${DIM}${GRAY}MODERN DESIGNS:${RESET}"
    echo -e "  ${WHITE}6.${RESET} ${BLUE}Material Design${RESET}"
    echo -e "  ${WHITE}7.${RESET} ${WHITE}Corporate/Professional${RESET}"
    echo -e "  ${WHITE}8.${RESET} ${WHITE}Swiss Minimalist${RESET}"
    echo -e "  ${WHITE}9.${RESET} ${CYAN}Gradient/Soft Modern${RESET}"
    echo -e "  ${WHITE}0.${RESET} ${WHITE}Clean Card-based${RESET}"
    echo
    echo -e "  ${DIM}${GRAY}Choose design (1-9, 0) or press Enter for default:${RESET}"
}

# Main execution
show_menu

read -n 1 -s choice

case $choice in
    1) show_design1_matrix ;;
    2) show_design2_holographic ;;
    3) show_design3_geometric ;;
    4) show_design4_space ;;
    5) show_design5_cyberpunk ;;
    6) show_design6_material ;;
    7) show_design7_corporate ;;
    8) show_design8_swiss ;;
    9) show_design9_gradient ;;
    0) show_design10_card ;;
    *) show_design1_matrix ;;  # Default to Matrix style
esac

# Wait for user input before continuing
read -n 1 -s
done
