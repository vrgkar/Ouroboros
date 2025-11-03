#include "idt.h"
#include "pic.h"

#include "stddef.h"

struct idt _idt;

static inline void divide_error(void);
static inline void debug_exception(void);
static inline void nmi_interrupt(void);
static inline void breakpoint_exception(void);
static inline void overflow_exception(void);
static inline void bound_range_exceeded_exception(void);
static inline void invalid_opcode_exception(void);
static inline void device_not_available_exception(void);

static void (*const idt_handlers[IDT_SIZE])(void) = {
    [0] = divide_error,
    [1] = debug_exception,
    [2] = nmi_interrupt,
    [3] = breakpoint_exception,
    [4] = overflow_exception,
    [5] = bound_range_exceeded_exception,
    [6] = invalid_opcode_exception,
    [7] = device_not_available_exception,

    [PIC1_VECTOR + 0] = NULL, // IRQ0
    [PIC1_VECTOR + 1] = NULL, // IRQ1
    [PIC1_VECTOR + 2] = NULL, // IRQ2
    [PIC1_VECTOR + 3] = NULL, // IRQ3
    [PIC1_VECTOR + 4] = NULL, // IRQ4
    [PIC1_VECTOR + 5] = NULL, // IRQ5
    [PIC1_VECTOR + 6] = NULL, // IRQ6
    [PIC1_VECTOR + 7] = NULL, // IRQ7

    [PIC2_VECTOR + 0] = NULL, // IRQ8
    [PIC2_VECTOR + 1] = NULL, // IRQ9
    [PIC2_VECTOR + 2] = NULL, // IRQ10
    [PIC2_VECTOR + 3] = NULL, // IRQ11
    [PIC2_VECTOR + 4] = NULL, // IRQ12
    [PIC2_VECTOR + 5] = NULL, // IRQ13
    [PIC2_VECTOR + 6] = NULL, // IRQ14
    [PIC2_VECTOR + 7] = NULL, // IRQ15
};

void idt_init(void)
{
    _idt.size = sizeof(_idt.table) - 1;
    _idt.base = (uintptr_t)&_idt.table;

    for (int i = 0; i < IDT_SIZE; ++i)
        if (idt_handlers[i])
            idt_set_handler(i, idt_handlers[i]);
}

void idt_load(void)
{
    asm volatile("lidt %0" ::"m"(_idt));
}

bool idt_set_handler(uint16_t index, void (*handler)(void))
{
    if (index < IDT_SIZE) {
        _idt.table[index].offset0 = (uintptr_t)handler & 0xFFFF;
        _idt.table[index].offset1 = (uintptr_t)handler >> 16 & 0xFFFF;
        return true;
    }

    return false;
}

static inline void divide_error(void)
{
    // Handle divide error
}

void debug_exception(void)
{
    // Handle debug exception
}

void nmi_interrupt(void)
{
    // Handle NMI interrupt
}

void breakpoint_exception(void)
{
    // Handle breakpoint exception
}

void overflow_exception(void)
{
    // Handle overflow exception
}

void bound_range_exceeded_exception(void)
{
    // Handle bound range exceeded exception
}

void invalid_opcode_exception(void)
{
    // Handle invalid opcode exception
}

void device_not_available_exception(void)
{
    // Handle device not available exception
}

void timer_irq(void)
{
    // Handle timer IRQ
}

void keyboard_irq(void)
{
    // Handle keyboard IRQ
}