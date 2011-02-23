#!/bin/sh

stdDir="/usr/local";
gpgDir="/usr/local/MacGPG1";

[ -f $stdDir/bin/gpg ]  || ln -s $gpgDir/bin/gpg $stdDir/bin/gpg

exit 0
