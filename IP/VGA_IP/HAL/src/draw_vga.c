/**
 * \file       draw_vga.c
 * \details    Functions for drawing lines, circles, text and integer on VGA
 * \author     Calle Melander
 * \author     Jens Lind
 * \version    2.0
 * \date       2017-2020
 * \copyright  AGSTU AB
 */

#include <alt_types.h>
#include <altera_avalon_pio_regs.h>
#include <stdlib.h>
#include <string.h>

#include "char_map.h"
#include "draw_vga.h"
#include "DE10_Lite_VGA_Driver.h"

void clear_screen(alt_u32 color)
{
	// Author's note: This function offers a lot of opportunities for optimization
	for (size_t y = 0; y < CANVAS_HEIGHT; ++y)
	{
		for (size_t x = 0; x < CANVAS_WIDTH; ++x)
		{
			write_pixel(x, y, color);
		}
	}
}

void draw_hline(alt_u32 x0, alt_u32 y0, alt_u32 length, alt_u32 color)
{
	const size_t start_addr = pixel_addr(x0, y0);
	const size_t end_addr = start_addr + length * 4;
	for (size_t pixel = start_addr; pixel < end_addr; pixel += 4)
		IOWR_32DIRECT(DE10_LITE_VGA_IP_0_BASE, pixel, color);
}

void draw_vline(alt_u32 x0, alt_u32 y0, alt_u32 length, alt_u32 color)
{
	const size_t start_addr = pixel_addr(x0, y0);
	const size_t row_bytes = 4 * CANVAS_WIDTH;
	const size_t end_addr = start_addr + length * row_bytes;
	for (size_t pixel = start_addr; pixel < end_addr; pixel += row_bytes)
		IOWR_32DIRECT(DE10_LITE_VGA_IP_0_BASE, pixel, color);
}

void swap(alt_u32* p1, alt_u32* p2)
{
	alt_u32 temp = *p1;
	*p1 = *p2;
	*p2 = temp;
}

void draw_angled_line(alt_u32 x0, alt_u32 y0, alt_u32 x1, alt_u32 y1, alt_u32 color)
{
	alt_u32 steep = 0;

	// Adjust angles
	if (abs(x0-x1) < abs(y0-y1))
	{
		if (y0 > y1)
		{
			swap(&x0, &y1);
			swap(&x1, &y0);
		}
		else
		{
			swap(&x0, &y0);
			swap(&x1, &y1);
		}
		steep = 1;
	}
	else if (x0 > x1)
	{
		swap(&x0, &x1);
		swap(&y0, &y1);
	}

	const alt_32 dx = x1-x0;
	const alt_32 dy = y1-y0;
	const alt_32 derror = abs(dy)*2;
	alt_32 error = 0;
	alt_32 y = y0;
	for (alt_32 x = x0; x <= x1; ++x)
	{
		if (steep)
			write_pixel(y, x, color);
		else
			write_pixel(x, y, color);

		error += derror;
		if (error > dx)
		{
			y += (y1 > y0 ? 1 : -1);
			error -= dx*2;
		}
	}
}

// Only write pixel if both x and y values are within canvas range
void safe_write_pixel(alt_32 x, alt_32 y, alt_u32 color)
{
	if (x >= 0 && x < CANVAS_WIDTH && y >= 0 && y < CANVAS_HEIGHT)
	{
		write_pixel(x, y, color);
	}
}

void draw_circle(alt_32 x0, alt_32 y0, alt_u32 radius, alt_u32 color)
{
	// Bresenham's circle algorithm
	alt_32 x = radius-1;
	alt_32 y = 0;
	alt_32 dx = 1;
	alt_32 dy = 1;
	alt_32 err = dx - (radius << 1);
	while (x >= y)
	{
		safe_write_pixel(x0 + x, y0 + y, color);
		safe_write_pixel(x0 + y, y0 + x, color);
		safe_write_pixel(x0 - y, y0 + x, color);
		safe_write_pixel(x0 - x, y0 + y, color);
		safe_write_pixel(x0 - x, y0 - y, color);
		safe_write_pixel(x0 - y, y0 - x, color);
		safe_write_pixel(x0 + y, y0 - x, color);
		safe_write_pixel(x0 + x, y0 - y, color);

		if (err <= 0)
		{
			y++;
			err += dy;
			dy += 2;
		}
		if (err > 0)
		{
			x--;
			dx += 2;
			err += dx - (radius << 1);
		}
	}
}

