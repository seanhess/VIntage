//
//  InputNinjaAppDelegate.m
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// http://developer.apple.com/library/mac/#samplecode/UIElementInspector/Introduction/Intro.html#//apple_ref/doc/uid/DTS10000728-Intro-DontLinkElementID_2

#import "AppDelegate.h"
#import "KeyInterceptor.h"
#import "EventTapExample.h"
#import "FocusObserver.h"

@implementation AppDelegate

@synthesize window, statusItem, modeWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	self.statusItem.highlightMode = YES;
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:@"VIntage"];
	[statusItem setImage:[NSImage imageNamed:@"Ninja-Small.png"]];
    
    NSRect windowRect = NSMakeRect(0, [NSScreen mainScreen].frame.size.height - 30, [NSScreen mainScreen].frame.size.width, 20);
     
    self.modeWindow = [[NSWindow alloc] initWithContentRect:windowRect styleMask:( NSResizableWindowMask ) backing:NSBackingStoreBuffered defer:NO];
    
    [self.modeWindow setLevel:NSModalPanelWindowLevel]; // try NSStatusWindowLevel
    [self.modeWindow setBackgroundColor:[NSColor blueColor]];
    [self.modeWindow makeKeyAndOrderFront:nil];  
    
//    [statusItem setHighlightMode:YES];
//    [statusItem setTitle:@"myTitle"];
//    [statusItem setToolTip:@"myToolTip"];
//    [statusItem setMenu:statusMenu];
//    [statusItem setEnabled:YES];
    
    // Can I detect when it happens?
    // Poll the accessibility API 10/s
    
    FocusObserver * cur = [FocusObserver new];
    [cur observe];
    
//    [self.modeWindow makeKeyAndOrderFront:self];        
     
//    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
//    NSAttributedString* blueTitle = [[[NSAttributedString alloc] initWithString:@"myTitle" attributes:titleAttributes] autorelease];

//    [statusItem setAttributedTitle:blueTitle]; 
//    [blueTitle release];    
    
//	NSMenu * menu = [[NSMenu alloc] initWithTitle:@""];
//	[menu addItemWithTitle:@"Quit Input Ninja" action:@selector(quit:) keyEquivalent:@""];
//	[statusItem setMenu:menu];


	
//	[menu release];
	
	listener = [VIListener new];
	listener.delegate = self;
	[listener listen];
	
//	NSLog(@"KEYS: %@", [[KeyInterceptor shared] parseKeyIds:@"H aJ msJ cJ m[ s, cm."]);
	
}

- (void)didChangeModeToName:(NSString *)name isMajor:(BOOL)isMajor {
    [self.statusItem setTitle:name]; // this works pretty well!
    
    if (isMajor)
        [self.modeWindow setAlphaValue:1.0];
    else
        [self.modeWindow setAlphaValue:0.0];
}

- (void)checkCurrentApp {
}

- (void)dealloc {
	[[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
	[listener release];
	[statusItem release];
    [modeWindow release];
	[super dealloc];
}

@end
