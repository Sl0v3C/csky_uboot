/*
 * Copyright (C) 2017 C-SKY Microsystems
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

MEMORY
{
    MEM0   : ORIGIN = 0x0        , LENGTH = 0x17FFFFFF    /* DDR 384MB */
    MEM1   : ORIGIN = 0x1fc00000 , LENGTH = 0x3FFF        /* ROM 16KB */
    MEM2   : ORIGIN = 0x1fd00000 , LENGTH = 0x3FFF        /* SRAM 16KB */
}

REGION_ALIAS("REGION_TEXT",   MEM2);
REGION_ALIAS("REGION_RODATA", MEM2);
REGION_ALIAS("REGION_DATA",   MEM2);
REGION_ALIAS("REGION_BSS",    MEM2);

OUTPUT_ARCH(csky)
ENTRY(_start)

SECTIONS
{
    .text ALIGN(0x4):
    {
        __text_start = .;
        *start.o(*.exptable)
        *(.text)
        *(.text.*)
        __text_end = .;
    } > REGION_TEXT

    .rodata ALIGN(0x4):
    {
        __rodata_start = .;
        *(SORT_BY_ALIGNMENT(SORT_BY_NAME(.rodata*)))
        __rodata_end = .;
    } > REGION_RODATA

    .data ALIGN(0x4):
    {
        __data_start = .;
        *(.data)
        *(.data.*)
        __data_end = .;
    } > REGION_DATA

    . = ALIGN(4);
    .u_boot_list : {
        KEEP(*(SORT(.u_boot_list*)));
    } > REGION_DATA

    __init_end = . ;

    .bss ALIGN(0x4):
    {
        __bss_start = .;
        *(.sbss)
        *(.scommon)
        *(.bss)
        *(.bss.*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
    } > REGION_BSS
    __end = .;
}

