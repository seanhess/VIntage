//
//  KeyInterceptor.m
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// See EventTapExample

#import "KeyInterceptor.h"
#import "KeyPress.h"

#define CmdChar @"m" // @"⌘"
#define CtlChar @"c" // @"⌃"
#define AltChar @"a" // @"⌥"
#define ShiftChar @"s" // @"⇧"


// THE HANDLER FUNCTION

CGEventRef onKeyDown(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
	
	KeyInterceptor * keys = (KeyInterceptor*)refcon;

	KeyFlags flags = CGEventGetFlags(event);	
	
	KeyPress * info = [[KeyPress new] autorelease];
	
	info.event = event;
	
	info.code = CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
	info.flags = CGEventGetFlags(event);

	info.cmd = ((flags & KeyCmd) != 0);
	info.alt = ((flags & KeyAlt) != 0);
	info.shift = ((flags & KeyShift) != 0);
	info.ctl = ((flags & KeyCtl) != 0);
	
	NSLog(@"DOWN %@", info.keyId);
	
	// HISTORY
	[keys.presses insertObject:info atIndex:0];
	if (keys.presses.count > 3) {
		[keys.presses removeObjectAtIndex:3];
	}
	
//	NSLog(@"L1: (%@)", info.keyId);
//	NSLog(@"L2: (%@)", [KeyInterceptor keyIdLastTwo:keys.presses]);
//	NSLog(@"L3: (%@)", [KeyInterceptor keyIdLastThree:keys.presses]);	

	for (HotKeyGroup * group in keys.groups) {
		if (group.enabled) {
			[group onKeyDown:info presses:keys.presses];
		}
	}
	
	// a group can modify the event
	return info.event;
}

CGEventRef onKeyUp(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
	
//	KeyCode code = CGEventGetIntegerValueField(event, kCGKeybsssssssssssssssssoardEventKeycode);
//	CGEventFlags flags = CGEventGetFlags(event);
//	
//	NSLog(@"KEY UP %i 0x%llX", code, flags);
	
	return event;
}

CGEventRef onFlagsChanged(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
	
//	KeyCode code = CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
//	CGEventFlags flags = CGEventGetFlags(event);
//	
//	NSLog(@"FLAGS CHANGED %i 0x%llX", code, flags);
	
	return event;
}



@implementation KeyInterceptor
@synthesize groups, presses;

-(id)init {
	if (self = [super init]) {
		self.groups = [NSMutableSet set];
		self.presses = [NSMutableArray array];		
	}
	return self;
}

-(void)listen {
	
	CFMachPortRef downEventTap = CGEventTapCreate(kCGHIDEventTap,kCGHeadInsertEventTap,kCGEventTapOptionDefault,CGEventMaskBit(kCGEventKeyDown),&onKeyDown,self);		
	CFRunLoopSourceRef downSourceRef = CFMachPortCreateRunLoopSource(NULL, downEventTap, 0);
	CFRelease(downEventTap);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), downSourceRef, kCFRunLoopDefaultMode);
	CFRelease(downSourceRef);	
	
	
	CFMachPortRef flagsEventTap = CGEventTapCreate(kCGHIDEventTap,kCGHeadInsertEventTap,kCGEventTapOptionDefault,CGEventMaskBit(kCGEventFlagsChanged),&onFlagsChanged,self);		
	CFRunLoopSourceRef flagsSourceRef = CFMachPortCreateRunLoopSource(NULL, flagsEventTap, 0);
	CFRelease(flagsEventTap);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), flagsSourceRef, kCFRunLoopDefaultMode);
	CFRelease(flagsSourceRef);

	CFMachPortRef upEventTap = CGEventTapCreate(kCGHIDEventTap,kCGHeadInsertEventTap,kCGEventTapOptionDefault,CGEventMaskBit(kCGEventFlagsChanged),&onKeyUp,self);		
	CFRunLoopSourceRef upSourceRef = CFMachPortCreateRunLoopSource(NULL, upEventTap, 0);
	CFRelease(upEventTap);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), upSourceRef, kCFRunLoopDefaultMode);
	CFRelease(upSourceRef);
}

+ (NSString*)keyId:(KeyCode)code cmd:(BOOL)cmd alt:(BOOL)alt ctl:(BOOL)ctl shift:(BOOL)shift {
	NSString * string = [KeyInterceptor stringForCode:code];
	if (cmd) string = [CmdChar stringByAppendingString:string];
	if (shift) string = [ShiftChar stringByAppendingString:string];
	if (alt) string = [AltChar stringByAppendingString:string];
	if (ctl) string = [CtlChar stringByAppendingString:string];
	return string;
}

