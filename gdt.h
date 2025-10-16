#include "assert.h"
#include "stddef.h"
#include "stdint.h"

#define GDT_MAX_SIZE 32
#define GDT_ENTRY(base, limit, type, A, RW, DC, DPL, E, S, P, L, DB, G)
#define GDT_ENTRY(base, limit, type, access, flag)

static_assert(GDT_MAX_SIZE > 0, "GDT Size cannot be less than 1!");
static_assert(GDT_MAX_SIZE < 8192, "GDT Size cannot be greater than 8192!");



struct __attribute__((packed)) gdt {
    uint16_t size;
    uintptr_t base;
    uint64_t curr_size;
    uint64_t table[GDT_MAX_SIZE];
};

extern struct gdt _gdt;

void gdt_init(struct gdt *g) {
    g->size = sizeof(g->table) - 1;
    g->base = &g->table;
    g->curr_size = 0;

}

void gdt_add_entry(struct gdt *g, uint64_t entry) {
    if (g->curr_size < sizeof(g->table)/sizeof(*g->table))
        g->table[g->curr_size++] = entry;
}

void gdt_load(struct gdt *g)
{
    asm volatile (
        "lgdt %0" :: "m"(*g) : "memory"
    );
}