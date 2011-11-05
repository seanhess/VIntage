//
//  Parser.m
//  VIntage
//
//  Created by Sean Hess on 11/4/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "Parser.h"
#import "HotKey.h"
#import "KeyInterceptor.h"

@interface Parser ()
+(NSArray*)parseCommands:(NSString *)commands;
@end

//         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSSystemDomainMask, YES);

@implementation Parser

+(NSString*)bundleFilePath:(NSString*)name {
    return [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
}

+(NSArray*)parseFile:(NSString*)filePath {
    
    NSLog(@"Reading Configuration File: %@", filePath);
    NSMutableArray * groups = [NSMutableArray array];

    NSError * error = nil;
    NSString * contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    NSArray * majorComponents = [contents componentsSeparatedByString:@"--"];
    NSCharacterSet * whitespace = [NSCharacterSet whitespaceCharacterSet];
    
    for (int i = 0; i < [majorComponents count]; i += 2) {
        NSString * name = [[majorComponents objectAtIndex:i] stringByTrimmingCharactersInSet:whitespace];
        NSString * commands = [[majorComponents objectAtIndex:i+1] stringByTrimmingCharactersInSet:whitespace];
        
        HotKeyGroup * group = [[HotKeyGroup alloc] initWithName:name];
        NSArray * keys = [self parseCommands:commands];
        
        for (HotKey * key in keys)
            [group add:key];
            
        [groups addObject:group];
    }
    
    return groups;
}

+(NSArray*)parseCommands:(NSString *)commands {

    NSMutableArray * hotKeys = [NSMutableArray array];

    NSArray * components = [commands componentsSeparatedByString:@"\n"];
    
    NSCharacterSet * whitespace = [NSCharacterSet whitespaceCharacterSet];    
    
    for (NSString * commandStr in components) {
        commandStr = [commandStr stringByTrimmingCharactersInSet:whitespace];
        if ([commandStr isEqualToString:@""]) continue;
        
        NSArray * cmdComponents = [commandStr componentsSeparatedByString:@" - "];
        
        NSString * keys = [[cmdComponents objectAtIndex:0] stringByTrimmingCharactersInSet:whitespace];
        NSString * command = [[cmdComponents objectAtIndex:1] stringByTrimmingCharactersInSet:whitespace];
        
        HotKey * hotKey = [HotKey keyWithId:keys block:^{
            [[KeyInterceptor shared] sendString:command];
        }];
        
        [hotKeys addObject:hotKey];
    }
    
    return hotKeys;
}

@end
