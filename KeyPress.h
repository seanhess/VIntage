//
//  KeyPress.h
//  InputNinja
//
//  Created by Sean Hess on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyTypes.h"

@interface KeyPress : NSObject {
	
	// I probably need to "retain" them somehow? Yikes!
	
	KeyCode code;
	CGEventRef event;
	
	NSString * keyId;
	
	BOOL cmd;
	BOOL alt;
	BOOL shift;
	BOOL ctl;
}

@property (nonatomic) KeyCode code;
@property (nonatomic) CGEventRef event;

@property (nonatomic) BOOL cmd;
@property (nonatomic) BOOL alt;
@property (nonatomic) BOOL shift;
@property (nonatomic) BOOL ctl;

-(void)stopEvent;

-(NSString*)keyId;

@end
