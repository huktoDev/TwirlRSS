//
//  UIView+DisableMultiTouch.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 26.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "UIView+DisableMultiTouch.h"

@implementation UIView (DisableMultiTouch)

- (void)disableMultiTouch{
    [[self class] makeExclusiveTouchToSubviews:self];
}

+ (void)makeExclusiveTouchToSubviews:(UIView*)parentView{
    parentView.multipleTouchEnabled = NO;
    parentView.exclusiveTouch = YES;
    
    for(UIView *currentView in [parentView subviews]){
        [[self class] makeExclusiveTouchToSubviews:currentView];
    }
}

@end
