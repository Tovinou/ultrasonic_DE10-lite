/*!
 * \file       char_map.h
 * \details    Content for 8x8 pixels TinyFont
 * \author     Calle Melander
 * \author     Jens Lind
 * \version    2.0
 * \date       2017-2020
 * \copyright  AGSTU AB
 */

#ifndef _CHAR_MAP_H_
#define _CHAR_MAP_H_

#include <alt_types.h>

#ifdef __cplusplus
extern "C" {
#endif

//! TTY character position offset from standard ASCII code
#define TTY_CHAR_OFFSET 0x20

//! Width of a tty character
#define TTY_CHAR_WIDTH 8

//! Height of a tty character
#define TTY_CHAR_HEIGHT 8

/*! \brief Returns the 32-bit representation of the top half of the requested character
    \param char_pos Character position using ASCII code but remove TTY_CHAR_OFFSET.
*/
extern alt_u32 upper_char_line(const alt_u8 char_pos);

/*! \brief Returns the 32-bit representation of the bottom half of the requested character
    \param char_pos Character position using ASCII code but remove TTY_CHAR_OFFSET.
*/
extern alt_u32 lower_char_line(const alt_u8 char_pos);

#ifdef __cplusplus
}
#endif

#endif /* _CHAR_MAP_H_ */
