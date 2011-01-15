//
//  VIListener.h
//  InputNinja
//
//  Created by Sean Hess on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDHotKeyCenter.h"


@interface VIListener : NSObject {
	DDHotKeyCenter * center;
}

-(void)listen;

@end
