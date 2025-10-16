.code16
.org 0x7C00

.section .boot
.globl _start

.balign 16

_start:
    cli

    xorw %ax, %ax                           # Set AX = 0
    movw %ax, %ds                           # Set DS = 0
    movw %ax, %ss                           # Set SS = 0
    movw %ax, %es                           # Set ES = 0
    movw $_start, %sp                       # Set SP = _start

    xorb __setup_sects, %al
    movw $(_start + 0x200), %bx             # Load disk sectors starting from the next sector in memory
    movw $0x2, %cx                          # Start reading from sector 2 of disk
    xorb %dh, %dh                           # Set head number to 0
    movw $3, %si                            # Retry disk operation 3 times

read:
    xorb $0x2, %ah                          # Read disk sectors
    int $0x13                               # Execute BIOS interrupt
    jnc success

reset:
    xorb %ah, %ah                           # Reset disk head              
    int $0x13                               # Execute BIOS interrupt
    jc fail                  

    dec %si
    jnz read

fail:
    hlt
    jmp fail

success:
    jmp $(_start+0x200)

.macro SEG_DESC base, limit, type=0, A=1, RW=1, DC=0, DPL=1, E=0, S=1, P=1, L=0, DB=1, G=1
    .word \limit & 0xFFFF
    .word \base & 0xFFFF
    .byte (\base >> 16) & 0xFF
    .byte (\P << 7) | (\DPL << 6) | (\S << 4) | (\E << 3) | (\DC << 2) | (\RW << 1) | \A
    .byte (\G << 7) | ((\DB & ~\L) << 6) | (\L << 5) | ((\limit >> 16) & 0xF)
    .byte (\base >> 24)
.endm

gdt:
    .quad 0                                         # Null Descriptor
    SEG_DESC base=0, limit=0xFFFFF, E=0, S=1        # Data Segment Descriptor
    SEG_DESC base=0, limit=0xFFFFF, E=1, S=1        # Code Segment Descriptor

gdtr:
    .word . - gdt - 1
    .long gdt         

.section .setup
.org 0x7DF1 

setup_sects:                .byte   __setup_sects
root_flags:                 .word   0
syssize:                    .long   __syssize  
ram_size:                   .word   0
vid_mode:                   .word   0
root_dev:                   .word   0
boot_flag:                  .word   0xAA55
jump:                       .byte   0xEB
                            .byte   setup - . - 1
header:                     .ascii  "HdrS"
version:                    .word   0     
realmode_swtch:             .long   0
start_sys_seg:              .word   0
kernel_version:             .word   0
type_of_loader:             .word   0
loadflags:                  .byte   0
setup_move_size:            .word   0
code32_start:               .long   __code32_start
ramdisk_image:              .long   0
bootsect_kludge:            .long   0
heap_end_ptr:               .word   0 
ext_loader_ver:             .byte   0
ext_loader_type:            .byte   0
cmd_line_ptr:               .long   0
initrd_addr_max:            .long   0
kernel_alignment:           .long   0
relocatable_kernel:         .byte   0
min_alignment:              .byte   0
xloadflags:                 .word   0
cmdline_size:               .long   0
hardware_subarch:           .long   0
hardware_subarch_data:      .quad   0
payload_offset:             .long   0
payload_length:             .long   0
setup_data:                 .quad   0
pref_address:               .quad   0
init_size:                  .long   0
handover_offset:            .long   0
kernel_info_offset:         .long   0

setup:
    lgdt gdtr

    movl %cr0, %eax
    orl $1, %eax
    movl %eax, %cr0

    ljmp $code32_start