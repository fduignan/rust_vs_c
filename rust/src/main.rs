
#![no_main]
#![no_std]

use core::panic::PanicInfo;

fn delay(mut dly : u32) {
    
    while dly > 0
    {
        dly = dly -1;
    }
}
// GPIO configuration
fn config_pins() {
   unsafe {
        // Make pointers to the relevant registers
        let rcc_apb2enr  = 0x40021018 as *mut u32;
        let gpioc_crh    = 0x40011004 as *mut u32; 
                
        // Turn on GPIO C
        *rcc_apb2enr |= 1 << 4; // set bit 4
        // Configure PC13 as an output
        *gpioc_crh |= 1 << 20;  // set bit 20
        *gpioc_crh &= !((1<<23) | (1<<22) | (1 << 21)); // clear bits 21,22,23
    }
}

fn led_on() {
    unsafe {
        // Make a pointer to the output data register for port C
        let gpioc_odr  = 0x4001100C as *mut u32; 
        *gpioc_odr |= 1 << 13; // set bit 13
    }
}

fn led_off() {
    unsafe {
        // Make a pointer to the output data register for port C
        let gpioc_odr  = 0x4001100C as *mut u32; 
        *gpioc_odr &= !(1 << 13); // clear bit 13
    }
}
fn main() {
    config_pins();  
    loop 
    {
        led_on();
        delay(100000);
        led_off();
        delay(100000);
    }
}
pub unsafe extern "C"  fn reset_handler() -> ! {
    main();
    loop {}
}

// Build the interrupt vector table
#[link_section = ".vector_table"]
pub static RESET_VECTOR: unsafe extern "C" fn() -> ! = reset_handler;




// Rust requires a function to handle program panics - this one simply loops.  You 
// could perhaps write some code to output diagnostic information.
#[panic_handler]
fn panic(_panic: &PanicInfo) -> ! {
    loop {}
}
