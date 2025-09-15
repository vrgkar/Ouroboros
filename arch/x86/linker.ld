OUTPUT_FORMAT("elf32-i386")
ENTRY(_start)

SECTIONS
{
  /* Boot sector at start of file */
  . = 0x7C00;

  .text : {
    *(.bootsect);

    . = 0x1F1;

    *(.header);
    *(.start);

    . = ALIGN(0x10);

    *(.text) *(.text*)
  }

  . = ALIGN(0x1000);

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
}
