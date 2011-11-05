//
//  KeyPress.h
//  InputNinja
//
//  Created by Sean Hess on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyTypes.h"

@interface Command : NSObject {
	
	// I probably need to "retain" them somehow? Yikes!
	
	KeyCode code;
	CGEventRef event;
	
	NSString * keyId;
	
	BOOL cmd;
	BOOL alt;
	BOOL shift;
	BOOL ctl;
    
    NSString * raw;
}

@property (nonatomic) KeyCode code;
@property (nonatomic) CGEventRef event;

@property (nonatomic) BOOL cmd;
@property (nonatomic) BOOL alt;
@property (nonatomic) BOOL shift;
@property (nonatomic) BOOL ctl;

@property (nonatomic, retain) NSString * raw;

-(void)stopEvent;

-(NSString*)keyId;

@end
