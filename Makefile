all: compile

init:
	@mkdir -p build

compile: init
	@./build-script.sh

clean:
	rm -fr build/

dmg: init
	./Dependencies/GPGTools_Core/scripts/create_dmg.sh

update: init
	git submodule foreach git pull origin master
	git pull
