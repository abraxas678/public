#!/bin/bash
wait_for_chezmoid() {
    x=1
    while [[ $x = 1 ]]; do
        echo "waiting for toml & key in ~/Downloads"
  #      if [[ ! -f ~/.config/chezmoi/chezmoi.toml ]] || [[ ! -f ~/.config/chezmoi/key.txt ]]; then
            if [[ -f ~/Downloads/chezmoi.toml ]]; then
                if [[ -f ~/Downloads/key.txt ]]; then
                    sleep 5
                    mv ~/Downloads/chezmoi.toml ~/.config/chezmoi/
                    mv ~/Downloads/key.txt ~/.config/chezmoi/
                    chmod 500 ~/.config/chezmoi/chezmoi.toml
                    x=0
                fi
            fi
   #     else
   #         x=0
   #     fi
        sleep 3
        tput cuu1; tput ed
    done
}
[[ $(cat $HOME/.config/chezmoi/chezmoi.toml | wc -l) -lt 3 ]] && wait_for_chezmoid

chezmoi $@
