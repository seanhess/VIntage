//
//  KeyInterceptor.h
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <objc/runtime.h>

@class HotKey;

typedef UInt32 KeyCode;

#define KeyCode8 8
#define KeyCode9 9
#define KeyCode1 1

#define noKey 1

@interface KeyInterceptor : NSObject {
	NSMutableDictionary * listeners;
}


- (HotKey*)keyForId:(EventHotKeyID)keyId;
// Let's assume ALWAYS key presses for now
- (void)onPress:(KeyCode)code block:(void(^)(void))block;
- (void)onPress:(KeyCode)code modifiers:(NSUInteger)modifiers block:(void(^)(void))block;
- (void)broadcast:(KeyCode)code;


- (void)unlisten;
- (void)listen;




@end



