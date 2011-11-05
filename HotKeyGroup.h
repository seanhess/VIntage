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
	NSString * name;
	
	NSMutableArray * applications;
}

-(void)inherit:(HotKeyGroup*)parent;

@property (nonatomic) BOOL enabled;
@property (nonatomic, retain) NSMutableDictionary * keys;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSMutableArray * applications;

-(void)add:(HotKey*)hotKey;
-(void)remove:(HotKey*)hotKey;
-(HotKey*)add:(NSString*)keyId block:(void(^)(void))block;
-(HotKey*)add:(NSString*)keyId send:(NSString*)command;
-(HotKey*)stop:(NSString*)keyId;

// presses already contains info
-(BOOL)onKeyDown:(Command*)info keys:(KeyInterceptor*)keys;

-(id)initWithName:(NSString*)n;

@end
