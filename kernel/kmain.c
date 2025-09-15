void putc(char c)
{
    asm (
        "movb %0, %%al\n\t"
        "movb $0x0E, %%ah\n\t"
        "int $0x10"
        :
        : "r"(c)
        : "ax", "memory", "cc"
    );
}

void print(const char *str)
{
    while (*str)
        putc(*str++);
}

void kmain(void)
{

    print("Hello World!\n");

    while (1);
}
