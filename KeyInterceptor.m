//
//  KeyInterceptor.m
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// See EventTapExample

#import "KeyInterceptor.h"
#import "Command.h"
#import "RegexKitLite.h"
#import "HotKeyGroup.h"
#import "HotKey.h"




// THE HANDLER FUNCTION

CGEventRef onKeyDown(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {

	KeyInterceptor * keys = [KeyInterceptor shared];
    
	if (type == kCGEventTapDisabledByTimeout) {
		NSLog(@"Event Taps Disabled! Re-enabling");
		[keys enable];
		return event;
	}
    
    else if (type == -1) {
        // ignore: probably just code 0 for when it starts and switches apps
        return event;
    }
	
	NSAutoreleasePool * pool = [NSAutoreleasePool new];
	
	[keys setSource:CGEventCreateSourceFromEvent(event)];

	KeyFlags flags = CGEventGetFlags(event);	
	
	Command * info = [Command new];
	
	info.event = event;
	
	info.code = CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);

	info.cmd = ((flags & KeyCmd) != 0);
	info.alt = ((flags & KeyAlt) != 0);
	info.shift = ((flags & KeyShift) != 0);
	info.ctl = ((flags & KeyCtl) != 0);
	
	// HISTORY
    event = [keys processKeyDown:info]; // return info.event, or nil to pass?
	
	[info release];
	[pool release];
	return event;
}


//CGEventRef onKeyUp(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
//	
////	KeyCode code = CGEventGetIntegerValueField(event, kCGKeybsssssssssssssssssoardEventKeycode);
////	CGEventFlags flags = CGEventGetFlags(event);
////	
////	NSLog(@"KEY UP %i 0x%llX", code, flags);
//	
//	return event;
//}
//
//CGEventRef onFlagsChanged(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
//	
////	KeyCode code = CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
////	CGEventFlags flags = CGEventGetFlags(event);
////	
////	NSLog(@"FLAGS CHANGED %i 0x%llX", code, flags);
//	
//	return event;
//}



@implementation KeyInterceptor
@synthesize groups, buffer, codesForStrings, delegate;
@synthesize activeGroup;

-(id)init {
	if (self = [super init]) {
		self.groups = [NSMutableSet set];
		self.buffer = [NSMutableArray array];	
		
		self.codesForStrings = [NSMutableDictionary dictionary];
		
		[codesForStrings setObject:[NSNumber numberWithInt:KeyEscape] forKey:@"Escape"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyBacktick] forKey:@"`"];
		[codesForStrings setObject:[NSNumber numberWithInt:Key1] forKey:@"1"];
		[codesForStrings setObject:[NSNumber numberWithInt:Key2] forKey:@"2"];
		[codesForStrings setObject:[NSNumber numberWithInt:Key3] forKey:@"3"];
		[codesForStrings setObject:[NSNumber numberWithInt:Key4] forKey:@"4"];
		[codesForStrings setObject:[NSNumber numberWithInt:Key5] forKey:@"5"];
		[codesForStrings setObject:[NSNumber numberWithInt:Key6] forKey:@"6"];
		[codesForStrings setObject:[NSNumber numberWithInt:Key7] forKey:@"7"];
		[codesForStrings setObject:[NSNumber numberWithInt:Key8] forKey:@"8"];
		[codesForStrings setObject:[NSNumber numberWithInt:Key9] forKey:@"9"];
		[codesForStrings setObject:[NSNumber numberWithInt:Key0] forKey:@"0"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyMinus] forKey:@"-"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyEquals] forKey:@"="];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyDelete] forKey:@"Delete"];		
		
		[codesForStrings setObject:[NSNumber numberWithInt:KeyTab] forKey:@"Tab"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyQ] forKey:@"Q"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyW] forKey:@"W"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyE] forKey:@"E"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyR] forKey:@"R"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyT] forKey:@"T"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyY] forKey:@"Y"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyU] forKey:@"U"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyI] forKey:@"I"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyO] forKey:@"O"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyP] forKey:@"P"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyLBracket] forKey:@"["];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyRBracket] forKey:@"]"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyBackslash] forKey:@"\\"];
		
		[codesForStrings setObject:[NSNumber numberWithInt:KeyA] forKey:@"A"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyS] forKey:@"S"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyD] forKey:@"D"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyF] forKey:@"F"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyG] forKey:@"G"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyH] forKey:@"H"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyJ] forKey:@"J"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyK] forKey:@"K"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyL] forKey:@"L"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeySemicolon] forKey:@";"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyApostrophe] forKey:@"'"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyEnter] forKey:@"Enter"];
		
		[codesForStrings setObject:[NSNumber numberWithInt:KeyZ] forKey:@"Z"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyX] forKey:@"X"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyC] forKey:@"C"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyV] forKey:@"V"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyB] forKey:@"B"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyN] forKey:@"N"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyM] forKey:@"M"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyComma] forKey:@","];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyPeriod] forKey:@"."];
		[codesForStrings setObject:[NSNumber numberWithInt:KeySlash] forKey:@"/"];
		
		[codesForStrings setObject:[NSNumber numberWithInt:KeyUp] forKey:@"Up"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyDown] forKey:@"Down"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyLeft] forKey:@"Left"];
		[codesForStrings setObject:[NSNumber numberWithInt:KeyRight] forKey:@"Right"];
	}
	return self;
}

