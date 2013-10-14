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
echo "## Dependencies installed and system updated"
echo "##"
echo "############################################################################"
