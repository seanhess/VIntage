//
//  KeyPress.m
//  InputNinja
//
//  Created by Sean Hess on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KeyPress.h"


@implementation KeyPress
@synthesize code, event;
@synthesize cmd, alt, shift, ctl;

-(NSString*)keyId {
	return [[KeyInterceptor shared] keyId:code cmd:cmd alt:alt ctl:ctl shift:shift];
}

-(void)stopEvent {
	self.event = CGEventCreate(NULL);
}

-(NSString*)description {
	return [self keyId];
}

-(void)dealloc {
//	CFRelease(self.event);
	[super dealloc];
}

@end