+(KeyInterceptor*)shared {
	static KeyInterceptor * keys = nil;
	
	if (!keys) {
		keys = [KeyInterceptor new];
	}
	
	return keys;
}

-(void)listen {
	
	eventTap = CGEventTapCreate(kCGHIDEventTap,kCGHeadInsertEventTap,kCGEventTapOptionDefault,CGEventMaskBit(kCGEventKeyDown),&onKeyDown,self);		
	runLoopSource = CFMachPortCreateRunLoopSource(NULL, eventTap, 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);	
	
//	CFMachPortRef flagsEventTap = CGEventTapCreate(kCGHIDEventTap,kCGHeadInsertEventTap,kCGEventTapOptionDefault,CGEventMaskBit(kCGEventFlagsChanged),&onFlagsChanged,self);		
//	CFRunLoopSourceRef flagsSourceRef = CFMachPortCreateRunLoopSource(NULL, flagsEventTap, 0);
//	CFRelease(flagsEventTap);
//	CFRunLoopAddSource(CFRunLoopGetCurrent(), flagsSourceRef, kCFRunLoopDefaultMode);
//	CFRelease(flagsSourceRef);
//
//	CFMachPortRef upEventTap = CGEventTapCreate(kCGHIDEventTap,kCGHeadInsertEventTap,kCGEventTapOptionDefault,CGEventMaskBit(kCGEventFlagsChanged),&onKeyUp,self);		
//	CFRunLoopSourceRef upSourceRef = CFMachPortCreateRunLoopSource(NULL, upEventTap, 0);
//	CFRelease(upEventTap);
//	CFRunLoopAddSource(CFRunLoopGetCurrent(), upSourceRef, kCFRunLoopDefaultMode);
//	CFRelease(upSourceRef);
}

-(void)unlisten {
//	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
//	CFRelease(downSourceRef);
}

- (HotKeyGroup*)groupWithName:(NSString*)name {
	for (HotKeyGroup * group in groups) {
		if ([[group.name lowercaseString] isEqualToString:[name lowercaseString]]) {
			return group;
		}
	}
	
	return nil;
}

-(void)enable {
	CGEventTapEnable(eventTap, true);
}

-(void)disable {
    CGEventTapEnable(eventTap, false);
}

- (NSString*) describeBuffer {
    return [self.buffer componentsJoinedByString:@" "];
}

- (void) clearBuffer {
    self.buffer = [NSMutableArray array];
}

- (CGEventRef) processKeyDown:(Command*)info {
    [self.buffer addObject:info]; // now they is in order
    
    NSLog(@"Buffer: %@", self.describeBuffer);
    
    HotKey * key = [self.activeGroup keyForPresses:self.buffer];
    
    // 1 // Continue command
    // 2 // Commands
    // 3 // Nothing (stop)
    
    if (key) {        
        
        // it can send a normal command
        if (key.commands) {
            [self sendString:key.commands]; // will break it all out
            [self clearBuffer];  // clear the buffer to listen for new commands                    
        }
        
        // or a continue key, which means we have more options, so stop
        [info stopEvent];
    }
    
    // null represents a failure
    else {
        [self clearBuffer];
    }
    
    return info.event;
}











- (NSArray*)parseKeyIds:(NSString *)keyId {
	NSMutableArray * keyPresses = [NSMutableArray array];
	NSArray * keys = [keyId componentsSeparatedByRegex:@" "];
	
	for (NSString * subKeyId in keys) {		
		Command * press = [self parseKeyId:subKeyId];
		if (press) [keyPresses addObject:press];
	}
	
	return keyPresses;
}

