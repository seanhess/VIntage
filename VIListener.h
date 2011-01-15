//
//  VIListener.h
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KeyInterceptor;

@interface VIListener : NSObject {
	KeyInterceptor * keys;
	BOOL commandMode;
	BOOL insertMode;
}

-(void)listen;

@end
