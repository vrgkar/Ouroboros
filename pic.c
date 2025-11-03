#include "pic.h"
#include "asm.h"

void pic_remap(int offset1, int offset2)
{
    uint8_t mask1, mask2;

    inb(PIC1_DATA, &mask1);
    inb(PIC2_DATA, &mask2);

    outb(PIC1_COMMAND, ICW1_INIT | ICW1_ICW4); // Start initialization in cascade mode
    outb(PIC2_COMMAND, ICW1_INIT | ICW1_ICW4); // Start initialization in cascade mode

    // Set vector offsets
    outb(PIC1_DATA, offset1);
    outb(PIC2_DATA, offset2);

    // Setup cascading
    outb(PIC1_DATA, 0x04);
    outb(PIC2_DATA, 0x02);

    // Set 8086/88 mode
    outb(PIC1_DATA, ICW4_8086);
    outb(PIC2_DATA, ICW4_8086);

    // Restore saved masks
    outb(PIC1_DATA, mask1);
    outb(PIC2_DATA, mask2);
}