+(NSString*)keyId:(KeyCode)code {
	return [self keyId:code cmd:NO alt:NO ctl:NO shift:NO];
}

+ (NSString*)keyIdLastTwo:(NSArray*)presses {
	NSString * keyId = @"";
	if (presses.count > 0) keyId = [[presses objectAtIndex:0] keyId];
	if (presses.count > 1) keyId = [keyId stringByAppendingFormat:@" %@", [[presses objectAtIndex:1] keyId]];
	return keyId;
}

+ (NSString*)keyIdLastThree:(NSArray*)presses {
	NSString * keyId = [KeyInterceptor keyIdLastTwo:presses];
	if (presses.count > 2) 
		keyId = [keyId stringByAppendingFormat:@" %@", [[presses objectAtIndex:2] keyId]];
	return keyId;
}
			 
- (void)add:(HotKeyGroup*)group {
	NSLog(@"Adding Group");
	[groups addObject:group];
}
			 
- (void)remove:(HotKeyGroup*)group {
	[groups removeObject:group];
}

- (void)send:(KeyCode)code {
	[self send:code cmd:NO alt:NO ctl:NO shift:NO];	
}

- (void)send:(KeyCode)code cmd:(BOOL)cmd alt:(BOOL)alt ctl:(BOOL)ctl shift:(BOOL)shift {
	
	CGEventFlags flags = 0;
	
	if (cmd) flags = flags | KeyCmd;
	if (alt) flags = flags | KeyAlt;
	if (ctl) flags = flags | KeyCtl;
	if (shift) flags = flags | KeyShift;	
	
	CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
	CGEventRef keyDownPress = CGEventCreateKeyboardEvent(source, (CGKeyCode)code, YES);

	if (flags) {
		CGEventSetFlags(keyDownPress, flags);
	}
	
	//	CGEventRef keyUpPress = CGEventCreateKeyboardEvent(source, (CGKeyCode)keyCode, NO);
	//	CGEventSetFlags(keyUpPress, (CGEventFlags)flags);	

	CGEventPost(kCGAnnotatedSessionEventTap, keyDownPress);
	//	CGEventPost(kCGAnnotatedSessionEventTap, keyUpPress);
	
	CFRelease(keyDownPress);
	CFRelease(source);
	//	CFRelease(keyUpPress);
	
}

+ (NSString*)stringForCode:(KeyCode)code {
	switch (code) {
		case KeyEscape: return @"Esc";
		case KeyBacktick: return @"`";
		case Key1: return @"1";
		case Key2: return @"2";
		case Key3: return @"3";
		case Key4: return @"4";
		case Key5: return @"5";
		case Key6: return @"6";
		case Key7: return @"7";
		case Key8: return @"8";
		case Key9: return @"9";
		case Key0: return @"10";
		case KeyMinus: return @"-";
		case KeyEquals: return @"=";
			
		case KeyTab: return @"Tab";
		case KeyQ: return @"Q";
		case KeyW: return @"W";
		case KeyE: return @"E";
		case KeyR: return @"R";
		case KeyT: return @"T";
		case KeyY: return @"Y";
		case KeyU: return @"U";
		case KeyI: return @"I";
		case KeyO: return @"O";
		case KeyP: return @"P";
		case KeyLBracket: return @"[";
		case KeyRBracket: return @"]";
		case KeyBackslash: return @"\\";
			
		case KeyA: return @"A";
		case KeyS: return @"S";
		case KeyD: return @"D";
		case KeyF: return @"F";
		case KeyG: return @"G";
		case KeyH: return @"H";
		case KeyJ: return @"J";
		case KeyK: return @"K";
		case KeyL: return @"L";
		case KeySemicolon: return @";";
		case KeyApostrophe: return @"'";
		case KeyEnter: return @"Enter";
			
		case KeyZ: return @"Z";
		case KeyX: return @"X";
		case KeyC: return @"C";
		case KeyV: return @"V";
		case KeyB: return @"B";
		case KeyN: return @"N";
		case KeyM: return @"M";
		case KeyComma: return @",";
		case KeyPeriod: return @".";
		case KeySlash: return @"/";
			
		case KeyUp: return @"Up";
		case KeyDown: return @"Down";
		case KeyLeft: return @"Left";
		case KeyRight: return @"Right";
		default: return @"";
	}
}


- (void)resetHistory {
	self.presses = [NSMutableArray array];
}


- (void)dealloc {
	[presses release];
	[groups release];
	[super dealloc];
}

@end













