#ifndef __IDT_H__
#define __IDT_H__

#include "assert.h"
#include "defs.h"
#include "stdbool.h"
#include "stdint.h"

#define IDT_SIZE 256
static_assert(IDT_SIZE > 0, "IDT Size cannot be less than 1!");

#define IDT_DESC(handler, select, gate)       \
    (struct idt_desc) {                       \
        .offset0 = (handler) & 0xFFFF,        \
        .selector = (select),                 \
        .zero = 0,                            \
        .type_attr = (gate),                  \
        .offset1 = ((handler) >> 16) & 0xFFFF \
    }

#define INTERRUPT_GATE 0x8E
#define TRAP_GATE 0x8F
#define TASK_GATE 0x85

struct __packed idt_desc {
    uint16_t offset0;
    uint16_t selector;
    uint8_t zero;
    uint8_t type_attr;
    uint16_t offset1;
};

static_assert(sizeof(struct idt_desc) == 8, "IDT Descriptors have to be exactly 8 bytes long!");

struct __packed idt {
    uint16_t size;
    uintptr_t base;

    union {
        struct idt_desc table[IDT_SIZE];
        uint64_t raw_table[IDT_SIZE];
    };
};

extern struct idt _idt;

void idt_init(void);
void idt_load(void);

bool idt_set_handler(uint16_t index, void (*handler)(void));
bool idt_set_handler_raw(uint16_t index, uint64_t desc);
bool idt_clear_handler(uint16_t index);

void idt_clear(void);

#endif /* __IDT_H__ */