#!/bin/bash
echo "#####################################################################"
echo "                          INSTALL BREW"
echo "#####################################################################"
echo; sleep 2
countdown 1
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
sudo apt-get install -y build-essential procps curl file git
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile

  export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
  [[ $MY_PUEUE_INST -eq "1" ]] && /home/linuxbrew/.linuxbrew/bin/pueue add -g system-setup -- brew install gcc || brew install gcc | tail -f -n5

(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/abraxas/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
