!#/bin/bash

INSTALL_FOLDER=~/.macsetup
mkdir -p $INSTALL_FOLDER
MAC_SETUP_ZSHRC=$INSTALL_FOLDER/macsetup_zshrc
MAC_SETUP_Z_PROFILE=$INSTALL_FOLDER/macsetup_zprofile

# Install brew
if ! hash brew
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update
else
  printf "\e[93m%s\e[m\n" "You already have brew installed."
fi

# Make sure that all environmentvariables are set up properly
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $MAC_SETUP_ZSHRC
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install curl
brew install curl
# Put the curl we installed in PATH
echo '# curl related settings' >> $MAC_SETUP_ZSHRC
echo 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' >> $MAC_SETUP_ZSHRC
# For pkg-config to find curl you may need to set:
echo 'export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"' >> $MAC_SETUP_ZSHRC

# Install git
brew install git
# Put the git we installed into PATH
echo 'export PATH="/opt/homebrew/opt/git/bin/"' >> $MAC_SETUP_ZSHRC

# Install zsh
brew install zsh
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install zsh plugins 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i '' 's/plugins=(git)/plugins=(git colored-man-pages colorize pip python brew macos zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
# Change date used by zsh to ISO format
sed -i '' 's/# HIST_STAMPS="mm/dd/yyyy"/HIST_STAMPS="yyyy-mm-dd"/g' ~/.zshrc 

# Various CLI tools
brew install tmux
brew install htop
brew install tree
brew install ack # alternative grep
brew install jq
brew install tldr # simple crowdsourced manpages
brew install wget
brew install lsd # better ls
brew install btop # htop alternative
# Install fonts for lsd. Remembrer to set the fonts in terminal/iterm
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

# Python stuff
# Install python build dependencies
brew install openssl readline sqlite3 xz zlib
{
  echo ' '
  echo '# Python related stuff'
  echo 'export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"'
  echo 'export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"'
  echo 'export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig"'
} >> $MAC_SETUP_ZSHRC

brew install python
pip install --user pipenv
pip install --upgrade setuptools
pip install --upgrade pip
brew install pyenv
brew install pyenv-virtualenv

{
echo 'eval "$(pyenv init -)"'
eval "$(pyenv virtualenv-init -)"
} >> $MAC_SETUP_ZSHRC

{
  echo "# Python related stuff"
  echo 'eval "$(pyenv init --path)"'
} >> $MAC_SETUP_Z_PROFILE

# Utilities for a nicer MacOS experience
brew install --cask rectangle # Window snapping and resizing
brew install --cask mos # Smooth scrolling and indipendent scroll direction for mouse/trackpad
brew install --cask alt-tab # Windows style alt-tab
brew install --cask lunar # Adaptive brightness for external displays and full brightness range on MBP

# Other software
brew install --cask iterm2
brew install --cask spotify
brew install --cask telegram
brew install --cask visual-studio-code
brew install --cask adobe-creative-cloud
brew install --cask firefox
brew install --cask steam
brew install --cask google-chrome

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
} >> $MAC_SETUP_ZSHRC

# Write and reaload profile files.
{
  echo "source $MAC_SETUP_Z_PROFILE # alias and things added by mac_setup script"
} >> "$HOME/.zprofile"
source "$HOME/.zprofile"
{
  echo "source $MAC_SETUP_ZSHRC # alias and things added by mac_setup script"
} >> "$HOME/.zshrc"
source "$HOME/.zshrc"
