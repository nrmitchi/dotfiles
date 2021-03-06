#!/usr/bin/env zsh

# A simple script for setting up OSX dev environment.

dev="$HOME/Developer"
pushd .
mkdir -p $dev
cd $dev

echo 'Enter new hostname of the machine (e.g. macbook-nrmitchi)'
  read hostname
  echo "Setting new hostname to $hostname..."
  scutil --set HostName "$hostname"
  compname=$(sudo scutil --get HostName | tr '-' '.')
  echo "Setting computer name to $compname"
  scutil --set ComputerName "$compname"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$compname"

pub=$HOME/.ssh/id_rsa.pub
echo 'Checking for SSH key, generating one if it does not exist...'
  [[ -f $pub ]] || ssh-keygen -t rsa

echo 'Copying public key to clipboard. Paste it into your Github account...'
  [[ -f $pub ]] && cat $pub | pbcopy
  open 'https://github.com/account/ssh'

# If we on OS X, install homebrew and tweak system a bit.
if [[ `uname` == 'Darwin' ]]; then
  which -s brew
  if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    brew update
  fi

  echo 'Tweaking OS X...'
    source 'etc/osx.sh'

  # http://github.com/sindresorhus/quick-look-plugins
  # echo 'Installing Quick Look plugins...'
  #   brew tap phinze/homebrew-cask
  #   brew install brew-cask
  #   brew cask install suspicious-package quicklook-json qlmarkdown qlstephen qlcolorcode
fi

echo 'Symlinking config files...'
  source 'bin/symlink-dotfiles.sh'

install_tools() {
  echo "Installing:"
  install_languages
  install_system_tools
  install_applications
}

install_languages() {
  echo """
    Installing Language Tools and Runtimes:
      - node
      - npm
      - ruby
  """
  brew install \
    node \
    npm \
    ruby
}

install_system_tools() {
  echo """
    Installing System/Dev Tools:
      - htop
      - wget
      - nginx
      - docker
      - virtualbox
      - minikube
  """

  # Install Homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  brew install \
    htop \
    trash \
    wget \
    jq \
    python-yq \
    nginx

  brew install \
    kubernetes-cli \
    kops \
    kubectx \
    fzf

  brew install awscli

  brew cask install \
    docker \
    virtualbox \
    minikube

  brew cask install \
    iterm2 \
    hub
}

install_applications() {
  echo """
    Installing applications from Homebrew:
      - alfred
      - amethyst
      - 1password
      - dropbox
      - firefox
      - google-chrome
      - skitch
      - slack
      - sublime-text
  """

  brew cask install \
    alfred \
    amethyst \
    1password \
    dropbox \
    firefox \
    google-chrome \
    skitch \
    slack \
    sublime-text \
    visual-studio-code
}

echo 'Would you like to install all your basic applications and tools?'
echo 'n / y'
read install_it_all
[[ "$install_it_all" == 'y' ]] && install_tools

popd
