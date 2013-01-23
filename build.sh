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
url="ftp://ftp.gnupg.org/gcrypt/gnupg/"
version="gnupg-1.4.13"
fileExt=".tar.gz"
sigExt=".tar.gz.sig"
build="$PWD/build/gnupg"
prefix_build="$PWD/build/MacGPG1"
prefix_install="/usr/local/MacGPG1"
gpgKeysFile="$PWD/GnuPG Keys.gpg"
################################################################################

source "./Dependencies/GPGTools_Core/newBuildSystem/core.sh"


if [[ "$1" == "check" ]]; then
	cd "$build/$version"
	make check
	exit $?
fi

function iSysrootFlag {
	sdk_version=$1
	sdk_versions="$sdk_version 10.8 10.7"
	xcode_path=$(xcode-select -print-path)
	if [[ "$xcode_path" == "/Applications/Xcode.app/Contents/Developer" ]]; then
		sdks_path="$xcode_path/Platforms/MacOSX.platform/Developer/SDKs"
	else
		sdks_path="$xcode_path/SDKs"
	fi
	
	# Check if the requested version is available
	for version in $sdk_versions; do
		sdk_path="$sdks_path/MacOSX${version}.sdk"
		if [[ -d "$sdk_path" ]]; then
			echo "-isysroot $sdk_path"
			break
		fi
	done
}

################################################################################
os_ver=$(sw_vers -productVersion | cut -f2 -d.)
#todo: check for ppc gcc and instaleld sdk here instead
if [[ $os_ver -ge 6 ]]; then
    export MACOSX_DEPLOYMENT_TARGET="10.6"
    export CFLAGS="-mmacosx-version-min=10.6 -DUNIX $(iSysrootFlag "10.6") -arch x86_64"
else
    export MACOSX_DEPLOYMENT_TARGET="10.5"
    export CFLAGS="-mmacosx-version-min=10.5 -DUNIX $(iSysrootFlag "10.5") -arch i386 -arch ppc"
fi
################################################################################


mkdir -p "$build"
cd "$build"

if [[ ! -e "$version$fileExt" ]]; then
    curl -O "$url$version$fileExt" && curl -O "$url$version$sigExt" ||
		errExit "Could not get the sources!"
fi


if command -v gpg >/dev/null 2>&1 ;then
	gpg --import "$gpgKeysFile"
    gpg --verify "$version$sigExt" ||
		errExit "Could not verify the sources!"
fi

tar -xzf "$version$fileExt"
cd "$version"
./configure \
  --enable-static=yes \
  --disable-endian-check \
  --disable-dependency-tracking \
  --disable-asm \
  --enable-osx-universal-binaries \
  --prefix="$prefix_install" ||
	errExit "Could not configure the sources!"

make -j2 ||
	errExit "Could not compile the sources!"


make prefix="$prefix_build" install

