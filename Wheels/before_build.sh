#!/bin/bash

set -e

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "pwd"
pwd
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

CURRENT_DIR=$(pwd)

#echo "XYZ BEGIN unpack eigen"
#curl -O -L https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz
#tar zxvf eigen-3.4.0.tar.gz
#cd eigen-3.4.0
#mkdir build
#cd build
#cmake ..
#cd ../..
#echo "XYZ END unpack eigen"

#echo "XYZ BEGIN unpack zlib"
#curl -O -L https://www.zlib.net/zlib-1.3.1.tar.gz
#tar xzvf zlib-1.3.1.tar.gz
#cd zlib-1.3.1
#./configure
#make
#cd ..
#echo "XYZ END unpack zlib"

echo "XYZ BEGIN unpack boost"
# Setup Boost
curl -O -L https://boostorg.jfrog.io/artifactory/main/release/1.74.0/source/boost_1_74_0.tar.gz
tar xfz boost_1_74_0.tar.gz
cd boost_1_74_0
export Eigen3_DIR=$CURRENT_DIR/eigen-3.4.0
./bootstrap.sh --with-libraries=date_time,filesystem,iostreams,log,regex,serialization,system,thread,timer
./b2 install -sZLIB_SOURCE=$CURRENT_DIR/zlib-1.3.1
cd ..
echo "XYZ END unpack boost"

echo "Build ORE"
 apt update && apt install -y ninja-build
pwd
cd ORE
mkdir SharedLibs
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DORE_USE_ZLIB=ON -DQL_BUILD_EXAMPLES=false -DQL_BUILD_TEST_SUITE=false -DQL_BUILD_BENCHMARK=false -DQL_ENABLE_SESSIONS=true -DORE_BUILD_DOC=false -G "Ninja" ..
cmake --build . -j $(nproc)

echo "BUILD ORE-SWIG"
pwd
cd ..
cd ..
cd OREAnalytics-SWIG/Python
python setup.py wrap

cp build/QuantExt/qle/libQuantExt.so SharedLibs
cp build/OREData/ored/libOREData.so SharedLibs
cp build/OREAnalytics/orea/libOREAnalytics.so SharedLibs
cp build/QuantLib/ql/libQuantLib.so.1
cp build/QuantLib/ql/libQuantLib.so
cp build/QuantLib/ql/libQuantLib.so.1.31.1



echo "LD LIBRARY: " 
echo $LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH":/usr/local/lib
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH":$CURRENT_DIR/ORE/SharedLibs
echo "LD LIBRARY AFTER: " 
echo $LD_LIBRARY_PATH