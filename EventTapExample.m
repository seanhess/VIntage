//
//  EventTapExample.m
//  InputNinja
//
//  Created by Sean Hess on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// GOOD ONE - http://stackoverflow.com/questions/1603030/how-to-monitor-global-modifier-key-state-in-any-application

// http://developer.apple.com/library/mac/#documentation/Carbon/Reference/QuartzEventServicesRef/Reference/reference.html
// http://stackoverflow.com/questions/4512106/how-to-create-virtual-keyboard-in-osx


// EMACS keybindings
// http://www.gnufoo.org/macosx/index.html#emacs
/*

// ~/Library/KeyBindings/DefaultKeyBinding.dict 
{
	"~f"="moveWordForward:";
	"~b"="moveWordBackward:";
	"~<"="moveToBeginningOfDocument:";
	"~>"="moveToEndOfDocument:";
	"~v"="pageUp:";
	"~d"="deleteWordForward:";
	"~^h"="deleteWordBackward:";
	"~\010"="deleteWordBackward:"; // Alt-backspace
	"~\177"="deleteWordBackward:"; // Alt-delete 
	
	// Escape should really be complete.
	"\033"="complete:"; 
}
 
// Other // http://lifehacker.com/5083249/a-few-handy-hidden-os-x-shortcuts
 
 Ctrl+A: Beginning of line (like Home)
 Ctrl+B: Backward one character (like hitting the left arrow)
 Ctrl+D: Forward delete (like the Forward Delete button on Macs)
 Ctrl+E: End of line (like End)
 Ctrl+F: Forward one character (like hitting the right arrow)
 Ctrl+H: I'm not entirely sure on this one, but it looks like it just does a right-to-left delete (like the regular delete key on Macs).
 Ctrl+K: Kill/remove text between cursor and the end of the line.
 Ctrl+N: Next line (like down arrow)
 Ctrl+P: Previous line (like up arrow)
 Ctrl+U: Remove/delete current line
 Ctrl+V: Page down
 
 
// EMacs Keys // http://allhotkeys.com/emacs_hotkeys.html
 
Delete Line - Ctl+K
Delete Selection - Ctl+W

 
 */

// Keymap Remap
// http://pqrs.org/macosx/keyremap4macbook/index.html
// Woah, it has a VI mode that does almost everything
// it's already behind where I am though :(


// OS X STrokes
// http://support.apple.com/kb/ht1343


#import "EventTapExample.h"
#import <Carbon/Carbon.h>
#import <objc/runtime.h>

