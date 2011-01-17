//
//  InputNinjaAppDelegate.h
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "VIListener.h"

@interface InputNinjaAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSStatusItem * statusItem;
	VIListener * listener;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSStatusItem * statusItem;

@end
