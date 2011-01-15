//
//  HotKey.h
//  InputNinja
//
//  Created by Sean Hess on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <objc/runtime.h>
#import "KeyInterceptor.h"

@interface HotKey : NSObject {
	EventHotKeyID keyId;
	EventHotKeyRef keyRef;
	
	NSUInteger modifiers;
	UInt32 code;
	void(^block)(void);
	
	NSString * dictionaryKey;
}

-(id)initWithCode:(UInt32)code modifiers:(NSUInteger)modifiers block:(void(^)(void))block;
+(HotKey*)keyWithCode:(UInt32)code modifiers:(NSUInteger)modifiers block:(void(^)(void))block;

@property (readonly) NSUInteger modifiers;
@property (readonly) UInt32 code;
@property (readonly) void(^block)(void);
@property (readonly) EventHotKeyRef * keyRef;
@property (readonly) EventHotKeyID keyId;

@property (readonly) NSString * dictionaryKey;

+(NSString*)dictionaryKeyFromKeyId:(EventHotKeyID)keyId;

@end
