//
//  UIView+DisableMultiTouch.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 26.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DisableMultiTouch)

- (void)disableMultiTouch;
+ (void)makeExclusiveTouchToSubviews:(UIView*)parentView;

@end
