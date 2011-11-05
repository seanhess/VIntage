//
//  HotKeySet.h
//  InputNinja
//
//  Created by Sean Hess on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyTypes.h"

@class Command, HotKey, KeyInterceptor;
@interface HotKeyGroup : NSObject {
	BOOL enabled;
	NSMutableDictionary * keys;
    NSMutableArray * rawKeys;
	NSString * name;
	
    BOOL isMajor;
}

@property (nonatomic) BOOL isMajor;
@property (nonatomic) BOOL enabled;
@property (nonatomic, retain) NSMutableDictionary * keys;
@property (nonatomic, retain) NSMutableArray * rawKeys;
@property (nonatomic, retain) NSString * name;

-(void)add:(HotKey*)hotKey;
-(void)remove:(HotKey*)hotKey;
-(void)overrideWith:(HotKeyGroup*)group;

-(HotKey*)keyForPresses:(NSArray*)buffer;

-(id)initWithName:(NSString*)n;

@end
