#ifndef __GDT_H__
#define __GDT_H__

#include "assert.h"
#include "defs.h"
#include "stdbool.h"
#include "stdint.h"

#define GDT_SIZE 32

static_assert(GDT_SIZE > 0, "GDT Size cannot be less than 1!");
static_assert(GDT_SIZE < 8193, "GDT Size cannot be greater than 8192!");

struct __packed gdt_desc {
    uint16_t limit0;
    uint16_t base0;
    uint8_t base1;
    uint8_t access_type;
    uint8_t flags_limit1;
    uint8_t base2;
};

static_assert(sizeof(struct gdt_desc) == 8, "GDT Descriptors have to be exactly 8 bytes long!");

#define GDT_SEG_DESC(base, limit, flags, access)               \
    (struct gdt_desc)                                        \
    {                                                              \
        .limit0 = limit & 0xFFFF,                                  \
        .base0 = base & 0xFFFF,                                    \
        .base1 = (base >> 16) & 0xFF,                              \
        .access_type = access,                                          \
        .flags_limit1 = (flags << 4 & 0xF0) | (limit >> 16 & 0xF), \
        .base2 = (base >> 24) & 0xFF,                              \
    }

#define GDT_SYS_SEG_DESC(base, limit, flags, access, type)  \
    (const struct gdt_desc)                                        \
    {                                                              \
        .limit0 = limit & 0xFFFF,                                  \
        .base0 = base & 0xFFFF,                                    \
        .base1 = (base >> 16) & 0xFF,                              \
        .access_type = (access & 0xF0) | (type & 0xF),             \
        .flags_limit1 = (flags << 4 & 0xF0) | (limit >> 16 & 0xF), \
        .base2 = (base >> 24) & 0xFF,                              \
    }

struct __packed gdt {
    uint16_t size;
    uintptr_t base;

    union {
        struct gdt_desc table[GDT_SIZE];
        uint64_t raw_table[GDT_SIZE];
    };
};

extern struct gdt _gdt;

void gdt_init(void);
void gdt_load(void);

bool gdt_push(struct gdt_desc desc);
bool gdt_push_raw(uint64_t desc);
bool gdt_pop(void);

void gdt_clear(void);

#endif /* __GDT_H__ */