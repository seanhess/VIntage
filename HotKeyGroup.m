//
//  HotKeySet.m
//  InputNinja
//
//  Created by Sean Hess on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotKeyGroup.h"
#import "KeyPress.h"
#import "HotKey.h"

@implementation HotKeyGroup
@synthesize enabled, keys;

-(id)init {
	if (self = [super init]) {
		enabled = YES;
		self.keys = [NSMutableDictionary dictionary];
	}
	return self;
}

-(void)add:(HotKey*)key {
	[keys setObject:key forKey:[key keyId]];
}

-(void)remove:(HotKey*)key {
	[keys removeObjectForKey:[key keyId]];
}

-(HotKey*)add:(NSString*)keyId block:(void(^)(void))block {
	HotKey * key = [HotKey keyWithId:keyId block:block];
	[self add:key];
	return key;
}

-(void)onKeyDown:(KeyPress*)info presses:(NSArray*)presses {
	
	HotKey * key;
	BOOL passEvent = YES;
	
	if ((key = [keys objectForKey:[KeyInterceptor keyIdLastThree:presses]])) {
		key.block();
		passEvent = NO;
	}	
	
	else if ((key = [keys objectForKey:[KeyInterceptor keyIdLastTwo:presses]])) {
		key.block();
		passEvent = NO;		
	}	
	
	else if ((key = [keys objectForKey:info.keyId])) {
		key.block();
		passEvent = NO;		
	}
		
	if (!passEvent) [info stopEvent];
}

-(void)dealloc {
	[keys release];
	[super dealloc];
}

@end
