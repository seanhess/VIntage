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
		
		commandMode = [[HotKeyGroup alloc] initWithName:@"Command"];
		insertMode = [[HotKeyGroup alloc] initWithName:@"Insert"];
		visualMode = [[HotKeyGroup alloc] initWithName:@"Visual"];
		findMode = [[HotKeyGroup alloc] initWithName:@"Find"];
		
		KeyInterceptor * keys = [KeyInterceptor shared];

		[keys add:commandMode];
		[keys add:insertMode];
		[keys add:visualMode];
		[keys add:findMode];

		
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
		
		[commandMode add:@"J" send:@"Down"];     
		[commandMode add:@"K" send:@"Up"];
		[commandMode add:@"H" send:@"Left"];
		[commandMode add:@"L" send:@"Right"];		
		
		[commandMode add:@"E" send:@"aRight"];
		[commandMode add:@"B" send:@"aLeft"];		
		[commandMode add:@"W" send:@"aRight Right"];		
		
		[commandMode add:@"0" send:@"mLeft"];
		[commandMode add:@"$" send:@"mRight"];		
		
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

		[commandMode stop:@"D"];
		
		[commandMode add:@"D D" send:@"mLeft sDown mX"];
		
		[commandMode add:@"O" block:^{				
			[keys sendString:@"mRight Enter"];
			[self useInsert];
		}];

		[commandMode add:@"sO" block:^{
			[keys sendString:@"Up mRight Enter"];
			[self useInsert];
		}];
		
		[commandMode add:@"U" send:@"mZ"];
		[commandMode add:@"cR" send:@"smZ"];		
		[commandMode add:@"P" send:@"mV"];
		[commandMode add:@"sP" send:@"mV"];		// need to fix		
		
		
