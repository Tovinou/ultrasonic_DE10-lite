/*!
 * \file       draw_vga.h
 * \details    Interface defining functions for drawing lines, circles, text and integer on VGA
 * \author     Calle Melander
 * \author     Jens Lind
 * \version    2.0
 * \date       2017-2020
 * \copyright  AGSTU AB
 */

#ifndef _DRAW_VGA_H_
#define _DRAW_VGA_H_

#include <alt_types.h>

#ifdef __cplusplus
extern "C" {
#endif

/*! \brief This function clears the screen by writing the color value to all pixels on the screen.
    \param color Color to fill the screen with.
 */
extern void clear_screen(alt_u32 color);

/*! \brief Draws a horizontal line of specified length. The function may fail if not constrained to screen.
    \param x0 Horizontal start of the line.
    \param y0 Vertical start of the line.
    \param length Horizontal distance of line - line ends at (x0+length, y0)
    \param color Color of the line.
*/
extern void draw_hline(alt_u32 x0, alt_u32 y0, alt_u32 length, alt_u32 color);

/*! \brief Draws a vertical line of specified length. The function may fail if not constrained to screen.
    \param x0 Horizontal start of the line.
    \param y0 Vertical start of the line.
    \param length Veritcal distance of line - line ends at (x0, y0+length)
    \param color Color of the line.
*/
extern void draw_vline(alt_u32 x0, alt_u32 y0, alt_u32 length, alt_u32 color);

/*! \brief Draws a slanting line between two specified coordinates. The function may fail if either coordinate is outside of the screen.
    \param x0 Horizontal start of the line.
    \param y0 Vertical start of the line.
    \param x1 Horizontal end of the line. If equal to x0, consider using draw_vline instead.
    \param y1 Vertical end of the line. If equal to y0, consider using draw_hline instead.
    \param color Color of the line.
*/
extern void draw_angled_line(alt_u32 x0, alt_u32 y0, alt_u32 x1, alt_u32 y1, alt_u32 color);

/*! \brief Writes a circle with the specified radius and color at the center coordinate (x0, y0).
    \param x0 Horizontal position for centre of circle.
    \param y0 Veritcal position for centre of circle.
    \param radius Radius of circle.
    \param color Color for circle border.
*/
extern void draw_circle(alt_32 x0, alt_32 y0, alt_u32 radius, alt_u32 color);

/*! \brief Writes a circle with the specified radius and color at the center coordinate (x0, y0). The circle is filled with the same color.
    \param x0 Horizontal position for centre of circle.
    \param y0 Veritcal position for centre of circle.
    \param radius Radius of circle.
    \param color Color for circle border and fill.
*/
extern void draw_filled_circle(alt_32 x0, alt_32 y0, alt_u32 radius, alt_u32 color);

/*! \brief Prints a string on the screen letter by letter.
    \param x0 Top left corner horizontal position. If negative, the string will be partially cropped.
    \param y0 Top left corner vertical position. If negative, the string will be partially cropped.
    \param sz_tty The ASCII characters to print.
    \param color Color to use for the characters.
    \param BGcolor Color to use for the background of the characters.
*/
extern void tty_print(alt_32 x0, alt_32 y0, const char* sz_tty, alt_u32 color, alt_u32 BGcolor);

/*! \brief Prints a 8x8 pixels character with the specified color and background color on the coordinate (x1, y1). The character table is in the header file char_map.h.
    \param x0 Top left corner horizontal position. If negative, the character will be partially cropped.
    \param y0 Top left corner vertical position. If negative, the character will be partially cropped.
    \param tty_char The ASCII character to print.
    \param color Color to use for the character.
    \param BGcolor Color to use for the background of the character.
*/ 
extern void char_print(alt_32 x0, alt_32 y0, const char tty_char, alt_u32 color, alt_u32 BGcolor);

/*! \brief Prints an integer to screen digit by digit. It will prefix the number with sign (+/-).
    \param x0 Top left corner horizontal position. If negative, the number will be partially cropped.
    \param y0 Top left corner vertical position. If negative, the number will be partially cropped.
    \param data The integer to print.
    \param data_l The number of digits to use. It will prefix with 0s if the number of digits are more than required.
    \param color Color to use for the number.
    \param BGcolor Color to use for the background of the number.
*/
extern void int_print(alt_32 x0, alt_32 y0, int data, alt_u32 data_l, alt_u32 color, alt_u32 BGcolor);

#ifdef __cplusplus
}
#endif

#endif /* _DRAW_VGA_H_ */
