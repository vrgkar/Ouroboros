#include "assert.h"
#include "defs.h"
#include "gdt.h"
#include "idt.h"
#include "stdnoreturn.h"

void noreturn main(void)
{
    gdt_push(GDT_SEG_DESC(0, 0xFFFFF, 0x0C, 0x9A)); // Code Segment
    gdt_push(GDT_SEG_DESC(0, 0xFFFFF, 0x0C, 0x92)); // Data Segment

    gdt_load();

    idt_init();
    idt_load();

    while (1)
        asm volatile("hlt");
}
