OUTPUT_FORMAT("elf32-i386")

SECTIONS
{
  /* Boot sector at start of file */
  . = 0x7C00;

  .text : {

        __bootsect_start = .;

        *(.boot);

        __bootsect_end = .;

        . = 0x1F1;

        __setup_start = .;

        *(.setup);

        __setup_end = .;

        . = ALIGN(0x200);

        __kernel_start = .;

        *(.entry) 

        . = ALIGN(0x1);

        *(.text) *(.text*)
    }

    .rodata : {
        *(.rodata) *(.rodata*)
    }
    .data : {
        *(.data) *(.data*)
    }
    .bss : {
        *(.bss) *(.bss*)
        *(COMMON)
    }

    __kernel_end = .;

    PROVIDE(__setup_bytes = __setup_end - __setup_start);
    PROVIDE(__setup_sects = (__setup_bytes + 511) / 512);
    PROVIDE(__kernel_bytes = __kernel_end - __kernel_start);
    PROVIDE(__syssize = ((__kernel_bytes + 15) / 16));
    PROVIDE(__syssectors = (__setup_bytes + 511) / 512);
    PROVIDE(__code32_start = __kernel_start);
    PROVIDE(__code32_start_sector = (1 + (__kernel_start - __bootsect_start) / 512));

}
