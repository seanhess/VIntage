//
//  VIListener.m
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VIListener.h"
#import "KeyInterceptor.h"
#import "HotKeyGroup.h"
#import "HotKey.h"

// MAKE IT USABLE
// √ test: disable entire thing?
// √ Switch to event taps
// √ repeats
// application-filtering
// √ visual indicator
// √ o, O
// √ u
// '.' command

// NEXT BIG STEP
// √ handling of sequences
// √ simple input format

// NEXT 
// √ broadcasts
// √ dd
// better handling of lastAction (need a queue or something... easy way to match sequences)
// '/'

// LATER
// Different things in different applications
// GUI
// Then take over the world!!!
// Simple parsing format?? (Hard to do vi mode that way) but you could set simple states and switches

@implementation VIListener
@synthesize statusItem;

-(id)init {
	if (self = [super init]) {
		keys = [KeyInterceptor new];
		commandMode = [HotKeyGroup new];	
		insertMode = [HotKeyGroup new];
		[keys add:commandMode];
		[keys add:insertMode];
		
		__block BOOL performingFind = NO;
		
		[self useCommand];
				
		[commandMode add:@"J" block:^ {
			[keys sendKey:KeyDown];
		}];
		
		[commandMode add:@"K" block:^{
			[keys sendKey:KeyUp];
		}];
		
		[commandMode add:@"H" block:^{
			[keys sendKey:KeyLeft];		
		}];
		
		[commandMode add:@"L" block:^{
			[keys sendKey:KeyRight];	
		}];	
		
		
		
		
		[commandMode add:@"I" block:^{
			[self useInsert];
		}];	
		
		[commandMode add:@"A" block:^{
			[self useInsert];
		}];			
		
		[commandMode add:@"sA" block:^{
			[keys sendString:@"mRight"];
			[self useInsert];
		}];				
		
		[commandMode add:@"sI" block:^{
			[keys sendString:@"mLeft"];
			[self useInsert];
		}];							
		
		
		[commandMode add:@"D" block:^{
			// will block it
		}];	
		
		[commandMode add:@"D D" block:^{
			[keys sendString:@"mLeft sDown mX"];	
			[keys resetHistory];
		}];
		
		[commandMode add:@"O" block:^{
			[keys sendString:@"mRight Enter"];
			[self useInsert];
		}];
		
		[commandMode add:@"sO" block:^{
			[keys sendString:@"Up mRight Enter"];
			[self useInsert];
		}];
		
		[commandMode add:@"U" block:^{
			[keys sendString:@"mZ"];			
		}];		
		
		[commandMode add:@"P" block:^{
			[keys sendString:@"mV"];			
		}];				
		
		
		[commandMode add:@"/" block:^{
			[keys sendString:@"mF"];
			[self useInsert];
			performingFind = YES;
		}];						

		[commandMode add:@"N" block:^{
			[keys sendString:@"mG"];			
		}];				
		
		[commandMode add:@"sN" block:^{
			[keys sendString:@"smG"];			
		}];		
		
		
		
		[commandMode add:@"X" block:^{
			[keys sendString:@"Right Delete"];
		}];		
		
		[commandMode add:@"Escape" block:^{}];
		[commandMode add:@"Enter" block:^{}];		
		[commandMode add:@"Tab" block:^{}];				
		

		// INSERT MODE
		
		[insertMode add:@"Escape" block:^{
			if (performingFind) {
				[keys sendKey:KeyEscape];
			}

			[self useCommand];
			performingFind = NO;
		}];
		
		[insertMode add:@"cC" block:^{
			[self useCommand];
		}];
		
		[insertMode add:@"Tab" block:^{
			[keys sendKey:KeyTab];							
			
			if (performingFind) {
				[self useCommand];
			}

			performingFind = NO;			
			
		}];	
		
		[insertMode add:@"Enter" block:^{
			[keys sendKey:KeyEnter];			
			
			if (performingFind) {
				[self useCommand];
			}
																								
			performingFind = NO;
		}];						
		
		
		
	}
	return self;
}

-(void)useCommand {
	commandMode.enabled = YES;
	insertMode.enabled = NO;
	[statusItem setTitle:@"Command"];
}

-(void)useInsert {
	commandMode.enabled = NO;
	insertMode.enabled = YES;	
	[statusItem setTitle:@""];		
}

// This won't work, because we need to keep track of inserts & whatnot
// I REALLY need to be tracking the last block called

//-(void)send:(NSString*)command {
//	lastSend = command;
//	[keys sendString:command];
//}

-(void)listen {
	[keys listen];	
	[statusItem setTitle:@"Command"];	
}
	 
- (void)dealloc {
	[commandMode release];
	[insertMode release];
	[statusItem release];
	[super dealloc];
}

@end
