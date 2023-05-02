SRC = source
TEMP = temp

SOURCE_FILES = ${SRC}/kernel/kernel.cpp ${SRC}/kernel/util.c ${SRC}/kernel/graphics/vga.c ${SRC}/kernel/interrupts/idt.c ${SRC}/kernel/interrupts/isr.c
OBJECT_FILES = ${TEMP}/kentry.o ${TEMP}/kernel.o ${TEMP}/util.o ${TEMP}/vga.o ${TEMP}/idt.o ${TEMP}/isr.o

$(shell mkdir -p temp)
$(shell rm -rf temp/*.o)
$(shell rm -rf temp/*.bin)
$(shell rm -rf temp/*.elf)

all: build clean run

mbr.bin: ${SRC}/MBR/mbr.asm
	nasm -f bin $^ -o ${TEMP}/$@

build: mbr.bin kentry.o kernel.o kernel.bin os.bin os.img

kernel.o: ${SOURCE_FILES}
	perl gcc-wrap -c $^ --outdir="${TEMP}"

#debug info
kernel-debug-info.elf: kernel.o ${OBJECT_FILES}
	ld -m elf_i386 -o ${TEMP}/$@ -Ttext 0x7E000 ${OBJECT_FILES}

kentry.o: ${SRC}/kernel/entry.asm
	nasm $^ -f elf -o ${TEMP}/$@

kernel.bin: ${OBJECT_FILES}
	ld -s -m elf_i386 -o ${TEMP}/$@ -Ttext 0x7E000 $^ --oformat binary

os.bin: ${TEMP}/mbr.bin ${TEMP}/kernel.bin
	cat $^ > ${TEMP}/$@

os.img: ${TEMP}/os.bin
	dd if=/dev/zero of=$@ bs=1024 count=1440
	dd if=$^ of=$@ conv=notrunc

run: os.img
	qemu-system-i386 -fda $^

debug-run: build os.img kernel-debug-info.elf
	qemu-system-i386 -s -S -fda os.img -d guest_errors,int &
	gdb -ex "target remote localhost:1234" -ex "symbol-file ${TEMP}/kernel-debug-info.elf"
	rm -rf ${TEMP}/*.elf

clean:
	rm -rf ${TEMP}/*.o
	rm -rf ${TEMP}/*.bin