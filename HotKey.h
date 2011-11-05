//
//  HotKey.h
//  InputNinja
//
//  Created by Sean Hess on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	HotKeyNormal = 1, 
    HotKeyContinue = 2
} HotKeyType;

@interface HotKey : NSObject {
	NSString * keyId;
    NSString * commands;
    HotKeyType type;
}

-(id)initWithKeyId:(NSString*)keyId commands:(NSString*)commands;
+(HotKey*)keyWithId:(NSString*)keyId commands:(NSString*)commands;
+(HotKey*)continueKey;

@property (nonatomic, retain) NSString * keyId;
@property (nonatomic, retain) NSString * commands;
@property (nonatomic, assign) HotKeyType type;

@end