CGEventRef keyUpCallback (CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    NSLog(@"KeyUp event tapped!");
	
	
	// CGEventType = uint32_t
	

	// CGIntegerValueField !!! Lots of good stuff in there
	/*
	 enum _CGEventField {
	 kCGMouseEventNumber = 0,
	 kCGMouseEventClickState = 1,
	 kCGMouseEventPressure = 2,
	 kCGMouseEventButtonNumber = 3,
	 kCGMouseEventDeltaX = 4,
	 kCGMouseEventDeltaY = 5,
	 kCGMouseEventInstantMouser = 6,
	 kCGMouseEventSubtype = 7,
	 kCGKeyboardEventAutorepeat = 8,
	 kCGKeyboardEventKeycode = 9,
	 kCGKeyboardEventKeyboardType = 10,
	 kCGScrollWheelEventDeltaAxis1 = 11,
	 kCGScrollWheelEventDeltaAxis2 = 12,
	 kCGScrollWheelEventDeltaAxis3 = 13,
	 kCGScrollWheelEventFixedPtDeltaAxis1 = 93,
	 kCGScrollWheelEventFixedPtDeltaAxis2 = 94,
	 kCGScrollWheelEventFixedPtDeltaAxis3 = 95,
	 kCGScrollWheelEventPointDeltaAxis1 = 96,
	 kCGScrollWheelEventPointDeltaAxis2 = 97,
	 kCGScrollWheelEventPointDeltaAxis3 = 98,
	 kCGScrollWheelEventInstantMouser = 14,
	 kCGTabletEventPointX = 15,
	 kCGTabletEventPointY = 16,
	 kCGTabletEventPointZ = 17,
	 kCGTabletEventPointButtons = 18,
	 kCGTabletEventPointPressure = 19,
	 kCGTabletEventTiltX = 20,
	 kCGTabletEventTiltY = 21,
	 kCGTabletEventRotation = 22,
	 kCGTabletEventTangentialPressure = 23,
	 kCGTabletEventDeviceID = 24,
	 kCGTabletEventVendor1 = 25,
	 kCGTabletEventVendor2 = 26,
	 kCGTabletEventVendor3 = 27,
	 kCGTabletProximityEventVendorID = 28,
	 kCGTabletProximityEventTabletID = 29,
	 kCGTabletProximityEventPointerID = 30,
	 kCGTabletProximityEventDeviceID = 31,
	 kCGTabletProximityEventSystemTabletID = 32,
	 kCGTabletProximityEventVendorPointerType = 33,
	 kCGTabletProximityEventVendorPointerSerialNumber = 34,
	 kCGTabletProximityEventVendorUniqueID = 35,
	 kCGTabletProximityEventCapabilityMask = 36,
	 kCGTabletProximityEventPointerType = 37,
	 kCGTabletProximityEventEnterProximity = 38,
	 kCGEventTargetProcessSerialNumber = 39,
	 kCGEventTargetUnixProcessID = 40,
	 kCGEventSourceUnixProcessID = 41,
	 kCGEventSourceUserData = 42,
	 kCGEventSourceUserID = 43,
	 kCGEventSourceGroupID = 44,
	 kCGEventSourceStateID = 45,
	 kCGScrollWheelEventIsContinuous = 88
	 };
    */
	
	NSLog(@"Event Type %i", type);
	NSLog(@"Event Timestamp %i", CGEventGetTimestamp(event));
	NSLog(@"Event Timestamp %i", CGEventGetTimestamp(event));	
//	NSLog(@"Event Location %@", )
//	NSLog(@"Integer Value Field %i", CGEventGetIntegerValueField(event, <#CGEventField field#>))
	
//  CGEventKeyboardGetUnicodeString(<#CGEventRef event#>, <#UniCharCount maxStringLength#>, <#UniCharCount *actualStringLength#>, <#UniChar [] unicodeString#>)
//  CGEventKeyboardSetUnicodeString(<#CGEventRef event#>, <#UniCharCount stringLength#>, <#const UniChar [] unicodeString#>)
	
//	CGEventSetType(<#CGEventRef event#>, <#CGEventType type#>)
//	CGEventSetTimestamp(<#CGEventRef event#>, <#CGEventTimestamp timestamp#>)
//	CGEventSetSource(<#CGEventRef event#>, <#CGEventSourceRef source#>)
//	CGEventSetLocation(<#CGEventRef event#>, <#CGPoint location#>)
//	CGEventSetIntegerValueField(<#CGEventRef event#>, <#CGEventField field#>, <#int64_t value#>)
//	CGEventSetFlags(<#CGEventRef event#>, <#CGEventFlags flags#>)
//	CGEventSetDoubleValueField(<#CGEventRef event#>, <#CGEventField field#>, <#double value#>)
//	
//	CGEventGetType(<#CGEventRef event#>)
//	CGEventGetTimestamp(<#CGEventRef event#>)
//	CGEventGetLocation(<#CGEventRef event#>)
//	CGEventGetTypeID()
//	CGEventGetUnflippedLocation(<#CGEventRef event#>)
//	CGEventGetIntegerValueField(<#CGEventRef event#>, <#CGEventField field#>)
//	CGEventGetFlags(<#CGEventRef event#>)
//	CGEventGetDoubleValueField(<#CGEventRef event#>, <#CGEventField field#>)
	
//	CGEventCreate(<#CGEventSourceRef source#>)
//	CGEventCreateCopy(<#CGEventRef event#>)
//	CGEventCreateData(<#CFAllocatorRef allocator#>, <#CGEventRef event#>)
//	CGEventCreateFromData(<#CFAllocatorRef allocator#>, <#CFDataRef data#>)
//	CGEventCreateKeyboardEvent(<#CGEventSourceRef source#>, <#CGKeyCode virtualKey#>, <#_Bool keyDown#>)
//	CGEventCreateMouseEvent(<#CGEventSourceRef source#>, <#CGEventType mouseType#>, <#CGPoint mouseCursorPosition#>, <#CGMouseButton mouseButton#>)
//	CGEventCreateScrollWheelEvent(<#CGEventSourceRef source#>, <#CGScrollEventUnit units#>, <#uint32_t wheelCount#>, <#int32_t wheel1#>)
//	CGEventCreateSourceFromEvent(<#CGEventRef event#>)

//	CGEventPost(<#CGEventTapLocation tap#>, <#CGEventRef event#>)

	
	
	
	
	
//	CGEventSourceRef // opaque type, use the methods. 
	// doesn't look super important. 
//	GEventSourceRef sourceRef = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
//	CGEventSourceCreate()
//	CGEventSourceButtonState, 
//	CGEventSourceCounterForEventType, 
//	CGEventSourceFlagsState, 
//	CGEventSourceGetKeyboardType, 
//	CGEventSourceGetLocalEventsFilterDuringSuppressionState, 
//	CGEventSourceGetLocalEventsSuppressionInterval, 
//	CGEventSourceGetPixelsPerLine, 
//	CGEventSourceGetSourceStateID, 
//	CGEventSourceGetTypeID, 
//	CGEventSourceGetUserData, 
//	CGEventSourceKeyState, 
//	CGEventSourceSecondsSinceLastEventType, 
//	CGEventSourceSetKeyboardType, 
//	CGEventSourceSetLocalEventsFilterDuringSuppressionState, 
//	CGEventSourceSetLocalEventsSuppressionInterval, 
//	CGEventSourceSetPixelsPerLine, 
//	CGEventSourceSetUserData
	
//	CGEventSourceGetTypeID

//	CGEventTapCreate(<#CGEventTapLocation tap#>, <#CGEventTapPlacement place#>, <#CGEventTapOptions options#>, <#CGEventMask eventsOfInterest#>, <#CGEventTapCallBack callback#>, <#void *userInfo#>)
//	CGEventTapEnable(<#CFMachPortRef tap#>, <#_Bool enable#>)
//	CGEventTapIsEnabled(<#CFMachPortRef tap#>)
	
	
	// it looks like I'm going to want to change the event here
	// event = CGEventCreate(NULL); // null it out
	
	// what else can I do?
	
    return event;
}

