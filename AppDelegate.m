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
#import "Parser.h"
#import "HotKeyGroup.h"

@implementation AppDelegate

@synthesize window, statusItem, modeWindow, focus;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
    
    // WINDOW AND STATUS BAR
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
    

    
//    [self.modeWindow makeKeyAndOrderFront:self];        
     
//    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
//    NSAttributedString* blueTitle = [[[NSAttributedString alloc] initWithString:@"myTitle" attributes:titleAttributes] autorelease];

//    [statusItem setAttributedTitle:blueTitle]; 
//    [blueTitle release];    
    
//	NSMenu * menu = [[NSMenu alloc] initWithTitle:@""];
//	[menu addItemWithTitle:@"Quit Input Ninja" action:@selector(quit:) keyEquivalent:@""];
//	[statusItem setMenu:menu];

//	[menu release];
    
    




    // LISTENER //
    KeyInterceptor * keys = [KeyInterceptor shared];    
    
    NSMutableArray * applications = [NSMutableArray array];
    [applications addObject:@"com.apple.dt.Xcode"];
    [applications addObject:@"com.macromates.textmate"];
    [applications addObject:@"se.hunch.kod"];    
    [applications addObject:@"com.chocolatapp.Chocolat"];    
    
    self.focus = [[FocusObserver new] autorelease];
    [self.focus observeApplications:applications delegate:self];    
    
    // change to observer?    
    keys.delegate = self;
    
    
    NSArray * groups = [Parser groupsFromAllLocations];
    
    for (HotKeyGroup * group in groups) {
        group.isMajor = ![group.name isEqualToString:@"insert"];
        [keys add:group];
    }
    
    [keys activateGroupWithName:@"command"];

    [keys listen];         
    
}

- (void)didChangeToGroup:(HotKeyGroup *)group {
    [self.statusItem setTitle:group.name]; // this works pretty well!
    
    if (group.isMajor)
        [self.modeWindow setAlphaValue:1.0];
        
    else
        [self.modeWindow setAlphaValue:0.0];
}

- (void)didDeactivate {
    [self.statusItem setTitle:@"Inactive"];
    [self.modeWindow setAlphaValue:0.0];
}

- (void)didSwitchToActive {
    [self didChangeToGroup:[KeyInterceptor shared].activeGroup];
    [[KeyInterceptor shared] enable];    
}

- (void)didSwitchToInactive {
    [self didDeactivate];
    [[KeyInterceptor shared] disable];
}

- (void)dealloc {
	[[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
	[statusItem release];
    [modeWindow release];
    [focus release];
	[super dealloc];
}

@end
