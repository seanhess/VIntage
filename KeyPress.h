//
//  KeyPress.h
//  InputNinja
//
//  Created by Sean Hess on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyInterceptor.h"

@interface KeyPress : NSObject {
	
	// I probably need to "retain" them somehow? Yikes!
	
	KeyCode code;
	KeyFlags flags;
	CGEventRef event;
	
	BOOL cmdDown;
	BOOL altDown;
	BOOL shiftDown;
	BOOL ctlDown;
}

@property (nonatomic) KeyCode code;
@property (nonatomic) KeyFlags flags;
@property (nonatomic) CGEventRef event;

@property (nonatomic) BOOL cmdDown;
@property (nonatomic) BOOL altDown;
@property (nonatomic) BOOL shiftDown;
@property (nonatomic) BOOL ctlDown;

-(void)stopEvent;

-(NSString*)keyId;

@end
