//
//  HotKey.h
//  InputNinja
//
//  Created by Sean Hess on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotKey : NSObject {
	void(^block)(void);
	NSString * keyId;
	BOOL resetHistory;
}

-(id)initWithKeyId:(NSString*)keyId block:(void(^)(void))block;
+(HotKey*)keyWithId:(NSString*)keyId block:(void(^)(void))block;

@property (nonatomic, retain) NSString * keyId;
@property (nonatomic, copy) void(^block)(void);
@property (assign) BOOL resetHistory;

@end
