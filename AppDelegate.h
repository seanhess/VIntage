//
//  InputNinjaAppDelegate.h
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ModeDelegate.h"
#import "FocusObserver.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, ModeDelegate, FocusDelegate> {
    NSWindow *window;


    NSWindow * modeWindow;
	NSStatusItem * statusItem;
    
    FocusObserver * focus;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSStatusItem * statusItem;
@property (retain) NSWindow * modeWindow;
@property (retain) FocusObserver * focus;

@end
