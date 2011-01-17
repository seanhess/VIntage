//
//  HotKey.h
//  InputNinja
//
//  Created by Sean Hess on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotKey : NSObject {
	BOOL(^block)(void);
	NSString * keyId;
}

-(id)initWithKeyId:(NSString*)keyId block:(BOOL(^)(void))block;
+(HotKey*)keyWithId:(NSString*)keyId block:(BOOL(^)(void))block;

@property (nonatomic, retain) NSString * keyId;
@property (nonatomic, copy) BOOL(^block)(void);

@end
