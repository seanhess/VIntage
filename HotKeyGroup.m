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
	return key;
}

-(HotKey*)add:(NSString*)keyId send:(NSString*)command {
	return [self add:keyId block:^{
		[[KeyInterceptor shared] sendString:command];
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

-(BOOL)onKeyDown:(KeyPress*)info keys:(KeyInterceptor*)ki {
	
//	NSLog(@"WOOT %@", [[[NSWorkspace sharedWorkspace] activeApplication] objectForKey:@"NSApplicationBundleIdentifier"]);
	
	// Check for application matchs
	if (applications) {
		NSString * activeAppId = [[[NSWorkspace sharedWorkspace] activeApplication] objectForKey:@"NSApplicationBundleIdentifier"];
		BOOL pass = NO;
		for (NSString * bundleId in applications) {
			if ([activeAppId isEqualToString:bundleId])
				pass = YES;
		}
		
		if (!pass) return NO;
	}
	
	
	// Now check for key matches
	
//	NSLog(@"CHECKING (%@) (%@) (%@)", ki.last3Id, ki.last2Id, ki.lastId);
	
	for (int i = 3; i > 0; i--) {
		HotKey * key = [keys objectForKey:[ki lastId:i]];
		if (key) {
//			NSLog(@"Found Key %@", key.keyId);
			key.block();		
			[info stopEvent];
			return YES;
		}
	}
	
	return NO;
}

-(void)dealloc {
	[applications release];
	[keys release];
	[super dealloc];
}

@end
