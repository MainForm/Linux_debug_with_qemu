KERNEL_BIN_PATH := ./output/images/Image
KERNEL_ELF_PATH := ./output/build/linux-6.1.44/vmlinux
ROOTFS_PATH 	:= ./output/images/rootfs.ext4

GDB_PORT		:= 1234

QEMU 			:= qemu-system-aarch64
QEMU_MACHINE 	:= virt
QEMU_CPU 		:= cortex-a57
QEMU_DRIVE 		:= file=$(ROOTFS_PATH),if=none,format=raw,id=hd0
QEMU_DIVICE 	:= virtio-blk-device,drive=hd0

QEMU_RUN_FLAGS  := 	-append "root=/dev/vda console=ttyAMA0" \
					-nographic

QEMU_DEBUG_FLAGS := -append "root=/dev/vda console=ttyAMA0" \
					-nographic \
					-S -gdb tcp::$(GDB_PORT),ipv4

QEMU_FLAGS  	:= 	-M $(QEMU_MACHINE) 		\
					-cpu $(QEMU_CPU) 		\
					-smp 1					\
					-kernel $(KERNEL_BIN_PATH) 	\
					-drive $(QEMU_DRIVE) 	\
					-device $(QEMU_DIVICE)


GDB_PATH 		:= ./output/host/bin
GDB				:= $(GDB_PATH)/aarch64-buildroot-linux-gnu-gdb

.PHONY: qemu_run qemu_debug gdb

qemu_run:
	$(QEMU) $(QEMU_FLAGS) $(QEMU_RUN_FLAGS)

qemu_debug:
	$(QEMU) $(QEMU_FLAGS) $(QEMU_DEBUG_FLAGS)

gdb:
	$(GDB) $(KERNEL_ELF_PATH)  	\
			-ex "target remote localhost:$(GDB_PORT)" \
			-ex "layout split" \
			-ex "layout src"   \
			-ex "layout regs"	\
			-ex "b start_kernel" \
			-ex "continue"