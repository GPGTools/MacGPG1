#!/bin/sh
##
# Build file for gnupg 1 on OS X.
#
# @author   Alex
# @version  2011-10-14
# @history  2011-02-23 Final version for 10.6
#           2011-10-14 Initial version for 10.7
# @see      http://macgpg.sourceforge.net/docs/howto-build-gpg-osx.txt.asc
##

################################################################################
url="ftp://ftp.gnupg.org/gcrypt/gnupg/";
version="gnupg-1.4.11";
fileExt=".tar.gz";
sigExt=".tar.gz.sig"
build="`pwd`/build/gnupg";
prefix_build="`pwd`/build/MacGPG1";
prefix_install="/usr/local/MacGPG1"
gpgFile="Makefile.gpg";
################################################################################

################################################################################
os_ver=`sw_vers -productVersion|cut -f2 -d'.'`
if [ $os_ver -ge 7 ]; then
    export MACOSX_DEPLOYMENT_TARGET="10.6"
    export CFLAGS="-mmacosx-version-min=10.6 -DUNIX -isysroot /Developer/SDKs/MacOSX10.6.sdk -arch x86_64"
else
    export MACOSX_DEPLOYMENT_TARGET="10.5"
    export CFLAGS="-mmacosx-version-min=10.5 -DUNIX -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch i386 -arch ppc"
fi
################################################################################

pushd "$1" > /dev/null

gpg --import "$gpgFile";
mkdir -p "$build";
mkdir -p "$target";
cd "$build";

if [ ! -e "$version$fileExt" ]; then
    curl -O "$url$version$fileExt"
    curl -O "$url$version$sigExt"
fi
gpg --verify "$version$sigExt"

if [ "$?" != "0" ]; then
    echo "Could not get the sources!";
    exit 1;
fi

tar -xzf "$version$fileExt";
cd "$version";
./configure \
  --enable-static=yes \
  --disable-endian-check \
  --disable-dependency-tracking \
  --disable-asm \
  --enable-osx-universal-binaries \
  --prefix="$prefix_install" && \
make -j2
#&& \
#make check

if [ "$?" != "0" ]; then
    echo "Could not compile the sources!";
    exit 1;
fi

make prefix="$prefix_build" install

popd > /dev/null
