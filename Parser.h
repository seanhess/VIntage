//
//  Parser.h
//  VIntage
//
//  Created by Sean Hess on 11/4/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotKeyGroup.h"

@interface Parser : NSObject

+(NSArray*)parseFile:(NSString*)filePath;
+(NSString*)bundleFilePath:(NSString*)name;
+(NSArray*)groupsFromAllLocations;

@end
