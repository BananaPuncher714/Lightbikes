SOURCES = $(wildcard *.asm *.c)
HEADERS = $(wildcard *.h)

OBJ := $(filter %.o,$(SOURCES:.asm=.o))
OBJ += $(filter %.o,$(SOURCES:.c=.o))

run: lightbikes
	./lightbikes

all: lightbikes

lightbikes: ${OBJ}
	gcc -static -m64 -o $@ $^

%.o: %.asm
	nasm -felf64 $<

%.o: %.c ${HEADERS}
	gcc -static -m64 -c $< -o $@

clean:
	rm -rf *.o
	rm -f lightbikes