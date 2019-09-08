
echo "***********************************Installing core tools***********************************"
sudo apt install git curl python-pip autoconf
sudo apt-get install -y python-dev pkg-config
sudo apt-get install -y libavformat-dev libavcodec-dev libavdevice-dev libavutil-dev libswscale-dev libavresample-dev libavfilter-dev

echo "***********************************Upgrading pip***********************************"
sudo pip install --upgrade pip>=18.0

echo "***********************************Installing ffmpeg and required tools***********************************"
sudo apt install ffmpeg libavformat-dev libavcodec-dev libavdevice-dev libavutil-dev libswscale-dev libavresample-dev libavfilter-dev libssl-dev

echo "***********************************Installing build tools like build-essential automake clang***********************************"

sudo apt install autoconf automake clang clang-3.8 libtool pkg-config build-essential
sudo apt install -y libarchive-dev clang llvm

echo "***********************************Installing qt***********************************"

sudo apt install python-qt4
sudo apt install pkg-config 
echo "***********************************Installing zmq required for replaying driving data (to default PATH)***********************************"

curl -LO https://github.com/zeromq/libzmq/releases/download/v4.2.3/zeromq-4.2.3.tar.gz
tar xfz zeromq-4.2.3.tar.gz
cd zeromq-4.2.3
./autogen.sh
./configure CPPFLAGS=-DPIC CFLAGS=-fPIC CXXFLAGS=-fPIC LDFLAGS=-fPIC --disable-shared --enable-static
make
sudo make install
cd ..
rm -rf zeromq-4.2.3
rm -rf zeromq-4.2.3.tar.gz

echo "***********************************Installing Cap'n Proto***********************************"

curl -O https://capnproto.org/capnproto-c++-0.6.1.tar.gz
tar xvf capnproto-c++-0.6.1.tar.gz
cd capnproto-c++-0.6.1
./configure --prefix=/usr/local CPPFLAGS=-DPIC CFLAGS=-fPIC CXXFLAGS=-fPIC LDFLAGS=-fPIC --disable-shared --enable-static
make -j4
sudo make install

cd ..
git clone https://github.com/commaai/c-capnproto.git
cd c-capnproto
git submodule update --init --recursive
autoreconf -f -i -s
CFLAGS="-fPIC" ./configure --prefix=/usr/local
make -j4
sudo make install

cd ..
rm -rf capnproto-c++-0.6.1
rm -rf capnproto-c++-0.6.1.tar.gz
rm -rf c-capnproto
rm -rf "=18.0"



echo "***********************************pip installing! If this fails, remove the version constraint in the requirements.txt for which pip failed***********************************"
echo "***********************************most distros have a shitty old version of python OpenSSL, removing it if it exists... (don't worry, we'll reinstall a recent version)***********************************"
sudo rm -rvf /usr/local/lib/python2.7/dist-packages/OpenSSL/

cd ~/openpilot
pip install --user cryptography pyOpenSSL pyopencl pytools simplejson pygame pyzmq pycapnp subprocess32 libarchive lru_dict hexdump 

unset PYTHONPATH
export PYTHONPATH=~/openpilot/
echo "export PYTHONPATH=~/openpilot/" >> ~/.bashrc

echo "export PYTHONPATH=~/openpilot/" >> ~/.bash_profile
source ~/.bashrc
source ~/.bash_profile

env | grep PYTHONPATH

sudo mkdir /data
sudo mkdir /data/params
sudo chown $USER /data/params

echo "Now, try out some tools! If you get a DataUnreadableError(fn)  when running replay.py -- apply this fix manually https://github.com/commaai/comma2k19/issues/1"

