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

#import "Parser.h"

@implementation VIListener

-(id)init {
	if (self = [super init]) {
    
        NSArray * groups = [Parser parseFile:[Parser bundleFilePath:@"defaults"]];
        
        NSLog(@"GORUPS %@", groups);
		
		commandMode = [groups objectAtIndex:0];
		insertMode = [groups objectAtIndex:2];
		visualMode = [groups objectAtIndex:1];
		findMode = [groups objectAtIndex:3];
        
        // isMajor!
        commandMode.isMajor = YES;
        visualMode.isMajor = YES;        
        findMode.isMajor = YES;        
        insertMode.isMajor = NO;
		
		KeyInterceptor * keys = [KeyInterceptor shared];

		[keys add:commandMode];
		[keys add:insertMode];
		[keys add:visualMode];
		[keys add:findMode];
		
		[commandMode add:@"I" block:^{
			if (!([keys.last2Id isEqualToString:@"C I"] || [keys.last2Id isEqualToString:@"D I"])) {
				[self useInsert];
			}
		}];
		
		[commandMode add:@"O" block:^{		
			if (!([keys.last2Id isEqualToString:@"C O"] || [keys.last2Id isEqualToString:@"D O"])) {
				[keys sendString:@"mRight Enter"];				
				[self useInsert];
			}			
		}];
        
		[visualMode inherit:commandMode]; 	 
		[findMode inherit:insertMode];               

		
//	√	e - end of word
//		E - end of whitespace-delimited word
//	√	b - beginning of a word
//		B - beginning of whitespace word
//	√	0	To the beginning of a line.
//		^	To the first non-whitespace character of a line.
//	√	$	To the end of a line.
//		H	To the first line of the screen.
//		M	To the middle line of the screen.
//		L	To the the last line of the screen.
		
		
//	√	i	Insert before cursor.
//	√	I	Insert to the start of the current line.
//	√	a	Append after cursor.
//	√	A	Append to the end of the current line.
//	√	o	Open a new line below and insert.
//	√	O	Open a new line above and insert.
//		C	Change the rest of the current line.
//		r	Overwrite one character. After overwriting the single character, go back to command mode.
//		R	Enter insert mode but replace characters rather than inserting.
//	√	The ESC key	Exit insert/overwrite mode and go back to command mode.
		
//	√	x	Delete characters under the cursor.
//	√	X	Delete characters before the cursor.
//	√	dd or :d	Delete the current line.
		
//	√	v	Start highlighting characters. Use the normal movement keys and commands to select text for highlighting.
//	~	V	Start highlighting lines.
//	√	ESC Exit visual mode and return to command mode.
		
		
//		~	Change the case of characters. This works both in visual and command mode. In visual mode, change the case of highlighted characters. In command mode, change the case of the character uder cursor.
//	√	> (V)	Shift right (indent).
//	√	< (V)	Shift left (de-indent).
//	√	c (V)	Change the highlighted text.
//	√	y (V)	Yank the highlighted text. In Windows terms, "copy the selected text to clipboard."
//	√	d (V)	Delete the highlighted text. In Windows terms, "cut the selected text to clipboard."
//	√	yy or :y or Y	Yank the current line. You don't need to highlight it first.
//	√	dd or :d	Delete the current line. Again, you don't need to highlight it first.
//	√	p	Put the text you yanked or deleted. In Windows terms, "paste the contents of the clipboard". Put characters after the cursor. Put lines below the current line.
//	~	P	Put characters before the cursor. Put lines above the current line.		
		
		
//	√	u	Undo the last action.
//	X	U	Undo all the latest changes that were made to the current line. -
//	√	Ctrl + r	Redo.		
		
		// Proposed: -Visual +Command, etc. Lets you turn them on and off. 

 
        


		
                        

		
	}
	return self;
}

-(void)useFind {
    [[KeyInterceptor shared] activateGroup:findMode];
}

-(void)useVisual {
    [[KeyInterceptor shared] activateGroup:visualMode];
}
		
-(void)useCommand {
    [[KeyInterceptor shared] activateGroup:commandMode];
}

-(void)useInsert {
    [[KeyInterceptor shared] activateGroup:insertMode];
}


// This won't work, because we need to keep track of inserts & whatnot
// I REALLY need to be tracking the last block called

//-(void)send:(NSString*)command {
//	lastSend = command;
//	[keys sendString:command];
//}

-(void)listen {
	[[KeyInterceptor shared] listen];	
//	[self setupAppFrontSwitchedHandler];
	[self useInsert];
}
	 
- (void)dealloc {
	[commandMode release];
	[insertMode release];
	[visualMode release];
	[findMode release];
	[super dealloc];
}

@end
