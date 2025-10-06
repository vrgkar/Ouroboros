void bios_putc(char c);

static void print(const char *str)
{
    while (*str)
        bios_putc(*str++);
}

void _start(void) {

    const char *msg = "Hello World!";

    print(msg);
}
