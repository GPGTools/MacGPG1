PROJECT = MacGPG1
TARGET = MacGPG1
CONFIG = Release

include Dependencies/GPGTools_Core/make/default

all: compile

init:
	@mkdir -p build

compile: init
	@./build-script.sh

clean:
	rm -fr build/

test: init
	@./build-script.sh check

update-core:
	@cd Dependencies/GPGTools_Core; git pull origin master; cd -
update-me:
	@git pull
update: update-me update-core