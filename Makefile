CC_X86_16 := gcc
CFLAGS_X86_16 := -m16 -ffreestanding -nostdlib -nostartfiles

CC_X86_32 		:= gcc
CFLAGS_X86_32 	:= -m32 -ffreestanding -nostdlib -nostartfiles


TARGET			:= Ouroboros

ARCH			:= arch
KERNEL   		:= kernel
BUILD			:= build

ARCH_X86_16		:= arch/x86_16
ARCH_X86_32		:= arch/x86_32

BUILD_X86_16	:= build/x86_16
BUILD_X86_32	:= build/x86_32

TARGET_X86_16	:= $(BUILD_X86_16)/$(TARGET)
TARGET_X86_32	:= $(BUILD_X86_32)/$(TARGET)

ARCH_X86_16_ASM	:= $(notdir $(wildcard $(ARCH_X86_16)/*.S))
ARCH_X86_16_SRC	:= $(notdir $(wildcard $(ARCH_X86_16)/*.c))

ARCH_X86_32_ASM	:= $(notdir $(wildcard $(ARCH_X86_32)/*.S)) 
ARCH_X86_32_SRC	:= $(notdir $(wildcard $(ARCH_X86_32)/*.c))

KERNEL_ASM		:= $(notdir $(wildcard $(KERNEL)/*.S)) 
KERNEL_SRC		:= $(notdir $(wildcard $(KERNEL)/*.c))

ARCH_X86_16_OBJ	:= $(addprefix $(BUILD_X86_16)/, $(ARCH_X86_16_ASM:.S=.o)) $(addprefix $(BUILD_X86_16)/, $(ARCH_X86_16_SRC:.c=.o))
ARCH_X86_32_OBJ	:= $(addprefix $(BUILD_X86_32)/, $(ARCH_X86_32_ASM:.S=.o)) $(addprefix $(BUILD_X86_32)/, $(ARCH_X86_32_SRC:.c=.o))

KERNEL_X86_16_OBJ	:= $(addprefix $(BUILD_X86_16)/, $(KERNEL_ASM:.S=.o)) $(addprefix $(BUILD_X86_16)/, $(KERNEL_SRC:.c=.o))
KERNEL_X86_32_OBJ	:= $(addprefix $(BUILD_X86_32)/, $(KERNEL_ASM:.S=.o)) $(addprefix $(BUILD_X86_32)/, $(KERNEL_SRC:.c=.o))

OBJ_X86_16			:= $(ARCH_X86_16_OBJ) $(KERNEL_X86_16_OBJ)
OBJ_X86_32			:= $(ARCH_X86_32_OBJ) $(KERNEL_X86_32_OBJ)

LINKER_X86_16		:= $(wildcard $(ARCH_X86_16)/*.ld)
LINKER_X86_32		:= $(wildcard $(ARCH_X86_32)/*.ld)


$(BUILD_X86_16)/%.o: $(ARCH_X86_16)/%.S | $(BUILD_X86_16)
	$(CC_X86_16) $(CFLAGS_X86_16) -o $@ -c $^

$(BUILD_X86_16)/%.o: $(ARCH_X86_16)/%.c | $(BUILD_X86_16)
	$(CC_X86_16) $(CFLAGS_X86_16) -o $@ -c $^

$(BUILD_X86_32)/%.o: $(ARCH_X86_32)/%.S | $(BUILD_X86_32)
	$(CC_X86_32) $(CFLAGS_X86_32) -o $@ -c $^

$(BUILD_X86_32)/%.o: $(ARCH_X86_32)/%.c | $(BUILD_X86_32)
	$(CC_X86_32) $(CFLAGS_X86_32) -o $@ -c $^

$(BUILD_X86_16)/%.o: $(KERNEL)/%.c | $(BUILD_X86_16)
	$(CC_X86_16) $(CFLAGS_X86_16) -o $@ -c $^

$(BUILD_X86_16)/%.o: $(KERNEL)/%.S | $(BUILD_X86_16)
	$(CC_X86_16) $(CFLAGS_X86_16) -o $@ -c $^

$(BUILD_X86_32)/%.o: $(KERNEL)/%.c | $(BUILD_X86_32)
	$(CC_X86_32) $(CFLAGS_X86_32) -o $@ -c $^

$(BUILD_X86_32)/%.o: $(KERNEL)/%.S | $(BUILD_X86_32)
	$(CC_X86_32) $(CFLAGS_X86_32) -o $@ -c $^

all: build_x86_16 build_x86_32

build: build_x86_32

build_x86_16: $(OBJ_X86_16) | $(BUILD_X86_16)
	$(CC_X86_16) $(CFLAGS_X86_16) -Wl,--oformat=binary -Wl,-T $(LINKER_X86_16) $^ -o $(TARGET_X86_16)
	truncate -s 1440K $(TARGET_X86_16)

build_x86_32: $(OBJ_X86_32) | $(BUILD_X86_32)
	$(CC_X86_32) $(CFLAGS_X86_32) -Wl,--oformat=binary -Wl,-T $(LINKER_X86_32) $^ -o $(TARGET_X86_32)
	truncate -s 1440K $(TARGET_X86_32)


$(BUILD):
	-mkdir -p $(BUILD)

$(BUILD_X86_16):
	-mkdir -p $(BUILD_X86_16)

$(BUILD_X86_32):
	-mkdir -p $(BUILD_X86_32)


run:
	qemu-system-i386 $(TARGET_X86_16)

run_x86_16:
	qemu-system-i386 $(TARGET_X86_16)

run_x86_32:
	qemu-system-i386 $(TARGET_X86_32)

clean:
	-rm -rf $(BUILD)

clean_x86_16:
	-rm -rf $(BUILD_X86_16)

clean_x86_32:
	-rm -rf $(BUILD_X86_32)

.PHONY: clean clean_x86_16 clean_x86_32 run run_x86_16 run_x86_32
