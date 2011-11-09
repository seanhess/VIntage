//
//  AccessText.m
//  VIntage
//
//  Created by Sean Hess on 11/8/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

// This example was great! :: 
// http://macprogramming.googlecode.com/svn-history/r28/trunk/Accessability/KeyCapture.cpp

#import "CarbonAccessText.h"

#define NSMakeRangeFromCF(cfr) NSMakeRange( cfr.location == kCFNotFound ? NSNotFound : cfr.location, cfr.length )

@implementation CarbonAccessText

+(void) test {

    // √ XCode
    // X TextMate -- What's up with textmate?
    // √ Chocolat
    // √ Vico

    AXUIElementRef systemWideElement = AXUIElementCreateSystemWide();
    AXUIElementRef focussedElement = NULL;
//    AXError error;

    NSLog(@"Getting Main");

    if (AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedUIElementAttribute, (CFTypeRef *)&focussedElement) != kAXErrorSuccess) return;

    AXValueRef rangeValue = NULL;
    CFTypeRef value; 
    CFRange range;
    CFNumberRef number;
    CFStringRef string;
    
    NSLog(@"Starting");    
                    
    // selected range
    if (AXUIElementCopyAttributeValue(focussedElement, kAXSelectedTextRangeAttribute, (CFTypeRef *)&rangeValue) != kAXErrorSuccess) return;
    AXValueGetValue(rangeValue, kAXValueCFRangeType, &range);
    NSLog(@"Selected Range: %@", NSStringFromRange(NSMakeRangeFromCF(range)));
    
    
    // Get selected text
    if(AXUIElementCopyAttributeValue(focussedElement, kAXSelectedTextAttribute, &value) != kAXErrorSuccess) return;
    NSLog(@"Selected Text: '%@'", [(id)value description]);
    
    
    // the actual VISIBLE range. It isn't the full range
    if (AXUIElementCopyAttributeValue(focussedElement, kAXVisibleCharacterRangeAttribute, (CFTypeRef *)&rangeValue) != kAXErrorSuccess) return;
    AXValueGetValue(rangeValue, kAXValueCFRangeType, &range);
    NSLog(@"Visible Range: %@", NSStringFromRange(NSMakeRangeFromCF(range)));

    // How long the current document is
    if (AXUIElementCopyAttributeValue(focussedElement, kAXNumberOfCharactersAttribute, (CFTypeRef *)&number) != kAXErrorSuccess) return;
    NSLog(@"Number of Characters: %@", [(id)number description]);
    
    // insert point line number! (0 index)
    if (AXUIElementCopyAttributeValue(focussedElement, kAXInsertionPointLineNumberAttribute, (CFTypeRef *)&number) != kAXErrorSuccess) return;
    NSLog(@"Line Number: %@", [(id)number description]);  
    
    // Line range
    if (AXUIElementCopyParameterizedAttributeValue(focussedElement, kAXRangeForLineParameterizedAttribute, number, (CFTypeRef *)&rangeValue) != kAXErrorSuccess) return;
    AXValueGetValue(rangeValue, kAXValueCFRangeType, &range);
    NSLog(@"Line Range: %@", NSStringFromRange(NSMakeRangeFromCF(range)));        
    
    // Line text! Uses range from line range
    if (AXUIElementCopyParameterizedAttributeValue(focussedElement, kAXStringForRangeParameterizedAttribute, rangeValue, (CFTypeRef *)&string) != kAXErrorSuccess) return;
    NSLog(@"String for range (line): %@", [(id)string description]);   // boom, you can get the string for ANY range.   
        
        
    // can use: kAXFocusedUIElementChangedNotification to update vars if its too slow to check every stroke
    
            
}


@end
