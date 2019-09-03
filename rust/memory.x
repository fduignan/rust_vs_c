/* Linker script file for the STM32F103C8T6 MCU for use with rust*/
MEMORY
{
  FLASH : ORIGIN = 0x08000000, LENGTH = 64K
  RAM : ORIGIN = 0x20000000, LENGTH = 20k
}


SECTIONS
{

  .vectors ORIGIN(FLASH) :
  {
    /* First entry: initial Stack Pointer value */
    LONG(ORIGIN(RAM) + LENGTH(RAM));

    /* Second amd subsequent entries are interrupt vectors */
    KEEP(*(.vector_table));
  } > FLASH

  .text :
  {
    *(.text .text.*);
  } > FLASH
  .rodata :
  {
      
  } > FLASH
  .ARM.exidx :
  {
    *(.ARM.exidx.*);
  } > FLASH
}

