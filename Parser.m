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
    return [[NSBundle mainBundle] pathForResource:name ofType:@"vintage"];
}

+(NSString*)libraryFilePath:(NSString*)name {

    NSString * appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString * vintageDir = [appSupportDir stringByAppendingPathComponent:@"VIntage"];
    
    // Make application support directory if you need to
    if (![[NSFileManager defaultManager] fileExistsAtPath:vintageDir]) {
        NSError * error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:vintageDir withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) NSLog(@"Could not Application Support Directory: %@", vintageDir);
    }
    
    return [vintageDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.vintage", name]];
}

+(NSArray*)parseFile:(NSString*)filePath {
    
    NSLog(@"Reading Configuration File: %@", filePath);
    NSMutableArray * groups = [NSMutableArray array];

    NSError * error = nil;
    NSString * contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) return nil;
    
    // the very first one should be "" then it should be name/commands/name/commands
    NSArray * majorComponents = [contents componentsSeparatedByString:@"--"];
    NSCharacterSet * whitespace = [NSCharacterSet whitespaceCharacterSet];
    
    for (int i = 1; i < [majorComponents count]; i += 2) {
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
        
        HotKey * hotKey = [HotKey keyWithId:keys commands:command];

        [hotKeys addObject:hotKey];
    }
    
    return hotKeys;
}

// load the main groups, then merge them with the file from ~/Library/Application Support/VIntage/keys.vintage
+(NSArray*)groupsFromAllLocations {
    NSMutableArray * defaultGroups = [NSMutableArray arrayWithArray:[self parseFile:[self bundleFilePath:@"defaults"]]];
    NSArray * overrideGroups = [self parseFile:[self libraryFilePath:@"keys"]];
    
    for (HotKeyGroup * override in overrideGroups) {
        
        HotKeyGroup * original = nil;
        
        for (HotKeyGroup * group in defaultGroups) {
            if ([group.name isEqualToString:override.name]) {
                original = group;
                break;
            }
        }
        
        if (original)
            [original overrideWith:override];
            
        else
            [defaultGroups addObject:override];
    }
    
    return defaultGroups;
}

@end
