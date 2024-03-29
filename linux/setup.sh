#!/usr/bin/bash

CONFIG_FOLDER=~/.zsh
mkdir -p $CONFIG_FOLDER
EXT_ZSHRC=$CONFIG_FOLDER/.ext_zshrc
EXT_Z_PROFILE=$CONFIG_FOLDER/.ext_zprofile

sudo apt update && apt upgrade -y

# Install zsh
sudo apt install zsh -y
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install zsh plugins 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i 's/plugins=(git)/plugins=(git colored-man-pages colorize pip python brew macos zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
# Change date used by zsh to ISO format
sed -i 's/# HIST_STAMPS="mm\/dd\/yyyy"/HIST_STAMPS="yyyy-mm-dd"/g' ~/.zshrc
# Install powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
# Set default shell as zsh
chsh -s $(which zsh)

{
  echo "# Lines configured by zsh-newuser-install"
  echo "HISTFILE=~/.histfile"
  echo "HISTSIZE=10000"
  echo "SAVEHIST=10000"
  echo "setopt notify"
  echo "bindkey -v"
} >> "$HOME/.zshrc"

# CLI tools
sudo apt install htop -y
sudo apt install btop -y
sudo apt install tree -y
sudo apt install ack -y
sudo apt install tldr -y
sudo apt install htop -y

# Install Nerd-fonts for LSD
mkdir tmpdir && cd tmpdir &&
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraMono.zip && # Replace this with the font you want to use
unzip FiraMono.zip &&
mkdir ~/.fonts && cp * ~/.fonts

#Install LSD
TEMP_DEB="$(mktemp)" &&
wget -O "$TEMP_DEB" 'https://github.com/Peltoche/lsd/releases/download/0.22.0/ &&lsd_0.22.0_amd64.deb' &&
sudo dpkg -i "$TEMP_DEB"
cd .. && rm -f tmpdir

# Developer stuff
sudo apt install sqlite3 python3-pip -y
pip3 install --upgrade pip
pip3 install --user pipenv
pip3 install --upgrade setuptools
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

{
  echo '# In this extension file goes all configuration not directly related to ZSH'
  echo ''
  echo ''
} >> $EXT_Z_PROFILE

{
  echo '# In this extension file goes all configuration not directly related to ZSH'
  echo ''
  echo ''
} >> $EXT_ZSHRC

{
  echo '# Pyenv related'
  echo 'export PYENV_ROOT="$HOME/.pyenv"'
  echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
  echo 'eval "$(pyenv init -)"'
  echo 'eval "$(pyenv virtualenv-init -)"'
  echo ''
} >> $EXT_Z_PROFILE

{
  echo '# Pyenv related'
  echo 'export PYENV_ROOT="$HOME/.pyenv"'
  echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
  echo 'eval "$(pyenv init -)"'
  echo 'eval "$(pyenv virtualenv-init -)"'
  echo ''
} >> $EXT_ZSHRC

# Other software

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https -y
sudo apt update
sudo apt install code -y

# Apple and Keychron keyboard config
# By default there are problems with the FN on some keyboards not working on Ubuntu and derivatives.
# This fix makes the FN keys default and pressing the fn button on the keyboard enables the various media keys.
# This fix requires a restart in case it is done to a live system.

sudo touch /etc/modprobe.d/hid_apple.conf
sudo echo "options hid_apple fnmode=2" > etc/modprobe.d/hid_apple.conf

# Aliases
{
  echo "# Aliases"
  echo ""
  echo "# Aliases for ls and lsd"
  echo "alias ls='lsd'"
  echo "alias l='ls -l'"
  echo "alias la='ls -a'"
  echo "alias lla='ls -la'"
  echo "alias lt='ls --tree'"
  echo ""
} >> $EXT_ZSHRC

# Write and reaload profile files.
{
  echo ""
  echo "source $EXT_Z_PROFILE # Aliases and 3rd party configurations"
  echo ""
} >> "$HOME/.zprofile"
{
  echo ""
  echo "source $EXT_ZSHRC # Aliases and 3rd part configurations"
  echo ""
} >> "$HOME/.zshrc"
