hello_world.o: hello_world.asm
	nasm -f macho64 -g hello_world.asm

hello_world: hello_world.o
	ld -macosx_version_min 10.7.0 -o hello_world hello_world.o

.PHONY: clean
clean:
	rm hello_world
	rm hello_world.o

.PHONY: run
run: hello_world
	./hello_world