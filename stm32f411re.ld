MEMORY
{
    rom (rx)  : ORIGIN = 0x08000000, LENGTH = 512K
    ram (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

EXTERN(reset_handler)

SECTIONS
{
    .text : {
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)

        . = ALIGN(4);
        __preinit_array_start = .;
        KEEP (*(.preinit_array))
        __preinit_array_end = .;

        __init_array_start = .;
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array))
        __init_array_end = .;

        __fini_array_start = .;
        KEEP (*(.fini_array))
        KEEP (*(.fini_array_end))
        __fini_array_end = .;
    } > rom

    /* Initialized data section placed in RAM, loaded from ROM */
    .data : {
        _data = .;
        *(.data*)
        _edata = .;
    } > ram AT > rom

    /* Symbol expected by libopencm3 startup code */
    _data_loadaddr = LOADADDR(.data);

    /* Uninitialized data section */
    .bss : {
        _sbss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > ram

    /* Initial stack pointer at the top of RAM */
    _stack = ORIGIN(ram) + LENGTH(ram);
}
