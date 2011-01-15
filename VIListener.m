//
//  VIListener.m
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VIListener.h"
#import "KeyInterceptor.h"

// NEXT 
// √ broadcasts
// repeated presses
// dd
// only work in some applications

@implementation VIListener

-(void)listen {
	keys = [KeyInterceptor new];
	[keys listen];
	
	commandMode = true;
	insertMode = false;
	
	__block char lastAction = ' ';
	
	[keys onPress:KeyCodeJ block:^{
		if (commandMode) [keys broadcast:KeyCodeArrowDown];	
		else [keys broadcast:KeyCodeJ];
	}];
	
	[keys onPress:KeyCodeK block:^{
		if (commandMode) [keys broadcast:KeyCodeArrowUp];		
		else [keys broadcast:KeyCodeK];		
	}];
	
	[keys onPress:KeyCodeH block:^{
		if (commandMode) [keys broadcast:KeyCodeArrowLeft];		
		else [keys broadcast:KeyCodeH];		
	}];
	
	[keys onPress:KeyCodeL block:^{
		if (commandMode) [keys broadcast:KeyCodeArrowRight];		
		else [keys broadcast:KeyCodeL];		
	}];	
	
	[keys onPress:KeyCodeEscape block:^{
		if (insertMode) {
			commandMode = true;
			insertMode = false;
		}
		else [keys broadcast:KeyCodeEscape];
	}];
	
	[keys onPress:KeyCodeC modifiers:controlKey block:^{
		if (insertMode) {
			commandMode = true;
			insertMode = false;
		}
		else [keys broadcast:KeyCodeC modifiers:controlKey];
	}];	
	
	[keys onPress:KeyCodeI block:^{
		if (commandMode) {
			insertMode = true;
			commandMode = false;
		}
		else [keys broadcast:KeyCodeI];
	}];
	
	[keys onPress:KeyCodeI block:^{
		if (commandMode) {
			insertMode = true;
			commandMode = false;
		}
		else [keys broadcast:KeyCodeI];
	}];
	
	[keys onPress:KeyCodeD block:^{
		if (commandMode) {
			// this should be a part of keys. I just ask it what the last one was?
			if (lastAction == 'd') {
				[keys broadcast:KeyCodeArrowLeft modifiers:kCGEventFlagMaskCommand];
				[keys broadcast:KeyCodeArrowDown modifiers:kCGEventFlagMaskShift];				
				[keys broadcast:KeyCodeX modifiers:kCGEventFlagMaskCommand];
			}
			
			else {
				lastAction = 'd';
			}
			
		}
		else [keys broadcast:KeyCodeD];
	}];
}
	 
- (void)dealloc {
	[keys release];
	[super dealloc];
}

@end
