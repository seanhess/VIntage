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
		
		commandMode = [[Parser parseFile:[Parser bundleFilePath:@"example"]] objectAtIndex:0];
		insertMode = [[HotKeyGroup alloc] initWithName:@"Insert"];
		visualMode = [[HotKeyGroup alloc] initWithName:@"Visual"];
		findMode = [[HotKeyGroup alloc] initWithName:@"Find"];
        
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
        
        
        

		
		// FIND

		
		// not exactly right, but it's better than nothing
		// could store state, and reverse them. 


		
		// Need these to dismiss dialogs, and interact with the system
        
//		[commandMode add:@"Escape" block:^{
//            [self use
//        }];
		// [commandMode add:@"Enter" block:^{}];		
		// [commandMode add:@"Tab" block:^{}];										
		
		
		// VISUAL MODE 
		[visualMode inherit:commandMode]; 	 // you have to do this before adding your own, and after adding theirs	
		[visualMode add:@"J" send:@"sDown"];
		[visualMode add:@"K" send:@"sUp"];
		[visualMode add:@"H" send:@"sLeft"];
		[visualMode add:@"L" send:@"sRight"];	
		
		[visualMode add:@"E" send:@"saRight"];
		[visualMode add:@"B" send:@"saLeft"];		
		[visualMode add:@"W" send:@"saRight sRight"];		
		
		[visualMode add:@"0" send:@"smLeft"];
		[visualMode add:@"s4" send:@"smRight"];	
		
		[visualMode stop:@"I"];
//		[visualMode stop:@"A"];
//		[visualMode stop:@"sA"];
		[visualMode stop:@"sI"];	
		
		[visualMode stop:@"D D"];
		[visualMode stop:@"Y Y"];		
		[visualMode stop:@"O"];
		[visualMode stop:@"sO"];
		
		[visualMode stop:@"V"];
		[visualMode stop:@"sV"];
				
		[visualMode add:@"Escape" block:^{
			[keys sendString:@"Up Down"]; // to deselect
			[self useCommand];
		}];		
		
		[visualMode add:@"cC" block:^{
			[keys sendString:@"Up Down"]; // to deselect
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

		[insertMode add:@"c[" block:^{
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
		
		
		
		// Then, somehow, I need to make it do different things in textmate/xcode
		// For example, in textmate I need to do 
		
		// Can I have more than one responder using a key command at once?
		// No. So, it depends on the priority. Add them in order :)
		
		// The one that matches first does the job. 
		
		// how do I make a text-mate only visual mode? 
		// Yikes... 
		// Besides, I should use text-mates' built in stuff. 
		
		// 

		
		
		
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

//- (void) appFrontSwitched {
////    NSLog(@"%@", [[NSWorkspace sharedWorkspace] activeApplication]);
//	// USE THIS TO turn the whole thing on/off
//}
//
//static OSStatus AppFrontSwitchedHandler(EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData)
//{
//    [(id)inUserData appFrontSwitched];
//    return 0;
//}
//
//
//- (void)setupAppFrontSwitchedHandler
//{
//    EventTypeSpec spec = { kEventClassApplication,  kEventAppFrontSwitched };
//    OSStatus err = InstallApplicationEventHandler(NewEventHandlerUPP(AppFrontSwitchedHandler), 1, &spec, (void*)self, NULL);
//	
//    if (err)
//        NSLog(@"Could not install event handler");
//}




// This won't work, because we need to keep track of inserts & whatnot
// I REALLY need to be tracking the last block called

//-(void)send:(NSString*)command {
//	lastSend = command;
//	[keys sendString:command];
//}

-(void)listen {
	[[KeyInterceptor shared] listen];	
//	[self setupAppFrontSwitchedHandler];
	[self useCommand];
}
	 
- (void)dealloc {
	[commandMode release];
	[insertMode release];
	[visualMode release];
	[findMode release];
	[super dealloc];
}

@end
