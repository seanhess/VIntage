//
//  InputNinjaAppDelegate.m
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputNinjaAppDelegate.h"
#import "KeyInterceptor.h"

@implementation InputNinjaAppDelegate

@synthesize window, statusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
//	self.statusItem.highlightMode = YES;
//	[statusItem setHighlightMode:YES];
//	[statusItem setTitle:@"Input Ninja"];
	[statusItem setImage:[NSImage imageNamed:@"icon.png"]];
	
//	NSMenu * menu = [[NSMenu alloc] initWithTitle:@""];
//	[menu addItemWithTitle:@"Hi" action:NULL keyEquivalent:@""];
//	[statusItem setMenu:menu];
	
//	[menu release];
	
	
//	listener = [VIListener new];
//	[listener listen];
	
	KeyInterceptor * interceptor = [KeyInterceptor new];
	[interceptor listen];
}

- (void)dealloc {
	[[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
	[statusItem release];
	[listener release];
	[super dealloc];
}

@end
