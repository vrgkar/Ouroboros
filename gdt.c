#include "gdt.h"

struct gdt _gdt;

void gdt_init(void)
{
    _gdt.size = sizeof(*_gdt.table) - 1;
    _gdt.base = (uintptr_t)&_gdt.table;
    _gdt.raw_table[0] = 0;
}

void gdt_load(void)
{
    _gdt.size = ((uint32_t)_gdt.size * sizeof(*_gdt.table)) - 1;
    asm volatile("lgdt %0" : : "m"(_gdt));
    _gdt.size = (_gdt.size + 1) / sizeof(*_gdt.table);
}

bool gdt_push(struct gdt_desc desc)
{
    if (_gdt.size < sizeof(_gdt.table) / sizeof(_gdt.table[0])) {
        _gdt.table[_gdt.size++] = desc;
        return true;
    }

    return false;
}

bool gdt_push_raw(uint64_t desc)
{
    if (_gdt.size < sizeof(_gdt.table) / sizeof(_gdt.table[0])) {
        _gdt.raw_table[_gdt.size++] = desc;
        return true;
    }

    return false;
}
bool gdt_pop(void)
{
    if (_gdt.size > 1) {
        --_gdt.size;
        return true;
    }

    return false;
}

void gdt_clear(void)
{
    _gdt.size = 1;
}
