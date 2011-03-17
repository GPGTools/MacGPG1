#!/bin/sh
##
# Build file for gnupg 1 on OS X.
#
# @author   Alexander Willner <alex@willner.ws>
# @version  2011-02-23
# @see      http://macgpg.sourceforge.net/docs/howto-build-gpg-osx.txt.asc
##


url="ftp://ftp.gnupg.org/gcrypt/gnupg/";
version="gnupg-1.4.11";
fileExt=".tar.gz";
sigExt=".tar.gz.sig"
build="`pwd`/build/gnupg";
target="`pwd`/build/MacGPG1";
gpgFile="Makefile.gpg";

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

./configure CFLAGS="-arch ppc -arch x86_64 -arch i386" --disable-dependency-tracking --disable-asm --prefix="$target" && \
make && \
make check

if [ "$?" != "0" ]; then
    echo "Could not compile the sources!";
    exit 1;
fi

make install

popd > /dev/null
