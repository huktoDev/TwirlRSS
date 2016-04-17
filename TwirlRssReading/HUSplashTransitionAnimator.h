//
//  HUSplashTransitionAnimator.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

/**
    @class HUSplashTransitionAnimator
    @author HuktoDev
    @updated 17.04.2016
    @abstract Класс-аниматор, который анимирует переход со Splash-экрана к рут-экрану навигации 
    @discussion
    Используется возможности UIViewController-а по анимированнию перехода, инкапсулирует всю логику анимирования UI перехода
 
    @note  Для этой роли можно было бы использовать возможности UIStoryboardSegue (метод perform), однако при использовании роутера, как мне кажется, подобные аниматоры более естественны
 */
@interface HUSplashTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/// Требуется выполнить переход вперед? Если да - то YES. На текущий момент обратный переход не реализован
@property (assign, nonatomic) BOOL needPresenting;


@end
