//
//  HotKey.m
//  InputNinja
//
//  Created by Sean Hess on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotKey.h"

@implementation HotKey
@synthesize keyId, commands, type;

-(id)initWithKeyId:(NSString*)k commands:(NSString *)c {
	if (self = [super init]) {
		self.keyId = k;
		self.commands = c;
        self.type = HotKeyNormal;
	}
	return self;
}

+(HotKey*)keyWithId:(NSString*)keyId commands:(NSString *)commands {
	return [[[HotKey alloc] initWithKeyId:keyId commands:commands] autorelease];
}

+(HotKey*)continueKey {
    static HotKey * key = nil;
    
    if (!key) {
        key = [HotKey new];
        key.type = HotKeyContinue;        
    }
    
    return key;
}

-(void)dealloc {
	[keyId release];
	[commands release];
	[super dealloc];
}

@end

