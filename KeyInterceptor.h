//
//  KeyInterceptor.h
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyTypes.h"
#import "ModeDelegate.h"

@class HotKeyGroup, KeyPress;

@interface KeyInterceptor : NSObject <KeySender> {
	NSMutableSet * groups;
	NSMutableArray * presses;
	NSMutableDictionary * codesForStrings;
	
	CFRunLoopSourceRef runLoopSource;
	CGEventSourceRef eventSource;
	CFMachPortRef eventTap;
	
	CGEventRef nullEvent;
	
	NSString * lastId;
	NSString * last2Id;
	NSString * last3Id;
    
    id<ModeDelegate>delegate;    
}

@property (nonatomic, retain) NSMutableSet * groups;
@property (nonatomic, retain) NSMutableArray * presses;
@property (nonatomic, retain) NSMutableDictionary * codesForStrings;

@property (nonatomic, retain) NSString * lastId;
@property (nonatomic, retain) NSString * last2Id;
@property (nonatomic, retain) NSString * last3Id;

@property (nonatomic, assign) id<ModeDelegate>delegate;

- (NSString*)lastId:(NSInteger)num;

- (CGEventRef)nullEvent;

// You probably shouldn't have more than one
+ (KeyInterceptor*)shared;

- (NSString*)stringForCode:(KeyCode)code;
- (KeyCode)codeForString:(NSString*)string;

// Can also parse with spaces!
- (KeyPress*)parseKeyId:(NSString*)keyId;
- (NSArray*)parseKeyIds:(NSString*)keyId;

- (void)addKeyToHistory:(KeyPress*)key;
- (void)resetHistory:(NSArray*)history;

- (HotKeyGroup*)groupWithName:(NSString*)name;

// KeySender
//- (void)sendString:(NSString*)string;
//- (void)sendKey:(KeyCode)code;
//- (void)sendKey:(KeyCode)code cmd:(BOOL)cmd alt:(BOOL)alt ctl:(BOOL)ctl shift:(BOOL)shift;


- (void)add:(HotKeyGroup*)group;
- (void)remove:(HotKeyGroup*)group;
- (void)activateGroup:(HotKeyGroup*)activeGroup;
- (void)activateGroupWithName:(NSString*)name;
- (void)setSource:(CGEventSourceRef)source;

- (void)listen;
- (void)enable;


@end



