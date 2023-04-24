SRC = source
TEMP = temp

all: build clean run

mbr.bin: ${SRC}/MBR/mbr.asm
	nasm -f bin $^ -o ${TEMP}/$@

build: mbr.bin kernel.o kentry.o kernel.bin os.bin os.img

kernel.o: ${SRC}/kernel/kernel.c
	gcc -m32 -ffreestanding -fno-pie -c $^ -o ${TEMP}/$@

kentry.o: ${SRC}/kernel/entry.asm
	nasm $^ -f elf -o ${TEMP}/$@

kernel.bin: ${TEMP}/kentry.o ${TEMP}/kernel.o
	ld -m elf_i386 -o ${TEMP}/$@ -Ttext 0x1000 $^ --oformat binary

os.bin: ${TEMP}/mbr.bin ${TEMP}/kernel.bin
	cat $^ > ${TEMP}/$@

os.img: ${TEMP}/os.bin
	dd if=/dev/zero of=$@ bs=1024 count=1440
	dd if=$^ of=$@ conv=notrunc

run: os.img
	qemu-system-i386 -fda $^

clean:
	rm -rf build/*