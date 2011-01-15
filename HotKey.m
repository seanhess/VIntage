//
//  HotKey.m
//  InputNinja
//
//  Created by Sean Hess on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotKey.h"

static UInt32 nextHotKeyId = 1;

@implementation HotKey
@synthesize modifiers, code, block, keyId;

+(HotKey*)keyWithCode:(KeyCode)code modifiers:(NSUInteger)modifiers block:(void(^)(void))block {
	return [[[HotKey alloc] initWithCode:code modifiers:modifiers block:block] autorelease]; 
}

-(id)initWithCode:(KeyCode)c modifiers:(NSUInteger)m block:(void(^)(void))b {
	if (self = [super init]) {		
		code = c;
		modifiers = m;
		block = [b copy];
		
		keyId.signature = 'htk1';
		keyId.id = nextHotKeyId++;		
		
		dictionaryKey = [[HotKey dictionaryKeyFromKeyId:keyId] retain]; 
	}
	return self;	
}

-(EventHotKeyRef*)keyRef {
	return &keyRef;
}

-(NSString*)dictionaryKey {
	return dictionaryKey;
}

+(NSString*)dictionaryKeyFromKeyId:(EventHotKeyID)keyId {
	return [NSString stringWithFormat:@"%i", keyId.id];
}

-(void)dealloc {
	[dictionaryKey release];
	[block release];
	[super dealloc];
}

@end

