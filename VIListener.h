//
//  VIListener.h
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModeDelegate.h"

@class KeyInterceptor, HotKeyGroup;

@interface VIListener : NSObject {
	HotKeyGroup * commandMode;
	HotKeyGroup * insertMode;
	HotKeyGroup * visualMode;
	HotKeyGroup * findMode;
	
	NSString * lastSend;
    
    id<ModeDelegate>delegate;
}

@property (nonatomic, assign) id<ModeDelegate>delegate;

//-(void)send:(NSString*)command;

-(void)useFind;
-(void)useVisual;
-(void)useCommand;
-(void)useInsert;
-(void)listen;

@end
