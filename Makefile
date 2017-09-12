
build/ponyfmt: build ponyfmt/*.pony
	stable env ponyc ponyfmt -o build --debug

build:
	mkdir build

test: build/ponyfmt
	build/ponyfmt

clean:
	rm -rf build

.PHONY: clean test
