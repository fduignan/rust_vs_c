/* User LED for the Blue pill is on PC13 */
#include <stdint.h> // This header includes data type definitions such as uint32_t etc.

// Simple software delay.  The larger dly is the longer it takes to count to zero.
void delay(uint32_t dly) {
    while(dly--);
}
// GPIO configuration
void config_pins() {
    // Make pointers to the relevant registers
    volatile uint32_t * rcc_apb2enr = (  (volatile uint32_t *) 0x40021018  );
    volatile uint32_t * gpioc_crh = (  (volatile uint32_t *) 0x40011004  );
    
    // Turn on GPIO C
    *rcc_apb2enr |= (1 << 4); // set bit 4
    // Configure PC13 as an output
    *gpioc_crh |= (1 << 20); // set bit 20
    *gpioc_crh &= ~((1 << 23) | (1 << 22) | (1 << 21)); // clear bits 21,22,23
}
void led_on() {
    // Make a pointer to the output data register for port C
    volatile uint32_t * gpioc_odr = (  (volatile uint32_t *) 0x4001100c  );
    *gpioc_odr |= (1 << 13); // set bit 13
}

void led_off() {
    // Make a pointer to the output data register for port C
    volatile uint32_t * gpioc_odr = (  (volatile uint32_t *) 0x4001100c  );
    *gpioc_odr &= ~(1 << 13); // clear bit 13
}
// The main function body follows 
int main() {
    // Do I/O configuratoin
    config_pins(); 
    while(1) // do this forever
    {
        led_on();
        delay(100000);
        led_off();
        delay(100000);
    }
}
// The reset interrupt handler
void reset_handler() {
    main(); // call on main 
    while(1); // if main exits then loop here until next reset. 
}

// Build the interrupt vector table
const void * Vectors[] __attribute__((section(".vector_table"))) ={
	reset_handler
};
