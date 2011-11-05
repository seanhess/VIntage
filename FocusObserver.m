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
@synthesize delegate, applications;

- (void) onActivate:(NSNotification*)event {
    NSRunningApplication * app = [[event userInfo] objectForKey:NSWorkspaceApplicationKey];
    
    NSLog(@"SWITCHED TO APPLICATION %@ %@", app.bundleIdentifier, self.applications);
    
    for (NSString * bundleId in self.applications) {
        if ([[app bundleIdentifier] isEqualToString:bundleId]) {
            [delegate didSwitchToActive];
            return;
        }
    }
    
    [delegate didSwitchToInactive];
}

- (void) observeApplications:(NSArray*)apps delegate:(id<FocusDelegate>)del {
    self.delegate = del;
    self.applications = apps;
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(onActivate:) name:NSWorkspaceDidActivateApplicationNotification object:nil];
}

- (void) dealloc {
    [applications release];
    [super dealloc];
}

@end
