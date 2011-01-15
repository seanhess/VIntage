//
//  KeyInterceptor.m
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// TUTORIAL http://dbachrach.com/blog/2005/11/program-global-hotkeys-in-cocoa-easily/
// -- http://wafflesoftware.net/shortcut/
// YAY http://manytricks.com/keycodes/

#import "KeyInterceptor.h"
#import "HotKey.h"




OSStatus keyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData);

@interface KeyInterceptor()
@property (nonatomic, retain) NSMutableDictionary * listeners;
@end


@implementation KeyInterceptor
@synthesize listeners;

-(void)listen {

	self.listeners = [NSMutableDictionary dictionary];

	// set up the main listener
	EventTypeSpec eventType;
	eventType.eventClass = kEventClassKeyboard;
	eventType.eventKind = kEventHotKeyPressed; //kEventHotKeyReleased;
	
	// method, modifiers?, eventType, object, ???
	InstallApplicationEventHandler(&keyHandler, 1, &eventType, self, NULL);	
	
}

- (void)onPress:(KeyCode)code block:(void(^)(void))block {	
	
	[self onPress:code modifiers:noKey block:block];
	
}

- (void)onPress:(KeyCode)code modifiers:(NSUInteger)modifiers block:(void(^)(void))block {
	
	// cmdKey, optionKey, shiftKey, controlKey
	// 49=space bar, flags, hotKeyID, 

	HotKey * key = [HotKey keyWithCode:code modifiers:modifiers block:block];	
	
	if (![listeners objectForKey:key.dictionaryKey])
		[listeners setObject:key forKey:key.dictionaryKey];
	
	// forget the keyRef for now, we don't need to unregister anything
	EventHotKeyRef keyRef;
	RegisterEventHotKey(key.code, key.modifiers, key.keyId, GetApplicationEventTarget(), 0, &keyRef);	
}

- (HotKey*)keyForId:(EventHotKeyID)keyId {
	NSString * dictionaryKey = [HotKey dictionaryKeyFromKeyId:keyId];
	return [listeners objectForKey:dictionaryKey];
}



- (void)broadcast:(KeyCode)code {
	[self broadcast:code modifiers:0];	
}

- (void)broadcast:(KeyCode)code modifiers:(NSUInteger)modifiers {
	
	CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
	CGEventRef keyDownPress = CGEventCreateKeyboardEvent(source, (CGKeyCode)code, YES);

	if (modifiers) {
		NSLog(@"SETTING MODIFIERS %i", modifiers);
		CGEventSetFlags(keyDownPress, (CGEventFlags)modifiers);
	}
	
	//	CGEventRef keyUpPress = CGEventCreateKeyboardEvent(source, (CGKeyCode)keyCode, NO);
	//	CGEventSetFlags(keyUpPress, (CGEventFlags)flags);	

	CGEventPost(kCGAnnotatedSessionEventTap, keyDownPress);
	//	CGEventPost(kCGAnnotatedSessionEventTap, keyUpPress);
	
	CFRelease(keyDownPress);
	CFRelease(source);
	//	CFRelease(keyUpPress);
	
}

- (void)unlisten {
//	EventHotKeyRef carbonHotKey = (EventHotKeyRef)[hotKeyRef pointerValue];
//	UnregisterEventHotKey(carbonHotKey);
}

OSStatus keyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData)
{
	//Do something once the key is pressed
	
	KeyInterceptor * keys = (KeyInterceptor*)userData;

	EventHotKeyID hotKeyID;
	GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotKeyID),NULL,&hotKeyID);
	
	HotKey * key = [keys keyForId:hotKeyID];
	key.block();
	
	// So, now this is happening on press
	
//	CGKeyCode keyCode = 40; // #8
//	CGEventFlags flags = 0;
//	
//	CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
//	CGEventRef keyDownPress = CGEventCreateKeyboardEvent(source, (CGKeyCode)keyCode, YES);
//	CGEventSetFlags(keyDownPress, (CGEventFlags)flags);
//	CGEventRef keyUpPress = CGEventCreateKeyboardEvent(source, (CGKeyCode)keyCode, NO);
//	CGEventSetFlags(keyUpPress, (CGEventFlags)flags);	
//	
//	CGEventPost(kCGAnnotatedSessionEventTap, keyDownPress);
//	CGEventPost(kCGAnnotatedSessionEventTap, keyUpPress);
//	
//	CFRelease(keyDownPress);
//	CFRelease(keyUpPress);
//	CFRelease(source);
	
	
	
	
	// ALSO // Not sure what this does
	CallNextEventHandler(nextHandler, theEvent);
	
	return noErr;
}

- (void)dealloc {
	[self unlisten];
	[super dealloc];
}

@end













