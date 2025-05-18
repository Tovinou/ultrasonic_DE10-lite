#include <stdio.h>
#include <alt_types.h>
#include <DE10_Lite_VGA_Driver.h>
#include <stdint.h>
#include <stdlib.h>

// VGA constants
#define VGA_WIDTH 320
#define VGA_HEIGHT 240

// VGA pixel structure
typedef struct {
    uint8_t r;
    uint8_t g;
    uint8_t b;
} vga_pixel_t;

// VGA pixel RAM pointer
vga_pixel_t *pixel_ram;

// Function prototypes
void print_pix(unsigned int x, unsigned int y, unsigned int rgb);
void print_hline(unsigned int x_start, unsigned int y_start, unsigned int len, unsigned int rgb);
void print_vline(unsigned int x_start, unsigned int y_start, unsigned int len, unsigned int rgb);
void print_char(unsigned int x, unsigned int y, unsigned int rgb, unsigned int bg_rgb, char character);
void clear_screen(int rgb);
void print_circle(unsigned int radius, unsigned int x_center, unsigned int y_center, unsigned int rgb);
void tty_print(unsigned int x, unsigned int y, const char* text, unsigned int fg_color, unsigned int bg_color);

int main() {
    // Calculate required memory size for pixel RAM
    size_t memory_size = VGA_WIDTH * VGA_HEIGHT * sizeof(vga_pixel_t);
    printf("Allocating memory for pixel RAM: %zu bytes\n", memory_size);

    // Allocate memory for pixel RAM
    pixel_ram = (vga_pixel_t *)malloc(memory_size);
    if (pixel_ram == NULL) {
        printf("Error: Unable to allocate memory for pixel RAM\n");
        return 1;
    }

    // Initialize pixel RAM (assuming clearing screen with black)
    clear_screen(0);

    // Test functions
    print_char(1, 2, 1, 2, 'A');           // Print character 'A'
    print_hline(11, 2, 5, 1);              // Draw horizontal line
    print_vline(19, 2, 6, 1);              // Draw vertical line
    print_pix(11, 5, 4);                   // Draw pixel
    print_circle(10, 20, 20, 2);           // Draw circle

    // Print name "Komlan Tovinou"
    tty_print(100, 100, "Komlan Tovinou", 1, 7); // Assuming Col_Red = 1 and Col_White = 7

    // Free allocated memory
    free(pixel_ram);

    return 0;
}

// Function to draw a pixel on the screen (assuming VGA hardware interface)
void print_pix(unsigned int x, unsigned int y, unsigned int rgb) {
    if (x >= VGA_WIDTH || y >= VGA_HEIGHT) {
        printf("Error: pixel out of bounds\n");
        return;
    }
    pixel_ram[y * VGA_WIDTH + x].r = (rgb >> 2) & 0x1;
    pixel_ram[y * VGA_WIDTH + x].g = (rgb >> 1) & 0x1;
    pixel_ram[y * VGA_WIDTH + x].b = rgb & 0x1;
}

// Function to print a horizontal line
void print_hline(unsigned int x_start, unsigned int y_start, unsigned int len, unsigned int rgb) {
    for (unsigned int x = x_start; x < x_start + len; x++) {
        print_pix(x, y_start, rgb);
    }
}

// Function to print a vertical line
void print_vline(unsigned int x_start, unsigned int y_start, unsigned int len, unsigned int rgb) {
    for (unsigned int y = y_start; y < y_start + len; y++) {
        print_pix(x_start, y, rgb);
    }
}

// Function to print a character
void print_char(unsigned int x, unsigned int y, unsigned int rgb, unsigned int bg_rgb, char character) {
    // ASCII character set
    const char *ascii_chars[] = {
        "01000000", // 'A'
        "01100000", // 'B'
        // Add more characters as needed
    };
    if (character < 'A' || character > 'B') {
        printf("Character not supported\n");
        return;
    }
    const char *char_bits = ascii_chars[character - 'A'];
    for (unsigned int i = 0; i < 8; i++) {
        for (unsigned int j = 0; j < 8; j++) {
            if (char_bits[i * 8 + j] == '1') {
                print_pix(x + j, y + i, rgb);
            } else {
                print_pix(x + j, y + i, bg_rgb);
            }
        }
    }
}

// Function to clear the screen with a specified color
void clear_screen(int rgb) {
    for (unsigned int y = 0; y < VGA_HEIGHT; y++) {
        for (unsigned int x = 0; x < VGA_WIDTH; x++) {
            print_pix(x, y, rgb);
        }
    }
}

// Function to draw a filled circle
void print_circle(unsigned int radius, unsigned int x_center, unsigned int y_center, unsigned int rgb) {
    for (int y = -radius; y <= radius; y++) {
        for (int x = -radius; x <= radius; x++) {
            if (x * x + y * y <= radius * radius) {
                print_pix(x_center + x, y_center + y, rgb);
            }
        }
    }
}

// Function to print text on the VGA screen
void tty_print(unsigned int x, unsigned int y, const char* text, unsigned int fg_color, unsigned int bg_color) {
    while (*text) {
        print_char(x, y, fg_color, bg_color, *text);
        x += 8; // Move to the next character position
        text++;
    }
}
