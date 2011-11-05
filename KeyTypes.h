//
//  KeyTypes.h
//  InputNinja
//
//  Created by Sean Hess on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <objc/runtime.h>

typedef CGKeyCode KeyCode;
typedef CGEventFlags KeyFlags;

// cmdKey, controlKey, and optionKey are already defined
#define noKey 1

#define KeyEscape 53
#define KeyBacktick 50
#define Key1 18
#define Key2 19
#define Key3 20
#define Key4 21
#define Key5 23
#define Key6 22
#define Key7 26
#define Key8 28
#define Key9 25
#define Key0 29
#define KeyMinus 27
#define KeyEquals 24
#define KeyDelete 51

#define KeyTab 48
#define KeyQ 12
#define KeyW 13
#define KeyE 14
#define KeyR 15
#define KeyT 17
#define KeyY 16
#define KeyU 32
#define KeyI 34
#define KeyO 31
#define KeyP 35
#define KeyLBracket 33
#define KeyRBracket 30
#define KeyBackslash 42

#define KeyA 0
#define KeyS 1
#define KeyD 2
#define KeyF 3
#define KeyG 5
#define KeyH 4
#define KeyJ 38
#define KeyK 40
#define KeyL 37
#define KeySemicolon 41
#define KeyApostrophe 39
#define KeyEnter 36

#define KeyZ 6
#define KeyX 7
#define KeyC 8
#define KeyV 9
#define KeyB 11
#define KeyN 45
#define KeyM 46
#define KeyComma 43
#define KeyPeriod 47
#define KeySlash 44

#define KeyUp 126
#define KeyDown 125
#define KeyLeft 123
#define KeyRight 124

#define KeyNotValid 999

enum {
	KeyNone = 1, // not sure what the correct value is
	KeyCmd = kCGEventFlagMaskCommand,
	KeyShift = kCGEventFlagMaskShift,
	KeyAlt = kCGEventFlagMaskAlternate,
	KeyCtl = kCGEventFlagMaskControl
};


// A group of hotkeys that can be globally enabled/disabled
// and applied against different applications

@protocol KeySender

- (void)sendString:(NSString*)string;
- (void)sendKey:(KeyCode)code;
- (void)sendKey:(KeyCode)code cmd:(BOOL)cmd alt:(BOOL)alt ctl:(BOOL)ctl shift:(BOOL)shift;

@end
