//
//  AccessText.m
//  VIntage
//
//  Created by Sean Hess on 11/8/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import "AccessText.h"

@implementation AccessText

+(void) test {

    AXUIElementRef systemWideElement = AXUIElementCreateSystemWide();
    AXUIElementRef focussedElement = NULL;
    AXError error;
    error = AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedUIElementAttribute, (CFTypeRef *)&focussedElement);
    if (error != kAXErrorSuccess) {
        NSLog(@"Could not get focussed element");
    } else {
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
        
        
        // Get selected text
        AXValueRef selectedValueRef = NULL;
        getSelectedRangeError = AXUIElementCopyAttributeValue(focussedElement, kAXSelectedTextAttribute, (CFTypeRef *)&selectedValueRef);
        if (getSelectedRangeError != kAXErrorSuccess) return;        
        CFTypeRef value = nil; 
        if(AXUIElementCopyAttributeValue(focussedElement, kAXSelectedTextAttribute, &value) != kAXErrorSuccess) return;
        NSLog(@"Selected Text %@", [(id)value description]);
        
        
    }
    if (focussedElement != NULL) CFRelease(focussedElement);
    CFRelease(systemWideElement);
}


@end
