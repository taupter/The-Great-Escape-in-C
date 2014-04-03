#include "TheGreatEscape/Tiles.h"

#include "TheGreatEscape/Font.h"

/**
 * $A69E: Bitmap font definition.
 */
const tile_t bitmap_font[38] =
{
  { { 0x00, 0x7C, 0xFE, 0xEE, 0xEE, 0xEE, 0xFE, 0x7C } }, // 0 or O
  { { 0x00, 0x1E, 0x3E, 0x6E, 0x0E, 0x0E, 0x0E, 0x0E } }, // 1
  { { 0x00, 0x7C, 0xFE, 0xCE, 0x1C, 0x70, 0xFE, 0xFE } }, // 2
  { { 0x00, 0xFC, 0xFE, 0x0E, 0x3C, 0x0E, 0xFE, 0xFC } }, // 3
  { { 0x00, 0x0E, 0x1E, 0x3E, 0x6E, 0xFE, 0x0E, 0x0E } }, // 4
  { { 0x00, 0xFC, 0xC0, 0xFC, 0x7E, 0x0E, 0xFE, 0xFC } }, // 5
  { { 0x00, 0x38, 0x60, 0xFC, 0xFE, 0xC6, 0xFE, 0x7C } }, // 6
  { { 0x00, 0xFE, 0x0E, 0x0E, 0x1C, 0x1C, 0x38, 0x38 } }, // 7
  { { 0x00, 0x7C, 0xEE, 0xEE, 0x7C, 0xEE, 0xEE, 0x7C } }, // 8
  { { 0x00, 0x7C, 0xFE, 0xC6, 0xFE, 0x7E, 0x0C, 0x38 } }, // 9
  { { 0x00, 0x38, 0x7C, 0x7C, 0xEE, 0xEE, 0xFE, 0xEE } }, // A
  { { 0x00, 0xFC, 0xEE, 0xEE, 0xFC, 0xEE, 0xEE, 0xFC } }, // B
  { { 0x00, 0x1E, 0x7E, 0xFE, 0xF0, 0xFE, 0x7E, 0x1E } }, // C
  { { 0x00, 0xF0, 0xFC, 0xEE, 0xEE, 0xEE, 0xFC, 0xF0 } }, // D
  { { 0x00, 0xFE, 0xFE, 0xE0, 0xFE, 0xE0, 0xFE, 0xFE } }, // E
  { { 0x00, 0xFE, 0xFE, 0xE0, 0xFC, 0xE0, 0xE0, 0xE0 } }, // F
  { { 0x00, 0x1E, 0x7E, 0xF0, 0xEE, 0xF2, 0x7E, 0x1E } }, // G
  { { 0x00, 0xEE, 0xEE, 0xEE, 0xFE, 0xEE, 0xEE, 0xEE } }, // H
  { { 0x00, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38 } }, // I
  { { 0x00, 0xFE, 0x38, 0x38, 0x38, 0x38, 0xF8, 0xF0 } }, // J
  { { 0x00, 0xEE, 0xEE, 0xFC, 0xF8, 0xFC, 0xEE, 0xEE } }, // K
  { { 0x00, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xFE, 0xFE } }, // L
  { { 0x00, 0x6C, 0xFE, 0xFE, 0xD6, 0xD6, 0xC6, 0xC6 } }, // M
  { { 0x00, 0xE6, 0xF6, 0xFE, 0xFE, 0xEE, 0xE6, 0xE6 } }, // N
  { { 0x00, 0xFC, 0xEE, 0xEE, 0xEE, 0xFC, 0xE0, 0xE0 } }, // P
  { { 0x00, 0x7C, 0xFE, 0xEE, 0xEE, 0xEE, 0xFC, 0x7E } }, // Q
  { { 0x00, 0xFC, 0xEE, 0xEE, 0xFC, 0xF8, 0xEC, 0xEE } }, // R
  { { 0x00, 0x7E, 0xFE, 0xF0, 0x7C, 0x1E, 0xFE, 0xFC } }, // S
  { { 0x00, 0xFE, 0xFE, 0x38, 0x38, 0x38, 0x38, 0x38 } }, // T
  { { 0x00, 0xEE, 0xEE, 0xEE, 0xEE, 0xEE, 0xFE, 0x7C } }, // U
  { { 0x00, 0xEE, 0xEE, 0xEE, 0xEE, 0x6C, 0x7C, 0x38 } }, // V
  { { 0x00, 0xC6, 0xC6, 0xC6, 0xD6, 0xFE, 0xEE, 0xC6 } }, // W
  { { 0x00, 0xC6, 0xEE, 0x7C, 0x38, 0x7C, 0xEE, 0xC6 } }, // X
  { { 0x00, 0xC6, 0xEE, 0x7C, 0x38, 0x38, 0x38, 0x38 } }, // Y
  { { 0x00, 0xFE, 0xFE, 0x0E, 0x38, 0xE0, 0xFE, 0xFE } }, // Z
  { { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 } }, // SPACE
  { { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x30 } }, // FULL STOP
  { { 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC } }, // UNKNOWN (added)
};

/**
 * A table which maps from ASCII into the in-game glyph encoding.
 */
const unsigned char ascii_to_font[256] =
{
#define _ 38 // UNKNOWN
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
 36,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _, 37,  _,
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  _,  _,  _,  _,  _,  _,
 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,  0,
 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,  _,
#undef _
};

