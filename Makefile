CC_x86 		:= gcc
CFLAGS_x86 	:= -std=gnu17 -m32 -Wall -ffreestanding -nostdlib -nostartfiles
QEMU_x86 := qemu-system-i386

TARGET			:= Ouroboros.img

BUILD_x86	:= build
TARGET_x86	:= $(BUILD_x86)/$(TARGET)

ASM_x86	:= $(wildcard *.S)
KERNEL_x86 := $(wildcard *.c)
OBJ_x86 := $(addprefix $(BUILD_x86)/, $(ARCH_x86:.S=.o) $(KERNEL_x86:.c=.o))
LINKER_x86 := $(wildcard *.ld)


$(BUILD_x86)/%.o: %.S | $(BUILD_x86)
	$(CC_x86) $(CFLAGS_x86) -o $@ -c $^

$(BUILD_x86)/%.o: %.c | $(BUILD_x86)
	$(CC_x86) $(CFLAGS_x86) -o $@ -c $^

all: x86

x86: $(OBJ_x86) | $(BUILD_x86)
	$(CC_x86) $(CFLAGS_x86) -Wl,--oformat=binary -Wl,-T $(LINKER_x86) $^ -o $(TARGET_x86)
	truncate -s 1440K $(TARGET_x86)

qemu_x86:
	$(QEMU_x86) $(TARGET_x86)

clean_x86: | $(BUILD_x86)
	-rm -rf $(BUILD_x86)

$(BUILD_x86):
	-mkdir -p $(BUILD_x86)

.PHONY: qemu_x86 clean_x86
