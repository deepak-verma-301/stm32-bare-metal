/* Minimal linker script for STM32F407VG (1 MB Flash, 128 KB RAM) */

ENTRY(Reset_Handler)

/* Memory map */
MEMORY
{
  FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 1024K
  RAM   (xrw) : ORIGIN = 0x20000000, LENGTH = 128K
}

/* Top of the stack (end of RAM) */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
  /* Vector table and code in Flash */
  .text :
  {
    KEEP(*(.isr_vector))     /* keep vector table */
    *(.text*)                /* program code */
    *(.rodata*)              /* read-only data */
    _etext = .;              /* end of code */
  } > FLASH

  /* Initialized data: load from Flash, run in RAM */
  .data : AT (ADDR(.text) + SIZEOF(.text))
  {
    _sdata = .;
    *(.data*)
    _edata = .;
  } > RAM

  /* Zero-initialized data */
  .bss :
  {
    _sbss = .;
    *(.bss*)
    *(COMMON)
    _ebss = .;
  } > RAM
}
