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

@interface KeyInterceptor : NSObject {
	EventHotKeyRef hotKeyRef;
	EventHotKeyID hotKeyID;
	EventTypeSpec eventType;
}

- (void)unlisten;

-(void)listen;

@end
