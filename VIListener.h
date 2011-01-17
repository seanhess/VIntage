//
//  VIListener.h
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KeyInterceptor, HotKeyGroup;

@interface VIListener : NSObject {
	HotKeyGroup * commandMode;
	HotKeyGroup * insertMode;
	HotKeyGroup * visualMode;
	HotKeyGroup * findMode;
	
	NSStatusItem * statusItem;
	NSString * lastSend;
}

@property (nonatomic, retain) NSStatusItem * statusItem;

//-(void)send:(NSString*)command;

-(void)useFind;
-(void)useVisual;
-(void)useCommand;
-(void)useInsert;
-(void)listen;

@end
