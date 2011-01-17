//
//  InputNinjaAppDelegate.m
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputNinjaAppDelegate.h"
#import "KeyInterceptor.h"
#import "EventTapExample.h"

@implementation InputNinjaAppDelegate

@synthesize window, statusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
//	self.statusItem.highlightMode = YES;
//	[statusItem setHighlightMode:YES];
//	[statusItem setTitle:@"Input Ninja"];
	[statusItem setImage:[NSImage imageNamed:@"Ninja-Small.png"]];
	
//	NSMenu * menu = [[NSMenu alloc] initWithTitle:@""];
//	[menu addItemWithTitle:@"Quit Input Ninja" action:@selector(quit:) keyEquivalent:@""];
//	[statusItem setMenu:menu];
	
//	[menu release];
	
	listener = [VIListener new];
	listener.statusItem = statusItem;
	[listener listen];
	
//	NSLog(@"KEYS: %@", [[KeyInterceptor shared] parseKeyIds:@"H aJ msJ cJ m[ s, cm."]);
	
}

- (void)dealloc {
	[[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
	[listener release];
	[statusItem release];
	[super dealloc];
}

@end
