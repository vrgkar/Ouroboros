.section .header
.code16gcc

setup_sects:                .byte   0
root_flags:                 .word   0
syssize:                    .long   0  
ram_size:                   .word   0
vid_mode:                   .word   0
root_dev:                   .word   0
boot_flag:                  .word   0xAA55
jump:                       .byte   0xEB
                            .byte   end - . - 1
header:                     .ascii  "HdrS"
version:                    .word   0     
realmode_swtch:             .long   0
start_sys_seg:              .word   0
kernel_version:             .word   0
type_of_loader:             .word   0
loadflags:                  .byte   0
setup_move_size:            .word   0
code32_start:               .long   0
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
kernel_info_offset:         .long   0xABCD

end: