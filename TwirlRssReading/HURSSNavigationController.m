//
//  HURSSNavigationControllerViewController.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSNavigationController.h"
#import "HUSplashTransitionAnimator.h"


#define BASE_ROOT_NAV_CLASS HUSelectRSSChannelPresenter

@interface HURSSNavigationController ()

@end

@implementation HURSSNavigationController


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    id <UIViewControllerAnimatedTransitioning> useAnimator = nil;
    
    BOOL isSplashSegue = [presenting isKindOfClass:[HUSplashViewController class]] && [presented isKindOfClass:[self class]];
    
    if(isSplashSegue){
        useAnimator = [HUSplashTransitionAnimator new];
        
        HUSplashTransitionAnimator *splashAnimator = (HUSplashTransitionAnimator*)useAnimator;
        splashAnimator.needPresenting = YES;
    }
    
    return useAnimator;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    
    id <UIViewControllerAnimatedTransitioning> useAnimator = nil;
    
    BOOL isSplashSegue = [fromVC isKindOfClass:[HUSplashViewController class]] && [toVC isKindOfClass:[HURSSFeedsPresenter class]];
    
    if(isSplashSegue){
        useAnimator = [HUSplashTransitionAnimator new];
        
        HUSplashTransitionAnimator *splashAnimator = (HUSplashTransitionAnimator*)useAnimator;
        splashAnimator.needPresenting = (operation == UINavigationControllerOperationPush);
    }
    
    return useAnimator;
}

@end
