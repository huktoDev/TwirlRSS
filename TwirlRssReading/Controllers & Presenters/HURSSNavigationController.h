//
//  HURSSNavigationControllerViewController.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    @class HURSSNavigationController
    @author HuktoDev
    @updated 25.04.2016
    @abstract Навигационный контроллер приложения, содерит некоторую навигационную логику (но в основном она содержится в роутере HURSSTwirlRouter)
 */
@interface HURSSNavigationController : UINavigationController <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end
