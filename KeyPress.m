//
//  KeyPress.m
//  InputNinja
//
//  Created by Sean Hess on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KeyPress.h"
#import "KeyInterceptor.h"

#define CmdChar @"m" // @"⌘"
#define CtlChar @"c" // @"⌃"
#define AltChar @"a" // @"⌥"
#define ShiftChar @"s" // @"⇧"

@implementation KeyPress
@synthesize code, event;
@synthesize cmd, alt, shift, ctl;


+ (NSString*)keyId:(KeyCode)code cmd:(BOOL)cmd alt:(BOOL)alt ctl:(BOOL)ctl shift:(BOOL)shift {
	NSString * string = [[KeyInterceptor shared] stringForCode:code];
	if (cmd) string = [CmdChar stringByAppendingString:string];
	if (shift) string = [ShiftChar stringByAppendingString:string];
	if (alt) string = [AltChar stringByAppendingString:string];
	if (ctl) string = [CtlChar stringByAppendingString:string];
	return string;
}

//- (NSString*)keyId:(KeyCode)code {
//	return [self keyId:code cmd:NO alt:NO ctl:NO shift:NO];
//}

//- (NSString*)keyIds:(NSInteger)num {
//	
//	NSMutableArray * array = [NSMutableArray array];
//	
//	for (int i = (presses.count - num); i < presses.count; i++) {
//		[array addObject:[[presses objectAtIndex:i] keyId]];
//	}
//
//	return [array componentsJoinedByString:@" "];
//}

-(NSString*)keyId {
	if (!keyId) keyId = [[self class] keyId:code cmd:cmd alt:alt ctl:ctl shift:shift];
	return keyId;
}

-(void)stopEvent {
	self.event = CGEventCreate(NULL);//[[KeyInterceptor shared] nullEvent];
}

-(NSString*)description {
	return [self keyId];
}

-(void)dealloc {
//	CFRelease(self.event);
	[super dealloc];
}

@end
