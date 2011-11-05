//
//  HotKeySet.m
//  InputNinja
//
//  Created by Sean Hess on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotKeyGroup.h"
#import "Command.h"
#import "HotKey.h"
#import "KeyInterceptor.h"

@implementation HotKeyGroup
@synthesize enabled, keys, name;
@synthesize isMajor;

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
//-(void)inherit:(HotKeyGroup*)parent {
//	self.keys = [NSMutableDictionary dictionaryWithDictionary:parent.keys];
//}

-(void)add:(HotKey*)key {
    // Ok, the only thing I have to do is add "C O" for "C O W" and set it to continue
    NSString * keyId = key.keyId;
    NSArray * components = [keyId componentsSeparatedByString:@" "];
    
    for (int i = 0; i < components.count-1; i++) { // don't include the last one
        NSArray * subComponents = [components subarrayWithRange:NSMakeRange(0, i+1)];
        NSString * partialId = [subComponents componentsJoinedByString:@" "];
        [keys setObject:[HotKey continueKey] forKey:partialId];
    }
    
	[keys setObject:key forKey:[key keyId]];
}

-(void)remove:(HotKey*)key {
	[keys removeObjectForKey:[key keyId]];
}

-(HotKey*)keyForPresses:(NSArray*)buffer {
    NSString * keyId = [buffer componentsJoinedByString:@" "];
    HotKey * key = [keys objectForKey:keyId];
    return key;
}

-(BOOL)onKeyDown:(Command*)info keys:(KeyInterceptor*)ki {
		
//	NSLog(@"CHECKING (%@) (%@) (%@)", ki.last3Id, ki.last2Id, ki.lastId);
	
	return NO;
}

-(void)dealloc {
	[keys release];
	[super dealloc];
}

@end