- (Command*)parseKeyId:(NSString*)keyId {
	
	NSArray * components = [keyId arrayOfCaptureComponentsMatchedByRegex:@"([casm]?)([casm]?)([casm]?)([casm]?)([^casm]+)"];
	if (!components) return nil;
	components = [components objectAtIndex:0];

	NSString * key = [components objectAtIndex:5];

	Command * command = [[Command new] autorelease];
    command.raw = keyId;
	command.code = [self codeForString:key];
    
    
    
	for (int i = 1; i <= 4; i++) {
		NSString * flag = [components objectAtIndex:i];
		command.ctl = command.ctl || ([flag isEqualToString:@"c"]);
		command.alt = command.alt || ([flag isEqualToString:@"a"]);
		command.shift = command.shift || ([flag isEqualToString:@"s"]);
		command.cmd = command.cmd || ([flag isEqualToString:@"m"]);
	}

	return command;
}


- (void)add:(HotKeyGroup*)group {
	[groups addObject:group];
}
			 
- (void)remove:(HotKeyGroup*)group {
	[groups removeObject:group];
}

- (void)activateGroup:(HotKeyGroup*)newGroup {
    
    for (HotKeyGroup * group in groups) {
        group.enabled = NO;
    }
    
    self.activeGroup = newGroup;    
    self.activeGroup.enabled = YES;
    [delegate didChangeToGroup:self.activeGroup];
}

- (void)activateGroupWithName:(NSString*)name {
    [self activateGroup:[self groupWithName:name]];
}

- (void)sendString:(NSString*)string {
	NSArray * parsed = [self parseKeyIds:string];
    
	for (Command * press in parsed) {
        if (press.code == KeyNotValid) {
            HotKeyGroup * group = [self groupWithName:press.raw];
            if ([press.raw isEqualToString:@"STOP"]) {
            
            }
                
            else if (group) {
                [self activateGroup:group];
            }
        }
        else {    
            [self sendKey:press.code cmd:press.cmd alt:press.alt ctl:press.ctl shift:press.shift];
        }
	}
}

- (void)sendKey:(KeyCode)code {
	[self sendKey:code cmd:NO alt:NO ctl:NO shift:NO];
}

- (void)sendKey:(KeyCode)code cmd:(BOOL)cmd alt:(BOOL)alt ctl:(BOOL)ctl shift:(BOOL)shift {
	CGEventFlags flags = 0;
	
	if (cmd) flags = flags | KeyCmd;
	if (alt) flags = flags | KeyAlt;
	if (ctl) flags = flags | KeyCtl;
	if (shift) flags = flags | KeyShift;	
	
	//	NSLog(@"SEND KEY %i %i", code, flags);	
	
	CGEventRef keyDownPress = CGEventCreateKeyboardEvent(eventSource, (CGKeyCode)code, YES);
	CGEventSetFlags(keyDownPress, flags);
	
	CGEventRef keyUpPress = CGEventCreateKeyboardEvent(eventSource, (CGKeyCode)code, NO);
	CGEventSetFlags(keyUpPress, flags);	
	
	CGEventPost(kCGAnnotatedSessionEventTap, keyDownPress);
	CGEventPost(kCGAnnotatedSessionEventTap, keyUpPress);
	
	CFRelease(keyDownPress);
	CFRelease(keyUpPress);
}

- (void)setSource:(CGEventSourceRef)s {
	if (eventSource) CFRelease(eventSource);
	eventSource = s;
	CFRetain(eventSource);
}

- (NSString*)stringForCode:(KeyCode)code {
	switch (code) {
		case KeyEscape: return @"Escape";
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
		case Key0: return @"0";
		case KeyMinus: return @"-";
		case KeyEquals: return @"=";
		case KeyDelete: return @"Delete";
			
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

- (KeyCode)codeForString:(NSString*)string {
    id object = [codesForStrings objectForKey:string];
    if (!object) return KeyNotValid;
	return [object intValue];
}


- (CGEventRef)nullEvent {
	if (!nullEvent) nullEvent = CGEventCreate(NULL);
	return nullEvent;
}


- (void)dealloc {
	[buffer release];
	[groups release];
	[codesForStrings release];
    [activeGroup release];
	if (runLoopSource) CFRelease(runLoopSource);
	if (eventSource) CFRelease(eventSource);
	if (eventTap) CFRelease(eventTap);	
	[super dealloc];
}

@end













