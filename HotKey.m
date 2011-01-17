//
//  HotKey.m
//  InputNinja
//
//  Created by Sean Hess on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotKey.h"

@implementation HotKey
@synthesize keyId, block;

-(id)initWithKeyId:(NSString*)k block:(BOOL(^)(void))b {
	if (self = [super init]) {
		self.keyId = k;
		self.block = b;
	}
	return self;
}

+(HotKey*)keyWithId:(NSString*)keyId block:(BOOL(^)(void))block {
	return [[[HotKey alloc] initWithKeyId:keyId block:block] autorelease];
}

-(void)dealloc {
	[keyId release];
	[block release];
	[super dealloc];
}

@end

