//
//  TheGreatEscapeView.m
//  The Great Escape
//
//  Created by David Thomas on 11/10/2014.
//  Copyright (c) 2014-2017 David Thomas. All rights reserved.
//

#import <ctype.h>

#import <pthread.h>

#import <Foundation/Foundation.h>

#import <OpenGL/gl.h>
#import <OpenGL/glext.h>
#import <OpenGL/glu.h>

#import <GLUT/glut.h>

#import "ZXSpectrum/Spectrum.h"
#import "ZXSpectrum/Keyboard.h"
#import "ZXSpectrum/Kempston.h"

#import "TheGreatEscape/TheGreatEscape.h"

#import "TheGreatEscapeView.h"

// -----------------------------------------------------------------------------

// Configuration
//
#define WIDTH  256
#define HEIGHT 192

// -----------------------------------------------------------------------------

#pragma mark - UIView

@interface TheGreatEscapeView()
{
  zxspectrum_t *zx;
  tgestate_t   *game;

  unsigned int *pixels;
  pthread_t     thread;
  zxkeyset_t    keys;
  zxkempston_t  kempston;

  float         scale;

  int           speed;
  BOOL          paused;
}

@end

// -----------------------------------------------------------------------------

@implementation TheGreatEscapeView

// -----------------------------------------------------------------------------

#pragma mark - Game thread callbacks

// we should probably just schedule events rather than doing UI things from
// these handlers - these are entered from the game thread, not the UI thread
static void draw_handler(unsigned int  *pixels,
                         const zxbox_t *dirty,
                         void          *opaque)
{
  // FUTURE: Might be a better idea to save up all dirty rects then dispatch
  // them in one go periodically (i.e. capped at 60fps).

  TheGreatEscapeView *view = (__bridge id) opaque;

  view->pixels = pixels;

  // Odd: This refreshes the whole window no matter what size of rect is specified
  [view setNeedsDisplayInRect:NSMakeRect(0, 0, WIDTH * view->scale, HEIGHT * view->scale)];
}

static void sleep_handler(int duration, sleeptype_t sleeptype, void *opaque)
{
  TheGreatEscapeView *view = (__bridge id) opaque;

  if (view->paused)
  {
    // Check twice per second for unpausing
    // FIXME: Slow spinwait without any synchronisation
    while (view->paused)
      usleep(500000);
  }
  else
  {
    usleep(duration * 100 / view->speed);
  }
}

static int key_handler(uint16_t port, void *opaque)
{
  TheGreatEscapeView *view = (__bridge id) opaque;

  if (port == 0x001F)
    return view->kempston;
  else
    return zxkeyset_for_port(port, view->keys);
}

static void border_handler(int colour, void *opaque)
{
  TheGreatEscapeView *view = (__bridge id) opaque;
  NSColor            *c;

  switch (colour)
  {
    default:
    case 0: c = NSColor.blackColor;   break;
    case 1: c = NSColor.blueColor;    break;
    case 2: c = NSColor.redColor;     break;
    case 3: c = NSColor.magentaColor; break;
    case 4: c = NSColor.greenColor;   break;
    case 5: c = NSColor.cyanColor;    break;
    case 6: c = NSColor.yellowColor;  break;
    case 7: c = NSColor.whiteColor;   break;
  }

  // FIXME: Do this on the UI thread.
  [[view window] setBackgroundColor:c];
}

// -----------------------------------------------------------------------------

#pragma mark - Game thread

static void *tge_thread(void *arg)
{
  TheGreatEscapeView *view = (__bridge id) arg;
  tgestate_t         *game = view->game;

  tge_setup(game);

  for (;;) // while (!quit)
    tge_main(game);

  //tge_destroy(game);

  //ZXSpectrum_destroy(zx);

  return NULL;
}

// -----------------------------------------------------------------------------

#pragma mark - blah

