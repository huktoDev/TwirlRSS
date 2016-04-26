//
//  UIView+DisableMultiTouch.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 26.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    @category UIView (DisableMultiTouch)
    @author HuktoDev
    @updated 26.04.2016
    @abstract Категория для отключения у вьюшки мультитача
    @discussion
    Данная категория требуется для каждой вьюшки ручного удаления мультитача.
    К сожалению, у меня в рабочем проекте было решение со свиззлингом, которое отключало мультитач у всех порождаемых вьюшек приложения, но я его забыл скопировать.
    Дизейблинг мультитача нужно, чтобы избавиться от некоторых нежелательных состояний
 */
@interface UIView (DisableMultiTouch)

- (void)disableMultiTouch;
+ (void)makeExclusiveTouchToSubviews:(UIView*)parentView;

@end
