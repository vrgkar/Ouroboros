.code16

.section .boot
.globl _start

_start:
    cli

    xorw %ax, %ax                           # Set AX = 0
    movw %ax, %ds                           # Set DS = 0
    movw %ax, %ss                           # Set SS = 0
    movw %ax, %es                           # Set ES = 0
    movw $_start, %sp                       # Set SP = _start

    xorb $__setup_sects, %al
    movw $(_start + 0x200), %bx             # Load disk sectors starting from the next sector in memory
    movw $0x2, %cx                          # Start reading from sector 2 of disk
    xorb %dh, %dh                           # Set head number to 0
    movw $3, %si                            # Retry disk operation 3 times
    movw $jump, %di                       # On success, jump to 'success' label

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
    jmp *%di

.section .setup

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

    movb $(__syssectors), %al
    movw $(__code32_start), %bx                 # Load disk sectors starting from the next sector in memory
    movw $(__code32_start_sector), %cx          # Start reading from the sector where 32-bit code starts
    xorb %dh, %dh                               # Set head number to 0
    movw $3, %si                                # Retry disk operation 3 times
    movw $success32, %di                         # On success, jump to 'success32'

    jmp read

success32:
    lgdt gdtr

    movl %cr0, %eax
    orl $1, %eax
    movl %eax, %cr0

    ljmp $8, $(__code32_start)

.macro GDT_SEG_DESC base, limit, flags, access
    .word \limit & 0xFFFF
    .word \base & 0xFFFF
    .byte (\base >> 16) & 0xFF
    .byte \access & 0xFF
    .byte (\flags & 0xF0) | ((\limit >> 16) & 0xF)
    .byte (\base >> 24) & 0xFF
.endm

gdt:
    .quad 0
    GDT_SEG_DESC base=0, limit=0xFFFFF, flags=0xC, access=0x9A
    GDT_SEG_DESC base=0, limit=0xFFFFF, flags=0xC, access=0x92

gdtr:
    .word . - gdt - 1
    .long gdt         
