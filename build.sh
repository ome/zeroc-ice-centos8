#!/bin/sh

set -eux

ICE_VERSION=${1:-"3.6.5"}
BUILD=${TRAVIS_BRANCH:-dev}
TARGET_NAME=ice-$ICE_VERSION-$BUILD
TARGET_DIR=/opt/$TARGET_NAME

LIBDB_VERSION=5.3.28
NPROC=`nproc`


######################################################################
# Build libdb from source
cd /
curl -sSfLO http://download.oracle.com/berkeley-db/db-$LIBDB_VERSION.tar.gz
tar -zxf db-$LIBDB_VERSION.tar.gz
cd db-$LIBDB_VERSION
patch -p1 < /src_dbinc_atomic.h.patch
cd build_unix/
../dist/configure --enable-cxx --enable-shared --disable-static --prefix=$TARGET_DIR
make -j$NPROC
make install -j$NPROC
ln -s lib $TARGET_DIR/lib64


######################################################################
# Build ice cpp from source
cd /
curl -sSfLO https://github.com/zeroc-ice/ice/archive/v$ICE_VERSION.tar.gz
tar -zxf v$ICE_VERSION.tar.gz
cd ice-$ICE_VERSION/cpp
MAKE_ARGS="--silent DB_HOME=$TARGET_DIR prefix=$TARGET_DIR RPATH_DIR=$TARGET_DIR/lib -j$NPROC"
make $MAKE_ARGS
make install $MAKE_ARGS
tar -zcf /dist/$TARGET_NAME-centos8-amd64.tar.gz -C /opt $TARGET_NAME


######################################################################
# Zeroc IcePy
# TODO: is it possible to rename the wheel to indicate it's only for CentOS?
cd /
pip3 download "zeroc-ice==$ICE_VERSION"
tar -zxf "zeroc-ice-$ICE_VERSION.tar.gz"
cd "zeroc-ice-$ICE_VERSION"
python3 setup.py --quiet bdist_wheel
cp dist/* /dist/
