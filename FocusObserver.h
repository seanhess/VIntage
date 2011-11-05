//
//  CurrentApplicationState.h
//  VIntage
//
//  Created by Sean Hess on 11/5/11.
//  Copyright (c) 2011 I.TV. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FocusDelegate <NSObject>
-(void)didSwitchToActive;
-(void)didSwitchToInactive;
@end

@interface FocusObserver : NSObject {
    id<FocusDelegate>delegate;
    NSArray * applications;
}
@property (nonatomic, assign) id<FocusDelegate>delegate;
@property (nonatomic, retain) NSArray * applications;

- (void) observeApplications:(NSArray*)applications delegate:(id<FocusDelegate>)del;
@end
