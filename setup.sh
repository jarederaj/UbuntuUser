#!/bin/bash

#############
# Functions #
#############

sanitize_continue () {
  if [ $CONTINUE == "y" ] || \
  [ $CONTINUE == "Y" ] || \
  [ $CONTINUE == "yes" ] || \
  [ $CONTINUE == "Yes" ] || \
  [ $CONTINUE == "YES" ]; then
    CONTINUE=true
  else
    CONTINUE=false
  fi
}

###########
# ROUTING #
###########

USER=`sudo who am i | awk '{print $1}'`

echo "############################################################################"
echo "##"
echo "## This script is designed to build up a working user account on Ubuntu"
echo "## Server 12.04+."
echo "##"
echo "## You may need to run the following to make this script work:"
echo "##"
echo "## $> adduser $USER sudo"
echo "## $> chsh (select /bin/bash)"
echo "##"
echo "##                          !!! WARNING !!!"
echo "##"
echo "## If this isn't being run by a fresh user account senistive and important"
echo "## files will probably be overwritten. You are responsible for changes that"
echo "## occur when this script is run."
echo "##"
echo "## Are you sure you want to continue? (y/N)"
echo "##"
echo "############################################################################"

read CONTINUE
sanitize_continue
if [ $CONTINUE != true ] ; then
  exit
fi

if [ $(id -u) != "0" ] ; then
  
  SSH=$HOME/.ssh
  mkdir -p $SSH
  chown $USER:$USER $SSH
  chmod 700 $SSH
  
  sudo ufw enable
  sudo ufw allow 22
  
  echo "############################################################################"
  echo "##"
  echo "## Updating, upgrading and installing system dependencies..."
  echo "##"
  echo "############################################################################"
  
  sudo apt-get update
  sudo apt-get upgrade
  
  sudo apt-get install \
  exuberant-ctags \
  finch \
  gcc \
  git \
  git-flow \
  htop \
  lynx \
  mutt \
  nodejs \
  npm \
  openssl \
  openssh-server \
  php-pear \
  python \
  python-devel \
  python-pip \
  ipython \
  ruby \
  rake \
  screen \
  tree \
  vim \
  vim-common \
  vim-dbg \
  vim-gtk
  
  sudo npm install -g jslint
  
  sudo updatedb
  
  echo "############################################################################"
  echo "##"
  echo "## configuring ssh..."
  echo "##"
  echo "############################################################################"
  
  SSHCONF=/etc/ssh/ssh_config
  `sudo sed -i 's|IdentityFile \~/.ssh/id_rsa|&\n    &|g' $SSHCONF`
  `sudo sed -i 's|RSAAuthentication yes|&\n    &|g' $SSHCONF`
  `sudo sed -i 's|^\s\s\s\sGSSAPIAuthentication|#   GSSAPI|g' $SSHCONF`
  `sudo sed -i 's|#AuthorizedKeysFile|AuthorizedKeysFile|g' $SSHCONF`
  
  CONTINUE=true
  while [ $CONTINUE == true ] ; do
    echo "############################################################################"
    echo "##"
    echo "## Do you have a(nother) public key to add to ~/.ssh/authorized_keys? (y/N)"
    echo "##"
    echo "############################################################################"
    
    read CONTINUE
    sanitize_continue
    
    if [ $CONTINUE == true ] ; then
      echo "############################################################################"
      echo "##"
      echo "## Please paste that public key here:"
      echo "##"
      echo "############################################################################"
      
      read KEY
      echo $KEY >> $SSH/authorized_keys
    fi
  done
  
  chown $USER:$USER $HOME/.ssh
  chown $USER:$USER $HOME/.ssh/*
  chmod -R 400 $HOME/.ssh/*
  chmod -R 600 $HOME/.ssh/authorized_keys
  chmod -R 600 $HOME/.ssh/known_hosts
  chmod -R 700 $HOME/.ssh
  cd $HOME/.ssh
  ssh-keygen -t -b 4096 rsa
  
  echo "############################################################################"
  echo "##"
  echo "## install php_codesniffer..."
  echo "##"
  echo "############################################################################"
  
  pear install PHP_CodeSniffer
  
  echo "############################################################################"
  echo "##"
  echo "## configuring bash, vim, and screen..."
  echo "##"
  echo "############################################################################"
  
  mkdir -p $HOME/.scripts/bin
  cp -r bin/* ~/.scripts/bin
  
    cat >>$HOME/.bash_profile << EOL
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOL
  mkdir $HOME/tmp
  chown $USER:$USER $HOME/tmp
  
  cp etc/vimrc $HOME/.vimrc
  chown $USER:$USER $HOME/.vimrc
  
  cp etc/screenrc $HOME/.screenrc
  chown $USER:$USER $HOME/.screenrc
  chmod 766 $HOME/.screenrc
  
  cp etc/bashrc $HOME/.bashrc
  chown $USER:$USER $HOME/.bashrc
  chmod 766 $HOME/.bashrc
  
  EXC=$HOME/.rgrep-excludes
  touch $EXC
  chown $USER:$USER $EXC
  chmod 766 $EXC
  
  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  vim +BundleInstall +qall
  
  SYNTAX=$HOME/.vim/syntax
  mkdir $SYNTAX
  cd $SYNTAX
  wget http://www.vim.org/scripts/download_script.php?src_id=8651
  PHPTAR=php.tar.gz
  mv download_script.php?src_id=8651 $PHPTAR
  tar -zxvf $PHPTAR
  cp syntax/php.vim ./
  rmdir syntax
  rm $PHPTAR
  
  wget http://www.vim.org/scripts/download_script.php?src_id=10728
  mv download_script.php?src_id=10728 javascript.vim
  
  wget http://www.vim.org/scripts/download_script.php?src_id=17429
  mv download_script.php?src_id=17429 python.vim
  
  source $HOME/.bashrc
  
  echo "############################################################################"
  echo "##"
  echo "## Give me a unique name for your screen sessions.  Something like:"
  echo "##"
  echo "## jared@jpad.pyscape.com"
  echo "##"
  echo "##"
  echo "############################################################################"
  
  read IDENTIFIER
  `sed -i 's|__user__|'$IDENTIFIER'|g' $HOME/.screenrc`
  
else
  echo "############################################################################"
  echo "##"
  echo "## You cannot run this script as root or with sudo"
  echo "##"
  echo "############################################################################"
fi
