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
// test: disable entire thing?
// repeats
// application-filtering
// visual indicator
// o, O
// u

// NEXT BIG STEP
// handling of sequences
// simple input format

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

-(id)init {
	if (self = [super init]) {
		keys = [KeyInterceptor new];
		commandMode = [HotKeyGroup new];	
		insertMode = [HotKeyGroup new];
		[keys add:commandMode];
		[keys add:insertMode];
		
		commandMode.enabled = YES;
		insertMode.enabled = NO;

		
		[commandMode add:@"J" block:^ {
			[keys send:KeyDown];
			return NO;
		}];
		
		[commandMode add:@"K" block:^{
			[keys send:KeyUp];
			return NO;		
		}];
		
		[commandMode add:@"H" block:^{
			[keys send:KeyLeft];
			return NO;					
		}];
		
		[commandMode add:@"L" block:^{
			[keys send:KeyRight];
			return NO;					
		}];	
		
		
		
		
		[commandMode add:@"I" block:^{
			commandMode.enabled = NO;
			insertMode.enabled = YES;
			return NO;
		}];	
		
		
		
		
		
		[commandMode add:@"D" block:^{
			return NO;
		}];	
		
		[commandMode add:@"D D" block:^{
			
			[keys send:KeyLeft cmd:YES alt:NO ctl:NO shift:NO];
			[keys send:KeyDown cmd:NO alt:NO ctl:NO shift:YES];
			[keys send:KeyX cmd:YES alt:NO ctl:NO shift:NO];	
			
			[keys resetHistory];
			return NO;
		}];
		
		
		
		
		
		
		
		
		// INSERT MODE
		
		[insertMode add:@"Esc" block:^{
			insertMode.enabled = NO;
			commandMode.enabled = YES;
			return NO;
		}];
		
		[insertMode add:@"cC" block:^{
			insertMode.enabled = NO;
			commandMode.enabled = YES;
			return NO;
		}];
		
		
		
		
		
		
	}
	return self;
}

-(void)listen {
	[keys listen];
}
	 
- (void)dealloc {
	[commandMode release];
	[insertMode release];
	[super dealloc];
}

@end
