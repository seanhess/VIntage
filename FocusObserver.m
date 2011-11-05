//
//  CurrentApplicationState.m
//  VIntage
//
//  Created by Sean Hess on 11/5/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

// Detect Application Starting or Quitting - Process Manager or NSWorkspace
// NSRunningApplication - http://developer.apple.com/library/mac/#documentation/AppKit/Reference/NSRunningApplication_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40008799
// NSWorkspace - runningApplications - NSWorkspaceDidLaunchApplicationNotification, NSWorkspaceWillLaunchApplicationNotification. - event contains: NSWorkspaceApplicationKey with NSRunningApplicaiton information
// NSRunningApplication currentApplication
// NSWorkspaceDidActivateApplicationNotification
// NSWorkspaceDidDeactivateApplicationNotification

// http://stackoverflow.com/questions/853833/how-can-my-app-detect-a-change-to-another-apps-window
// AXObserverAddNotification(myObserver, thirdAppElement, kAXApplicationDeactivatedNotification, NULL)
    // AXObserverAddNotification(<#AXObserverRef observer#>, <#AXUIElementRef element#>, <#CFStringRef notification#>, <#void *refcon#>) 

    // kAXApplicationActivatedNotification -- I could use it to detect when MY applications activate / deactivate? 
    // http://www.monkeybreadsoftware.net/example-macosx-accessibilityservices-activewindowlogging.shtml
    
// Also need to detect 

#import "FocusObserver.h"

void MyAXObserverCallback( AXObserverRef observer, AXUIElementRef element,
                           CFStringRef notificationName, void * contextData )
{
    // handle the notification appropriately
    // when using ObjC, your contextData might be an object, therefore you can do:
//    SomeObject * obj = (SomeObject *) contextData;
    // now do something with obj
}

@implementation FocusObserver

- (void) test:(NSDictionary*)userInfo {
    NSLog(@"ACtiVATE %@", userInfo);
}

- (void) observe {

//AXUIElementRef app = AXUIElementCreateApplication( targetApplicationProcessID );
//AXUIElementRef frontWindow = NULL;
//AXError err = AXUIElementCopyAttributeValue( app, kAXMainWindowAttribute, &frontWindow );
//if ( err != kAXErrorSuccess )
//    // it failed -- maybe no main window (yet)
// AXObserverAddNotification( observer, frontWindow, kAXMovedNotification, self );

    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(test:) name:NSWorkspaceDidActivateApplicationNotification object:nil];

}

@end
