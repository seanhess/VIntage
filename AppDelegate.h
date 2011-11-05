//
//  InputNinjaAppDelegate.h
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "VIListener.h"
#import "ModeDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, ModeDelegate> {
    NSWindow *window;


    NSWindow * modeWindow;
	NSStatusItem * statusItem;
	VIListener * listener;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSStatusItem * statusItem;
@property (retain) NSWindow * modeWindow;

@end
