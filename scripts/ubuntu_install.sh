
function initialize {
  sudo apt-get update
  sudo apt-get install -y curl git
}

# Install UI
function install_theme {
  sudo add-apt-repository -y ppa:numix/ppa
  sudo apt-get update
  sudo apt-get install -y numix-gtk-theme numix-icon-theme-circle
  sudo apt-get install gnome-tweak-tool
  git clone https://github.com/powerline/fonts.git ~/fonts
  ~/fonts/.install.sh
  rm -rf ~/fonts/
  echo "Powerline fonts was installed. Please change font on terminal setting!!!"
  sudo apt-get install -y unity-tweak-tool
  gsettings set org.gnome.desktop.interface gtk-theme "Numix"
  gsettings set org.gnome.desktop.interface icon-theme 'Numix-circle'
  gsettings set org.gnome.desktop.wm.preferences theme "Numix"
  # ignore gnome draw desktop in i3
  gsettings set org.gnome.desktop.background show-desktop-icons false
}

# Install zsh and oh-my-zsh
function install_terminal_tools {
  echo "Installing zsh and oh-my-zsh..."
  sudo apt-get install -y zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  sudo chsh -s /usr/bin/zsh
  git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  mkdir ~/.fonts/
  mkdir -p .config/fontconfig/conf.d
  fc-cache -vf ~/.fonts/
  curl https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -o ~/.fonts/
  curl https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -o ~/.config/fontconfig/conf.d/

  echo "Install auto suggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  echo "plugins=(zsh-autosuggestions)" >> ~/.zshrc
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

  echo "Install auto zsh sytax highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
  echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
  source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # install thefuck
  sudo apt-get install python3-dev python3-pip python3-setuptools
  sudo pip3 install thefuck

  # install fd
  curl -LO https://github.com/sharkdp/fd/releases/download/v7.3.0/fd-musl_7.3.0_amd64.deb
  sudo dpkg -i fd-musl_7.3.0_amd64.deb

  # install ripgrep
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb
  sudo dpkg -i ripgrep_11.0.1_amd64.deb

  # install up
  curl -LO https://up.apex.sh/install
  chmod +x ./install
  sudo ./install

  # install yarn
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && sudo apt-get install yarn
}

# Install vim and tmux
function install_vim_and_tmux {
  echo "Installing tmux 2.0 and vim."
  sudo add-apt-repository ppa:pi-rho/dev
  sudo apt-get update
  sudo apt-get install -y vim tmux vim-gnome xclip exuberant-ctags

  sudo curl -fsSL https://raw.github.com/mislav/dotfiles/1500cd2/bin/tmux-vim-select-pane \
    -o /usr/local/bin/tmux-vim-select-pane
  sudo chmod +x /usr/local/bin/tmux-vim-select-pane

  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

# Install for web dev
function install_ruby_on_rails {
  echo "Installing ruby and rails"
  sudo apt-get update
  sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev \
    libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev \
    python-software-properties libffi-dev libgdbm-dev libncurses5-dev automake libtool bison nodejs \
    mysql-server mysql-client libmysqlclient-dev

  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  curl -sSL https://get.rvm.io | bash -s stable
  source ~/.rvm/scripts/rvm
  rvm install 2.6.3
  rvm use 2.6.3 --default
  ruby -v
  gem update --system
  gem install bundler

  gem install tmuxinator interactive_editor
  "Done! Rails 5 is not installed."
}

function programs {
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/adtac/climate/master/install)"
  sudo apt-get install -y i3 irssi guake flashplugin-installer xpad \
    nautilus-dropbox ncdu silversearcher-ag autojump
  # Docker
  echo "Install docker and docker-compose"
  wget -qO- https://get.docker.com/ | sh
  COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | tail -n 1`
  sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
  sudo chmod +x /usr/local/bin/docker-compose
  sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
  sudo usermod -aG docker $USER
  echo "Install docker and docker-compose Done!"

  # Visual Studio
  echo "Install Visual Studio"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt update
  sudo apt install code
  echo "Install Visual Studio done!"

  # Google chrome
  echo "Install Google chrome"
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
  sudo apt-get update
  sudo apt-get install google-chrome-stable
  echo "Install Google chrome done!"

  # Sublime Text 3
  echo "Install Sublime Text 3"
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  sudo apt-get update
  sudo apt-get install sublime-text
  echo "Install Sublime Text 3 done!"
  # Install Package Controll
  echo "Install package control"
  curl https://packagecontrol.io/Package%20Control.sublime-package -o ~/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package
  echo "Install package control done!"

  # Ibus-unikey
  echo "Start install Ibus-unikey"
  sudo apt-get install ibus-unikey
  sudo add-apt-repository ppa:ubuntu-vn/ppa
  sudo apt-get update
  ibus restart
  echo "Finished install Ibus-unikey"
  echo "After install, you need open [ Settings ] -> [ Region  & Language ] \
    then add vietnamese-ibus to config"
}

initialize
install_theme
install_terminal_tools
install_ruby_on_rails
install_vim_and_tmux
programs
./install