- (void)awakeFromNib
{
  const zxconfig_t zxconfig =
  {
    (__bridge void *)(self),
    &draw_handler,
    &sleep_handler,
    &key_handler,
    &border_handler
  };

  /* Configuration of The Great Escape instance. */
  static const tgeconfig_t tgeconfig =
  {
    WIDTH  / 8,
    HEIGHT / 8
  };


  zx     = NULL;
  game   = NULL;

  pixels = NULL;
  thread = NULL;
  keys   = 0ULL;

  scale  = 1.0f;

  speed  = 100;
  paused = NO;


  NSWindow *w = [self window];

  /* Enforce a (4:3) aspect ratio for the window. */
  [w setContentAspectRatio:NSMakeSize(WIDTH, HEIGHT)];


  NSRect contentRect = NSMakeRect(0, 0, tgeconfig.width * 8 * scale, tgeconfig.height * 8 * scale);

  [w setFrame:[w frameRectForContentRect:contentRect] display:YES];

  [self setFrame:NSMakeRect(0, 0, contentRect.size.width, contentRect.size.height)];


  zx = zxspectrum_create(&zxconfig);
  if (zx == NULL)
    goto failure;

  game = tge_create(zx, &tgeconfig);
  if (game == NULL)
    goto failure;

  pthread_create(&thread, NULL /* pthread_attr_t */, tge_thread, (__bridge void *)(self));

  return;


failure:
  tge_destroy(game);
  zxspectrum_destroy(zx);
}

// -----------------------------------------------------------------------------

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self prepare];
  }
  return self;
}

// -----------------------------------------------------------------------------

- (void)prepare
{
  NSLog(@"prepare");

  // The GL context must be active for these functions to have an effect
  [[self openGLContext] makeCurrentContext];

  // Configure the view
  glShadeModel(GL_FLAT); // Selects flat shading
  glDisable(GL_DEPTH_TEST); // Don't update the depth buffer.

  glMatrixMode(GL_PROJECTION); // Applies subsequent matrix operations to the projection matrix stack
  glLoadIdentity(); // Replace the current matrix with the identity matrix

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  //  glTranslatef(0.375, 0.375, 0);

  // Set up constant values
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
}

// -----------------------------------------------------------------------------

//- (void)animate
//{
//  /* redraw just the region we've invalidated */
//  [self setNeedsDisplayInRect:NSMakeRect(0, 0, 1000, 1000)];
//}

- (void)reshape
{
  // Convert up to window space, which is in pixel units.
  NSRect baseRect = [self convertRectToBacking:[self bounds]];

//  // Now the result is glViewport()-compatible.
//  glViewport(0, 0, (GLsizei) baseRect.size.width, (GLsizei) baseRect.size.height);

  GLsizei w,h;

  w = baseRect.size.width;
  h = baseRect.size.height;

  scale = (double) w / WIDTH;

  glViewport(0, 0, w, h);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0, w, 0, h, 0.1, 1);
  glPixelZoom(1.0, -1.0); // needed?
  glRasterPos3f(0, h - 1, -0.3);
}

// -----------------------------------------------------------------------------

//- (void)setTimer
//{
//  [NSTimer scheduledTimerWithTimeInterval:1.0 / 30 /* 30fps */
//                                   target:self
//                                 selector:@selector(onTick:)
//                                 userInfo:nil
//                                  repeats:YES];
//}
//
//- (void)onTick:(NSTimer *)timer
//{
//  (void) timer;
//
//  [self animate];
//}

// -----------------------------------------------------------------------------

