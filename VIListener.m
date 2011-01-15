//
//  VIListener.m
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VIListener.h"
#import "DDHotKeyCenter.h"

// http://stackoverflow.com/questions/399616/how-to-capture-post-system-wide-keyboard-mouse-events-under-mac-os-x

@implementation VIListener

-(void)listen {
	center = [[DDHotKeyCenter alloc] init];
	
	[center registerHotKeyWithKeyCode:9 modifierFlags:0 task:^(NSEvent *event) {
		NSLog(@"WOOT :: %i", [event windowNumber]);
		
//		NSEvent * newEvent = [NSEvent 
//							  keyEventWithType:[event type] 
//							  location:[event locationInWindow]
//							  modifierFlags:[event modifierFlags]
//							  timestamp:[event timestamp]
//							  windowNumber:[event windowNumber]
//							  context:[event context]
//							  characters:[event characters]
//							  charactersIgnoringModifiers:[event charactersIgnoringModifiers]
//							  isARepeat:[event isARepeat]
//							  keyCode:[event keyCode]];
//
////		[[NSApplication sharedApplication] postEvent:newEvent atStart:YES];							  
//		CGEventPost(kCGSessionEventTap, [newEvent CGEvent]);
////		NSLog(@"HMMM %@", [NSApplication sharedApplication]);
		
		
//		CGEventRef eventRef;
		
//		eventRef = CGEventCreateKeyboardEvent(NULL, 8, NO);
		//Apparently, a bug in xcode requires this next line
//		CGEventSetType(eventRef, kCGEventKeyUp);
//		CGEventPost(kCGSessionEventTap, eventRef);
//		CFRelease(eventRef);

		
//		CGEventRef eventRef = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)28, false);
//		CGEventSetType(eventRef, kCGEventKeyUp);
//		CGEventPost(kCGSessionEventTap, eventRef);
		
		CGKeyCode keyCode = 40; // #8
		CGEventFlags flags = 0;
		
		CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
		CGEventRef keyDownPress = CGEventCreateKeyboardEvent(source, (CGKeyCode)keyCode, YES);
		CGEventSetFlags(keyDownPress, (CGEventFlags)flags);
		CGEventRef keyUpPress = CGEventCreateKeyboardEvent(source, (CGKeyCode)keyCode, NO);
		
		CGEventPost(kCGAnnotatedSessionEventTap, keyDownPress);
		CGEventPost(kCGAnnotatedSessionEventTap, keyUpPress);
		
		CFRelease(keyDownPress);
		CFRelease(keyUpPress);
		CFRelease(source);
		
		return;
	}];
}
	 
- (void)dealloc {
	[center release];
	[super dealloc];
}

@end
