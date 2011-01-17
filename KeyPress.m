//
//  KeyPress.m
//  InputNinja
//
//  Created by Sean Hess on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KeyPress.h"


@implementation KeyPress
@synthesize code, flags, event;
@synthesize cmdDown, altDown, shiftDown, ctlDown;

-(NSString*)keyId {
	return [KeyInterceptor keyId:code cmdDown:cmdDown altDown:altDown ctlDown:ctlDown shiftDown:shiftDown];
}

-(void)stopEvent {
	self.event = CGEventCreate(NULL);
}

-(void)dealloc {
//	CFRelease(self.event);
	[super dealloc];
}

@end