// Only write pixel if y value is within canvas height, x is assumed correct
void safey_write_pixel(alt_32 x, alt_32 y, alt_u32 color)
{
	if (y >= 0 && y < CANVAS_HEIGHT)
	{
		write_pixel(x, y, color);
	}
}

void draw_filled_circle(alt_32 x0, alt_32 y0, alt_u32 radius, alt_u32 color)
{
	alt_32 x = radius;
	alt_32 y = 0;
	alt_32 xChange = 1 - (radius << 1);
	alt_32 yChange = 0;
	alt_32 radiusError = 0;

	while (x >= y)
	{
		alt_32 xStart = x0 - x;
		alt_32 xEnd = x0 + x;
		if (xStart < CANVAS_WIDTH)
		{
			xStart = (xStart > 0 ? xStart : 0);
			xEnd = (xEnd < CANVAS_WIDTH-1 ? xEnd : CANVAS_WIDTH-1);
			for (alt_32 i = xStart; i <= xEnd; i++)
			{
				safey_write_pixel(i, y0 + y, color);
				safey_write_pixel(i, y0 - y, color);
			}
		}
		xStart = x0 - y;
		xEnd = x0 + y;
		if (xStart < CANVAS_WIDTH)
		{
			xStart = (xStart > 0 ? xStart : 0);
			xEnd = (xEnd < CANVAS_WIDTH-1 ? xEnd : CANVAS_WIDTH-1);
			for (alt_32 i = xStart; i <= xEnd; i++)
			{
				safey_write_pixel(i, y0 + x, color);
				safey_write_pixel(i, y0 - x, color);
			}
		}

		y++;
		radiusError += yChange;
		yChange += 2;
		if (((radiusError << 1) + xChange) > 0)
		{
			x--;
			radiusError += xChange;
			xChange += 2;
		}
	}
}

void tty_print(alt_32 x0, alt_32 y0, const char* sz_tty, alt_u32 color, alt_u32 BGcolor)
{
	const size_t n = strlen(sz_tty);
	for (size_t i = 0; i < n; ++i)
	{
		char_print(x0 + TTY_CHAR_WIDTH*i, y0, sz_tty[i], color, BGcolor);
	}
}

void char_print(alt_32 x0, alt_32 y0, const char tty_char, alt_u32 color, alt_u32 BGcolor)
{
	alt_32 pry = y0;
	// upper half
	const alt_u32 char_half_height = TTY_CHAR_HEIGHT>>1;
	alt_u32 dot = upper_char_line(tty_char - TTY_CHAR_OFFSET);
	for (size_t row = 0; row < char_half_height; ++row)
	{
		alt_32 prx = x0;
		if (pry >= 0 && pry < CANVAS_HEIGHT)
		{
			for (size_t column = 0; column < TTY_CHAR_WIDTH; ++column)
			{
				if (prx >= 0 && prx < CANVAS_WIDTH)
				{
					const alt_u32 dotcolor = (0x80000000&dot) ? color : BGcolor;
					write_pixel(prx, pry, dotcolor);
				}
				dot <<= 1;
				++prx;
			}
		}
		else
		{
			dot <<= TTY_CHAR_WIDTH;
		}
		++pry;
	}
	// lower half
	dot = lower_char_line(tty_char - TTY_CHAR_OFFSET);
	for (size_t row = 0; row < char_half_height; ++row)
	{
		alt_32 prx = x0;
		if (pry >= 0 && pry < CANVAS_HEIGHT)
		{
			for (size_t column = 0; column < TTY_CHAR_WIDTH; ++column)
			{
				if (prx >= 0 && prx < CANVAS_WIDTH)
				{
					const alt_u32 dotcolor = (0x80000000&dot) ? color : BGcolor;
					write_pixel(prx, pry, dotcolor);
				}
				dot <<= 1;
				++prx;
			}
		}
		else
		{
			dot <<= TTY_CHAR_WIDTH;
		}
		++pry;
	}
}

void int_print(alt_32 x0, alt_32 y0, int data, alt_u32 data_l, alt_u32 color, alt_u32 BGcolor)
{
	if (data < 0)
	{
		char_print(x0, y0, '-', color, BGcolor);
		data = -data;
	}
	else
	{
		char_print(x0, y0, '+', color, BGcolor);
	}

	alt_u32 x = x0 + (TTY_CHAR_WIDTH * data_l);
	for (alt_u32 i = 0; i < data_l; ++i)
	{
		char_print(x, y0, (data % 10) + '0', color, BGcolor);
		data /= 10;
		x -= TTY_CHAR_WIDTH;
	}
}
