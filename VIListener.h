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
	KeyInterceptor * keys;
	HotKeyGroup * commandMode;
	HotKeyGroup * insertMode;
	
	NSStatusItem * statusItem;
	
	NSString * lastSend;
}

@property (nonatomic, retain) NSStatusItem * statusItem;

//-(void)send:(NSString*)command;


-(void)useCommand;
-(void)useInsert;
-(void)listen;

@end
