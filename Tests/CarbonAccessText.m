//
//  AccessText.m
//  VIntage
//
//  Created by Sean Hess on 11/8/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

// This example was great! :: 
// http://stackoverflow.com/questions/6544311/how-to-show-nspanel-on-selected-text-on-hot-key-press-on-current-active-app
// http://macprogramming.googlecode.com/svn-history/r28/trunk/Accessability/KeyCapture.cpp

// Text Services Manager in Carbon - to track insert point in carbon -- not available to 64 bit applications

#import "CarbonAccessText.h"

#define NSMakeRangeFromCF(cfr) NSMakeRange( cfr.location == kCFNotFound ? NSNotFound : cfr.location, cfr.length )

@implementation CarbonAccessText

+(void) test {

    // √ XCode
    // X TextMate -- What's up with textmate? Check for the error and find out
    // √ Chocolat
    // √ Vico
    // X Sublime Text

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
    AXUIElementCopyAttributeValue(focussedElement, kAXSelectedTextAttribute, &value);
    NSLog(@"Selected Text: '%@'", [(id)value description]);
    
    
    // the actual VISIBLE range. It isn't the full range
    AXUIElementCopyAttributeValue(focussedElement, kAXVisibleCharacterRangeAttribute, (CFTypeRef *)&rangeValue);
    AXValueGetValue(rangeValue, kAXValueCFRangeType, &range);
    NSLog(@"Visible Range: %@", NSStringFromRange(NSMakeRangeFromCF(range)));

    // How long the current document is
    AXUIElementCopyAttributeValue(focussedElement, kAXNumberOfCharactersAttribute, (CFTypeRef *)&number);
    NSLog(@"Number of Characters: %@", [(id)number description]);
    
    // insert point line number! (0 index) -- doesn't work if you have multiple lines selected
    AXUIElementCopyAttributeValue(focussedElement, kAXInsertionPointLineNumberAttribute, (CFTypeRef *)&number);
    NSLog(@"Line Number: %@", [(id)number description]);  
    
    // Line range
    AXUIElementCopyParameterizedAttributeValue(focussedElement, kAXRangeForLineParameterizedAttribute, number, (CFTypeRef *)&rangeValue);
    AXValueGetValue(rangeValue, kAXValueCFRangeType, &range);
    NSLog(@"Line Range: %@", NSStringFromRange(NSMakeRangeFromCF(range)));        
    
    // Line text! Uses range from line range
    AXUIElementCopyParameterizedAttributeValue(focussedElement, kAXStringForRangeParameterizedAttribute, rangeValue, (CFTypeRef *)&string);
    NSLog(@"String for range (line): %@", [(id)string description]);   // boom, you can get the string for ANY range.   
        
        
    // + kAXLineForIndexParameterizedAttribute
    
    // can use: kAXFocusedUIElementChangedNotification to update vars if its too slow to check every stroke
    
    // !!! // YOu can use BoundsForRange and construct a range representing the character point. Use selectedRange, then get the bounds of {num, 1}
    // Boom!
            
            
            
//#define kAXLineForIndexParameterizedAttribute CFSTR("AXLineForIndex")
//#define kAXRangeForLineParameterizedAttribute          CFSTR("AXRangeForLine")
//#define kAXStringForRangeParameterizedAttribute         CFSTR("AXStringForRange")
//#define kAXRangeForPositionParameterizedAttribute CFSTR("AXRangeForPosition")
//#define kAXRangeForIndexParameterizedAttribute CFSTR("AXRangeForIndex")
//#define kAXBoundsForRangeParameterizedAttribute CFSTR("AXBoundsForRange")
//#define kAXRTFForRangeParameterizedAttribute CFSTR("AXRTFForRange")
//#define kAXAttributedStringForRangeParameterizedAttribute  CFSTR("AXAttributedStringForRange")
//#define kAXStyleRangeForIndexParameterizedAttribute CFSTR("AXStyleRangeForIndex")
//#define kAXInsertionPointLineNumberAttribute CFSTR("AXInsertionPointLineNumber")            
            
            
    
    // selected bounds -- doesn't work without selection 
AXValueRef selectedRangeValue = NULL;
    AXError getSelectedRangeError = AXUIElementCopyAttributeValue(focussedElement, kAXSelectedTextRangeAttribute, (CFTypeRef *)&selectedRangeValue);
    if (getSelectedRangeError == kAXErrorSuccess) {
        CFRange selectedRange;
        AXValueGetValue(selectedRangeValue, kAXValueCFRangeType, &selectedRange);
        AXValueRef selectionBoundsValue = NULL;
        AXError getSelectionBoundsError = AXUIElementCopyParameterizedAttributeValue(focussedElement, kAXBoundsForRangeParameterizedAttribute, selectedRangeValue, (CFTypeRef *)&selectionBoundsValue);
        CFRelease(selectedRangeValue);
        if (getSelectionBoundsError == kAXErrorSuccess) {
            CGRect selectionBounds;
            AXValueGetValue(selectionBoundsValue, kAXValueCGRectType, &selectionBounds);
            NSLog(@"Selection bounds: %@", NSStringFromRect(NSRectFromCGRect(selectionBounds)));
        } else {
            NSLog(@"Could not get bounds for selected range");
        }
        if (selectionBoundsValue != NULL) CFRelease(selectionBoundsValue);
    } else {
        NSLog(@"Could not get selected range");
    }
                
}


@end