@implementation EventTapExample

-(id)init {
	if (self = [super init]) {
		
		// kCGEventKeyDown DOES detect repeats
		// Also, super-simple to allow it to pass, just do nothing
		// Only need to figure out how to stop the event
		
		/*
		 kCGEventNull                = NX_NULLEVENT,
		 kCGEventLeftMouseDown       = NX_LMOUSEDOWN,
		 kCGEventLeftMouseUp         = NX_LMOUSEUP,
		 kCGEventRightMouseDown      = NX_RMOUSEDOWN,
		 kCGEventRightMouseUp        = NX_RMOUSEUP,
		 kCGEventMouseMoved          = NX_MOUSEMOVED,
		 kCGEventLeftMouseDragged    = NX_LMOUSEDRAGGED,
		 kCGEventRightMouseDragged   = NX_RMOUSEDRAGGED,
		 kCGEventKeyDown             = NX_KEYDOWN,
		 kCGEventKeyUp               = NX_KEYUP,
		 kCGEventFlagsChanged        = NX_FLAGSCHANGED,
		 kCGEventScrollWheel         = NX_SCROLLWHEELMOVED,
		 kCGEventTabletPointer       = NX_TABLETPOINTER,
		 kCGEventTabletProximity     = NX_TABLETPROXIMITY,
		 kCGEventOtherMouseDown      = NX_OMOUSEDOWN,
		 kCGEventOtherMouseUp        = NX_OMOUSEUP,
		 kCGEventOtherMouseDragged   = NX_OMOUSEDRAGGED,
		 kCGEventTapDisabledByTimeout = 0xFFFFFFFE,
		 kCGEventTapDisabledByUserInput = 0xFFFFFFFF
		 };
		 */
		
		/*
		 
		 CFMachPortRef CGEventTapCreate (
			CGEventTapLocation tap,		kCGHIDEventTap, kCGSessionEventTap, kCGAnnotatedSessionEventTap
			CGEventTapPlacement place,  kCGHeadInsertEventTap, kCGTailAppendEventTap
			CGEventTapOptions options,	kCGEventTapOptionDefault, kCGEventTapOptionListenOnly !! I want default for sure
			CGEventMask eventsOfInterest, -- see above
			CGEventTapCallBack callback, -- see handler
			void *refcon
		 );

		 */

//		CFMachPortRef modChEventTap = CGEventTapCreate(kCGHIDEventTap,kCGHeadInsertEventTap,kCGEventTapOptionListenOnly,CGEventMaskBit(kCGEventFlagsChanged),&callbackFunction,NULL);
		CFMachPortRef keyUpEventTap = CGEventTapCreate(kCGHIDEventTap,kCGHeadInsertEventTap,kCGEventTapOptionDefault,CGEventMaskBit(kCGEventKeyDown),&keyUpCallback,NULL);		
		CFRunLoopSourceRef keyUpRunLoopSourceRef = CFMachPortCreateRunLoopSource(NULL, keyUpEventTap, 0);
		CFRelease(keyUpEventTap);
		CFRunLoopAddSource(CFRunLoopGetCurrent(), keyUpRunLoopSourceRef, kCFRunLoopDefaultMode);
		CFRelease(keyUpRunLoopSourceRef);
		
	}
	return self;
}

@end