//		[commandMode add:@"R" send:@""]; // don't know how to get back to command mode when finished

		[commandMode add:@"sC" block:^{
			[keys sendString:@"smRight Delete"];
			[self useInsert];
		}];
		
		[commandMode add:@"C C" block:^{
			[keys sendString:@"smRight Delete"];
			[self useInsert];
		}];
		
		
		[commandMode add:@"C E" block:^{
			[keys sendString:@"saRight Delete"];
			[self useInsert];
		}];	
		
		[commandMode add:@"C W" block:^{
			[keys sendString:@"saRight Delete"];
			[self useInsert];
		}];			
		
		[commandMode add:@"C $" block:^{
			[keys sendString:@"smRight Delete"];
			[self useInsert];
		}];			
		
		[commandMode add:@"C B" block:^{
			[keys sendString:@"amLeft Delete"];
			[self useInsert];
		}];				
		
		[commandMode add:@"C I W" block:^{
			[keys sendString:@"aRight asLeft Delete"];
			[self useInsert];
		}];						
		
		
		// FIND
		
		[commandMode add:@"/" block:^{
			[keys sendString:@"mF"];
			[self useFind];
		}];			
		
		// not exactly right, but it's better than nothing
		// could store state, and reverse them. 
		
		[commandMode add:@"s/" block:^{
			[keys sendString:@"mF"];
			[self useFind];
		}];					

		[commandMode add:@"N" send:@"mG"];
		[commandMode add:@"sN" send:@"smG"];
		[commandMode add:@"sN" send:@"smG"];		
		
		[commandMode add:@"X" send:@"cD"];
		
		// Need these to dismiss dialogs, and interact with the system
		// [commandMode add:@"Escape" block:^{
		// [commandMode add:@"Enter" block:^{}];		
		// [commandMode add:@"Tab" block:^{}];			
		[commandMode stop:@"Delete"];		
		
		[commandMode stop:@"G"];				
		[commandMode add:@"G G" send:@"mUp"];
		[commandMode add:@"sG" send:@"mDown"];
		
		[commandMode stop:@"Y"];
		[commandMode add:@"Y Y" send:@"mLeft sDown mC"];
		
		[commandMode add:@"V" block:^{
			[self useVisual];
		}];		
		
		[commandMode add:@"sV" block:^{
			[keys sendString:@"mLeft sDown"];
			[self useVisual];
		}];
		
		
		
		// DEAD KEYS
		[commandMode stop:@"Q"];
		[commandMode stop:@"R"];
		[commandMode stop:@"T"];
		[commandMode stop:@"S"];
		[commandMode stop:@"F"];		
		
		[commandMode stop:@"G"];				
		[commandMode stop:@";"];						
		[commandMode stop:@"'"];								
		
		[commandMode stop:@"Z"];
		[commandMode stop:@"C"];		
		[commandMode stop:@"M"];				
		[commandMode stop:@","];						
		[commandMode stop:@"."];								
		
		
		
		
		
		
		// VISUAL MODE 
		[visualMode inherit:commandMode]; 	 // you have to do this before adding your own, and after adding theirs	
		[visualMode add:@"J" send:@"sDown"];
		[visualMode add:@"K" send:@"sUp"];
		[visualMode add:@"H" send:@"sLeft"];
		[visualMode add:@"L" send:@"sRight"];		
		
		[visualMode stop:@"I"];
		[visualMode stop:@"A"];
		[visualMode stop:@"sA"];
		[visualMode stop:@"sI"];	
		
		[visualMode stop:@"D D"];
		[visualMode stop:@"Y Y"];		
		[visualMode stop:@"O"];
		[visualMode stop:@"sO"];
		
		[visualMode stop:@"V"];
		[visualMode stop:@"sV"];
				
		[visualMode add:@"Escape" block:^{
			[keys sendString:@"Left Right"]; // to deselect
			[self useCommand];
		}];		
		
		[visualMode add:@"cC" block:^{
			[keys sendString:@"Left Right"]; // to deselect
			[self useCommand];
		}];		
		
		[visualMode add:@"Y" block:^{
			[keys sendString:@"mC"];
			[keys sendString:@"Left Right"]; // to deselect			
			[self useCommand];
		}];

		[visualMode add:@"X" block:^{
			[keys sendString:@"mX"];
			[self useCommand];
		}];
		
		[visualMode add:@"D" block:^{
			[keys sendString:@"mX"];
			[self useCommand];
		}];		

		[visualMode add:@"s," send:@"m["];	
		[visualMode add:@"s." send:@"m]"];	
		
		[visualMode add:@"C" block:^{
			[keys sendString:@"mX"];
			[self useInsert];
		}];				
		

		
		
		
		// INSERT MODE
		
		[insertMode add:@"Escape" block:^{
			[self useCommand];
		}];
		
		[insertMode add:@"cC" block:^{
			[self useCommand];
		}];
				
		
		
		
		
		
		// FIND MODE 
		[findMode inherit:insertMode];
		
		[findMode add:@"Escape" block:^{
			[keys sendString:@"Escape"];
			[self useCommand];			
		}];
		
		[findMode add:@"Tab" block:^{
			[keys sendString:@"Tab"];			
			[self useCommand];
		}];
		
		[findMode add:@"Enter" block:^{
			[keys sendString:@"Enter"];			
			[self useCommand];			
		}];		
		
		
		

		
		
		
	}
	return self;
}

-(void)useFind {
	commandMode.enabled = NO;
	insertMode.enabled = NO;
	visualMode.enabled = NO;
	findMode.enabled = YES;
	[statusItem setTitle:@"Command"];	
}

-(void)useVisual {
	commandMode.enabled = NO;
	insertMode.enabled = NO;
	visualMode.enabled = YES;
	findMode.enabled = NO;
	[statusItem setTitle:@"Visual"];	
}
		
-(void)useCommand {
	commandMode.enabled = YES;
	insertMode.enabled = NO;
	visualMode.enabled = NO;
	findMode.enabled = NO;
	[statusItem setTitle:@"Command"];
}

-(void)useInsert {
	commandMode.enabled = NO;
	insertMode.enabled = YES;	
	visualMode.enabled = NO;
	findMode.enabled = NO;
	[statusItem setTitle:@"Insert"];
}

// This won't work, because we need to keep track of inserts & whatnot
// I REALLY need to be tracking the last block called

//-(void)send:(NSString*)command {
//	lastSend = command;
//	[keys sendString:command];
//}

-(void)listen {
	[[KeyInterceptor shared] listen];	
	[self useCommand];
}
	 
- (void)dealloc {
	[commandMode release];
	[insertMode release];
	[visualMode release];
	[findMode release];
	[statusItem release];
	[super dealloc];
}

@end
