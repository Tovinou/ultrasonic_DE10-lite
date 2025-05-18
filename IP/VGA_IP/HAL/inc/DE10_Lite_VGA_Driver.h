/*!
 * \file       DE10_Lite_VGA_Driver.h
 * \details    Drivers for interfacing with VGA component for the DE10-Lite board.
 *             Functionality is implemented as macros that writes to and reads from registers.
 * \author     Linus Eriksson
 * \author     Jens Lind
 * \version    2.0
 * \date       2017-2020
 * \copyright  AGSTU AB
 */

#ifndef _DE10_LITE_VGA_DRIVER_H_
#define _DE10_LITE_VGA_DRIVER_H_

#include <system.h>
#include <io.h>

#ifdef __cplusplus
extern "C" {
#endif

#define CANVAS_WIDTH 320
#define CANVAS_HEIGHT 240
#define CANVAS_SIZE (CANVAS_WIDTH * CANVAS_HEIGHT)

//! 8-bit color depth
enum Color
{
	Col_Black = 0,
	Col_Blue,
	Col_Green,
	Col_Cyan,
	Col_Red,
	Col_Magenta,
	Col_Yellow,
	Col_White
};

//! Returns the address offset from VGA base for pixel at given screen coordinate (x, y)
#define pixel_addr(x, y) ((CANVAS_WIDTH * (y) + (x)) * 4)

//! Writes a pixel with the specified color (rgb) on given screen coordinate (x, y).
#define write_pixel(x, y, rgb) IOWR_32DIRECT(DE10_LITE_VGA_IP_0_BASE, pixel_addr(x, y), (rgb))

//! Returns the current color value for given screen coordinate (x, y)
#define read_pixel(x, y) IORD_32DIRECT(DE10_LITE_VGA_IP_0_BASE, pixel_addr(x, y))

#ifdef __cplusplus
}
#endif

#endif // _DE10_LITE_VGA_DRIVER_H_