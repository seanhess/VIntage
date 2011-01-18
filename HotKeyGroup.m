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
#import "KeyInterceptor.h"

@implementation HotKeyGroup
@synthesize enabled, keys, name, applications;

-(id)initWithName:(NSString*)n {
	if (self = [super init]) {
		enabled = YES;
		self.keys = [NSMutableDictionary dictionary];
		self.name = n;
		ki = [KeyInterceptor shared]; // don't retain
	}
	return self;	
}

// copy the parent's keys. 
// Make sure you call this after its been configured
-(void)inherit:(HotKeyGroup*)parent {
	self.keys = [NSMutableDictionary dictionaryWithDictionary:parent.keys];
}

-(HotKey*)stop:(NSString*)keyId {
	HotKey * key = [self add:keyId block:^{}];
	key.resetHistory = NO;
	return key;
}

-(HotKey*)add:(NSString*)keyId send:(NSString*)command {
	return [self add:keyId block:^{
		[ki sendString:command];
	}];
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
	
//	NSLog(@"WOOT %@", [[[NSWorkspace sharedWorkspace] activeApplication] objectForKey:@"NSApplicationBundleIdentifier"]);
	
	if (applications) {
		NSString * activeAppId = [[[NSWorkspace sharedWorkspace] activeApplication] objectForKey:@"NSApplicationBundleIdentifier"];
		BOOL pass = NO;
		for (NSString * bundleId in applications) {
			if ([activeAppId isEqualToString:bundleId])
				pass = YES;
		}
		
		if (!pass) return;
	}
	
	HotKey * key;
	
	if (presses.count > 2 && (key = [keys objectForKey:[ki keyIds:3]])) {
		key.block();
	}	
	
	else if (presses.count > 1 && (key = [keys objectForKey:[ki keyIds:2]])) {	
		key.block();
	}	
	
	else if (presses.count > 0 && (key = [keys objectForKey:[ki keyIds:1]])) {
		key.block();	
	}
	
	if (key) {
		if (key.resetHistory) [ki resetHistory];
		[info stopEvent];
	}
}

-(void)dealloc {
	[applications release];
	[keys release];
	[super dealloc];
}

@end
