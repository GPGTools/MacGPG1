PROJECT = MacGPG1
TARGET = MacGPG1
PRODUCT = MacGPG1
VPATH = build

include Dependencies/GPGTools_Core/newBuildSystem/Makefile.default

$(PRODUCT):
	@./build.sh

