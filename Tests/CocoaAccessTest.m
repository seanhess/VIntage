//
//  CocoaAccessTest.m
//  VIntage
//
//  Created by Sean Hess on 11/8/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "CocoaAccessTest.h"

@implementation CocoaAccessTest



+ (void) test {
    // http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ApplicationKit/Protocols/NSAccessibility_Protocol/Reference/Reference.html#//apple_ref/doc/uid/20000945
    
    NSLog(@" ");
    NSLog(@"HELLO");
    
    NSLog(@"UMMMM %@", [NSApplication sharedApplication]);        
    NSLog(@"UMMMM %@", [[NSApplication sharedApplication] mainWindow]);    
    NSLog(@"UMMMM %@", [[[NSApplication sharedApplication] keyWindow] firstResponder]);
    
    [[NSApplication sharedApplication] hide:self];
}

@end
