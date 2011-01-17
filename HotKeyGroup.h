//
//  HotKeySet.h
//  InputNinja
//
//  Created by Sean Hess on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// A group of hotkeys that can be globally enabled/disabled
// and applied against different applications




@class KeyPress, HotKey;
@interface HotKeyGroup : NSObject {
	BOOL enabled;
	NSMutableDictionary * keys;
}

@property (nonatomic) BOOL enabled;
@property (nonatomic, retain) NSMutableDictionary * keys;

-(void)add:(HotKey*)hotKey;
-(void)remove:(HotKey*)hotKey;

// presses already contains info
-(void)onKeyDown:(KeyPress*)info presses:(NSArray*)presses;

@end
