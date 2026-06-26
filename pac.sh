#!/usr/bin/env bash
# ~/.local/bin/@pac

yellow="\033[38;2;224;175;104m"
reset="\033[0m"
packages="\033[38;2;158;206;106m󱧘 Packages:\033[30m"

output=$(
  pacman -Sl --color=always | fzf --ansi --multi \
    --preview 'pacman -Si {2}' \
    --preview-window=up:wrap:60% \
    --marker='✓' \
    --prompt=" Search packages: " \
    --header=" Multi select with tab  " \
    --layout=reverse \
    --height=95%
)

[[ -z "$output" ]] && exit 0

mapfile -t pkgs < <(echo "$output" | awk '{print $2}' | sed '/^$/d')

[[ ${#pkgs[@]} -eq 0 ]] && exit 0

echo -e "\n${packages}\n${yellow}${pkgs[*]}${reset}\n"
read -rp "Install selected package(s) with pacman? (Y/n) " reply

if [[ -z "$reply" || "$reply" =~ ^[Yy]$ ]]; then
  sudo pacman -S --needed "${pkgs[@]}"
fi
