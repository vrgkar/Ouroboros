CC_X86 := gcc
CFLAGS_X86 = -m16 -ffreestanding -nostdlib -nostartfiles

TARGET			:= Ouroboros

ARCH			:= arch
KERNEL   		:= kernel
BUILD			:= build
ARCH_X86		:= arch/x86
BUILD_X86		:= build/x86


ARCH_X86_ASM 	:= $(notdir $(wildcard $(ARCH_X86)/*.S))
ARCH_X86_OBJ	:= $(addprefix $(BUILD_X86)/, $(ARCH_X86_ASM:.S=.o))

KERNEL_SRC		:= $(notdir $(wildcard $(KERNEL)/*.c))
KERNEL_X86_OBJ	:= $(addprefix $(BUILD_X86)/, $(KERNEL_SRC:.c=.o))


OBJ_X86			:= $(ARCH_X86_OBJ) $(KERNEL_X86_OBJ)
LINKER_X86		:= $(wildcard $(ARCH_X86)/*.ld)


$(BUILD_X86)/%.o: $(ARCH_X86)/%.S | $(BUILD_X86)
	$(CC_X86) $(CFLAGS_X86) -o $@ -c $^

$(BUILD_X86)/%.o: $(KERNEL)/%.c | $(BUILD_X86)
	$(CC_X86) $(CFLAGS_X86) -o $@ -c $^


all: build_x86

build_x86: $(OBJ_X86) | $(BUILD_X86)
	$(CC_X86) $(CFLAGS_X86) -Wl,--oformat=binary -Wl,-T $(LINKER_X86) $^ -o $(TARGET)
	truncate -s 1440K $(TARGET)

run_x86:
	qemu-system-i386 $(TARGET)

clean: | $(BUILD)
	-rm -rf $(BUILD)
	-rm $(TARGET)

clean_x86: | $(BUILD_X86)
	-rm -rf $(BUILD_X86)

$(BUILD):
	-mkdir -p $(BUILD)

$(BUILD_X86):
	-mkdir -p $(BUILD_X86)


.PHONY: clean clean_x86 run_x86
