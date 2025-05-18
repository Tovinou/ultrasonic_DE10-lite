#include <stdio.h> // device driver for printf
#include <altera_avalon_watchdog_timer_regs.h> // device driver for my_timer
#include <altera_avalon_pio_regs.h> // for IORD_ALTERA_AVALON_PIO_DATA
#include <io.h> // For IOWR and IORD macros
#include <system.h> // System configuration


// 7-segment display digit patterns
const int SEVEN_SEG[10] = {
    0b00111111, // 0
    0b00000110, // 1
    0b01011011, // 2
    0b01001111, // 3
    0b01100110, // 4
    0b01101101, // 5
    0b01111101, // 6
    0b00000111, // 7
    0b01111111, // 8
    0b01101111  // 9
};

int main(void) {
    int counter = 0;
    printf("Start program\n");

    // Clear LEDs
    IOWR_32DIRECT(LEDR_BASE, 0, 0x0);

    // Start the timer
    WATCHDOG_TIMER_RESET;
    WATCHDOG_TIMER_START;

    // Start the watchdog timer
    WATCHDOG_TIMER_START;

    while (1) {
        // Wait for 100ms (assuming 50MHz clock)
        while (WATCHDOG_TIMER_READ < 5000000) {}; // 100ms delay

        // Reset timer for the next cycle
        WATCHDOG_TIMER_RESET;
        WATCHDOG_TIMER_START;

        // Restart the Watchdog Timer (kick)
        IOWR_32DIRECT(WATCHDOG_TIMER_HW_IP_0_BASE, 0, 1); // Write '1' to kick WDT
        IOWR_32DIRECT(WATCHDOG_TIMER_HW_IP_0_BASE, 0, 0); // Optionally reset

        // Update the 7-segment display with the current counter value
        IOWR_32DIRECT(SEVEN_SEG_BASE, 0, SEVEN_SEG[counter]);

        // If 1 second has passed (10 * 100ms)
        if (counter == 10) {
            printf("count\n");
            counter = 0;
        } else {
            counter++;
        }

        // Check if the key is pressed (button state is active-low)
        if ((IORD_32DIRECT(PIO_BUTTON_BASE, 0) & 0x1) == 0) {
            printf("Key pressed.Entering infinite loop.\n");
            IOWR_32DIRECT(LEDR_BASE, 0, 0xFF); // Turn on all LEDs to indicate the loop

            // Stop kicking the watchdog by not calling the reset function
            while (1) {
                // The watchdog will reset the system after its timeout expires
            }
        }
    }

    return 0;
}
