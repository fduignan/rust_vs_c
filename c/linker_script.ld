/* Linker script file for the STM32F103C8T6 MCU for use with C */
MEMORY
{
    FLASH : org = 0x08000000, len = 64k
    RAM : org = 0x20000000, len = 20k
}
  
SECTIONS
{
        
	.vectors ORIGIN(FLASH) :
    {
         /* First entry: initial Stack Pointer value */
          LONG(ORIGIN(RAM) + LENGTH(RAM));
          
          /* Second amd subsequent entries are interrupt vectors */
		  KEEP(*(.vector_table));
    } >FLASH
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
/* The next section is to do with initialization of global and static data */
/* startup code needs to copy initial values from ROM to the correct locations in RAM */
/* startup code also zeros out unitialized global and static data.  This section simply */
/* labels these memory regions and causes the linker to put initialization values in the */
/* memory image     */

	. = ORIGIN(RAM);
        .data : {
	  INIT_DATA_VALUES = LOADADDR(.data);
	  INIT_DATA_START = .;
	    *(.data);
	  INIT_DATA_END = .;
	  . = ALIGN(4);
        } >RAM AT>FLASH
	BSS_START = .;
	.bss : {	  
	    *(.bss);
	    . = ALIGN(4);
	} > RAM
	BSS_END = .;
}
