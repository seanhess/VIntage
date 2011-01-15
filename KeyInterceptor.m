//
//  KeyInterceptor.m
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KeyInterceptor.h"

#define noKey 1

OSStatus keyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData);

//http://dbachrach.com/blog/2005/11/program-global-hotkeys-in-cocoa-easily/

@implementation KeyInterceptor


-(void)listen {

	eventType.eventClass = kEventClassKeyboard;
	eventType.eventKind = kEventHotKeyPressed; //kEventHotKeyReleased;
	
	// method, modifiers?, eventType, object, ???
	InstallApplicationEventHandler(&keyHandler, 1, &eventType, NULL, NULL);
	
	hotKeyID.signature = 'htk1';	// name of the hotkey
	hotKeyID.id = 1;				// unique id?
	

	// They decided to force you to have a modifier key? To prevent key loggers? Lame
	// cmdKey, optionKey, shiftKey, controlKey
	// No, you shouldn't need one, it was working before with v
	
	// space bar, flags, hotKeyID, 
	RegisterEventHotKey(49, noKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);
	
	
	// right arrow key
	// looks like you can reuse them
	hotKeyID.signature='htk2';
	hotKeyID.id=2;
	RegisterEventHotKey(124, noKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);
	
	
}

- (void)unlisten {
//	EventHotKeyRef carbonHotKey = (EventHotKeyRef)[hotKeyRef pointerValue];
//	UnregisterEventHotKey(carbonHotKey);
}

OSStatus keyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData)
{
	//Do something once the key is pressed
	NSLog(@"WOOT ");
	return noErr;
}


@end