- (void)drawRect:(NSRect)dirtyRect
{
  if (scale == 0.0f)
    return;

  float zsx =  scale;
  float zsy = -scale;

  (void) dirtyRect;

  // Clear the background
  // Do this every frame or you'll see junk in the border.
  glClear(GL_COLOR_BUFFER_BIT);

  if (pixels)
  {
    // Draw the image
    glPixelZoom(zsx, zsy);
    glDrawPixels(WIDTH, HEIGHT, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
  }

  // Flush to screen
  glFinish();
}

// -----------------------------------------------------------------------------

#pragma mark - Key handling

- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (BOOL)becomeFirstResponder
{
  return YES;
}

- (IBAction)zoom:(id)sender
{
  NSInteger tag;
  NSSize    size;

  /* Menu tag is 1..4 for 1x..4x scale. */
  tag = [sender tag];
  if (tag < 1)
    tag = 1;
  else if (tag > 4)
    tag = 4;

  scale = 1.0f * tag;

  size.width  = WIDTH  * scale; // FIXME: Pull these dimensions from somewhere central.
  size.height = HEIGHT * scale;

  [[self window] setContentSize:size];

  [self setFrame:NSMakeRect(0, 0, size.width, size.height)];
}

- (IBAction)setSpeed:(id)sender
{
  const int min_speed = 10;     // percent
  const int max_speed = 100000; // percent

  NSInteger tag;

  tag = [sender tag];

  if (tag == 0) // pause/unpause
  {
    paused = !paused;
    return;
  }

  // any other action results in unpausing
  paused = NO;

  switch (tag)
  {
    default:
    case 100: // normal speed
      speed = 100;
      break;

    case 1: // increase speed
      speed += 25;
      break;

    case 2: // decrease speed
      speed -= 25;
      break;

    case -1: // maximum speed
      speed = max_speed;
      break;
  }

  if (speed < min_speed)
    speed = min_speed;
  else if (speed > max_speed)
    speed = max_speed;
}

- (void)keyUpOrDown:(NSEvent*)event isDown:(BOOL)down
{
  NSEventModifierFlags  modifierFlags;
  NSEventModifierFlags  modifiersToReject;
  NSString             *chars;
  unichar               u;
  zxjoystick_t          j;

  modifierFlags = [event modifierFlags] & NSEventModifierFlagDeviceIndependentFlagsMask;
  modifiersToReject = NSEventModifierFlagControl |
                      NSEventModifierFlagOption  |
                      NSEventModifierFlagCommand;
  if (modifierFlags & modifiersToReject)
    return;

  chars = [event characters];
  if ([chars length] == 0)
    return;

  u = [chars characterAtIndex:0];
  switch (u)
  {
    case NSUpArrowFunctionKey:    j = zxjoystick_UP;      break;
    case NSDownArrowFunctionKey:  j = zxjoystick_DOWN;    break;
    case NSLeftArrowFunctionKey:  j = zxjoystick_LEFT;    break;
    case NSRightArrowFunctionKey: j = zxjoystick_RIGHT;   break;
    case '.':                     j = zxjoystick_FIRE;    break;
    default:                      j = zxjoystick_UNKNOWN; break;
  }

  if (j != zxjoystick_UNKNOWN)
  {
    zxkempston_assign(&kempston, j, down);
  }
  else
  {
    // zxkeyset_set/clearchar converts generic keypresses for us
    if (down)
      keys = zxkeyset_setchar(keys, u);
    else
      keys = zxkeyset_clearchar(keys, u);
  }
}

- (void)keyUp:(NSEvent*)event
{
  [self keyUpOrDown:event isDown:NO];
  // NSLog(@"Key released: %@", event);
}

- (void)keyDown:(NSEvent*)event
{
  [self keyUpOrDown:event isDown:YES];
  // NSLog(@"Key pressed: %@", event);
}

- (void)flagsChanged:(NSEvent*)event
{
  /* Unlike keyDown and keyUp, flagsChanged is a single event delivered when
   * any one of the modifier key states change, down or up. */

  NSEventModifierFlags modifierFlags = [event modifierFlags];
  bool shift = (modifierFlags & NSEventModifierFlagShift) != 0;
  bool alt   = (modifierFlags & NSEventModifierFlagOption) != 0;

  /* For reference:
   *
   * bool control = (modifierFlags & NSControlKeyMask) != 0;
   * bool command = (modifierFlags & NSCommandKeyMask) != 0;
   */

  zxkeyset_assign(&keys, zxkey_CAPS_SHIFT,   shift);
  zxkeyset_assign(&keys, zxkey_SYMBOL_SHIFT, alt);

  // NSLog(@"Key shift=%d control=%d alt=%d command=%d", shift, control, alt, command);
}

// -----------------------------------------------------------------------------

@end
