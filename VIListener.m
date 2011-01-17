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

-(void)listen {
	keys = [KeyInterceptor new];
	commandMode = [HotKeyGroup new];	
	insertMode = [HotKeyGroup new];
	
	[keys listen];
	[keys add:commandMode];		
	
	commandMode.enabled = YES;
	insertMode.enabled = NO;
	
	// Block D
	[commandMode add:[HotKey keyWithId:@"D" block:^{
		return NO;
	}]];	
	
	[commandMode add:[HotKey keyWithId:@"D D" block:^{
		NSLog(@"DOUBLE D!");
		[keys resetHistory];
		return NO;
	}]];
	

	
	
	// I shouldn't have to re-broadcast them. 
	// if it's disabled, do that automatically. 
	
//	[keys onPress:KeyJ block:^{
//		[keys broadcast:KeyArrowDown];	
//	}];
//	
//	[commandMode onPress:KeyCodeK block:^{
//		[commandMode broadcast:KeyCodeArrowUp];		
//	}];
//	
//	[commandMode onPress:KeyCodeH block:^{
//		[commandMode broadcast:KeyCodeArrowLeft];		
//	}];
//	
//	[commandMode onPress:KeyCodeL block:^{
//		[commandMode broadcast:KeyCodeArrowRight];	
//	}];	
//	
//	[insertMode onPress:KeyCodeEscape block:^{
//		NSLog(@"Enabling Command Mode");		
//		commandMode.enabled = YES;
//		insertMode.enabled = NO;
//	}];
//	
////	[keys onPress:KeyCodeC modifiers:controlKey block:^{
////		if (insertMode) {
////			commandMode = true;
////			insertMode = false;
////		}
////		else [keys broadcast:KeyCodeC modifiers:kCGEventFlagMaskControl];
////	}];	
//	
//	[commandMode onPress:KeyCodeI block:^{
//		NSLog(@"Enabling Insert Mode");
//		commandMode.enabled = NO;
//		insertMode.enabled = YES;
//	}];
//	
////	[keys onPress:KeyCodeD block:^{
////		if (commandMode) {
////			// this should be a part of keys. I just ask it what the last one was?
////			if (lastAction == 'd') {
////				[keys broadcast:KeyCodeArrowLeft modifiers:kCGEventFlagMaskCommand];
////				[keys broadcast:KeyCodeArrowDown modifiers:kCGEventFlagMaskShift];				
////				[keys broadcast:KeyCodeX modifiers:kCGEventFlagMaskCommand];
////			}
////			
////			else {
////				lastAction = 'd';
////			}
////			
////		}
////		else [keys broadcast:KeyCodeD];
////	}];
}
	 
- (void)dealloc {
	[commandMode release];
	[insertMode release];
	[super dealloc];
}

@end
