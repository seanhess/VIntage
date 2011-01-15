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

typedef UInt32 KeyCode;

#define noKey 1

#define KeyCodeEscape 53
#define KeyCodeBacktick 50
#define KeyCode1 18
#define KeyCode2 19
#define KeyCode3 20
#define KeyCode4 21
#define KeyCode5 23
#define KeyCode6 22
#define KeyCode7 26
#define KeyCode8 28
#define KeyCode9 25
#define KeyCode0 29
#define KeyCodeMinus 27
#define KeyCodeEquals 24

#define KeyCodeTab 48
#define KeyCodeQ 12
#define KeyCodeW 13
#define KeyCodeE 14
#define KeyCodeR 15
#define KeyCodeT 17
#define KeyCodeY 16
#define KeyCodeU 32
#define KeyCodeI 34
#define KeyCodeO 31
#define KeyCodeP 35
#define KeyCodeLBracket 33
#define KeyCodeRBracket 30
#define KeyCodeBackslash 42

#define KeyCodeA 0
#define KeyCodeS 1
#define KeyCodeD 2
#define KeyCodeF 3
#define KeyCodeG 5
#define KeyCodeH 4
#define KeyCodeJ 38
#define KeyCodeK 40
#define KeyCodeL 37
#define KeyCodeSemicolon 41
#define KeyCodeApostrophe 39
#define KeyCodeEnter 36

#define KeyCodeZ 6
#define KeyCodeX 7
#define KeyCodeC 8
#define KeyCodeV 9
#define KeyCodeB 11
#define KeyCodeN 45
#define KeyCodeM 46
#define KeyCodeComma 43
#define KeyCodePeriod 47
#define KeyCodeSlash 44




@class HotKey;

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



