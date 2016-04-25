//
//  HURSSNavigationControllerViewController.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSNavigationController.h"
#import "HUSplashTransitionAnimator.h"

@implementation HURSSNavigationController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Базовый конфиг навигационной панели (слишком мало, чтобы порождать подкласс)
    self.navigationBar.barTintColor = HU_RGB_COLOR(153.f, 142.f, 94.f);
    self.navigationBar.alpha = 0.8f;
    self.navigationBar.tintColor = [[HURSSTwirlStyle sharedStyle] firstUseColor];
    
    // Включаем жест бэк-свайпа (из-за кастомного баттона нужно вручную включать)
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    // Отслеживать события изменения контроллеров
    self.delegate = self;
}


#pragma mark - UIGestureRecognizerDelegate (ENABLING POP GESTURE)

/// Включить PopGesture
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

/// Когда должен отобразиться новый вью-контроллер
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // Для экрана Feeds установить тайтл, и кастомную кнопку бара
    if([viewController isKindOfClass:[HURSSFeedsPresenter class]]){
        
        viewController.title = @"Новости";
        
        UINavigationItem *feedsNavigationItem = [self.navigationBar items][0];
        UIBarButtonItem *newBackBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:nil action:nil];
        [feedsNavigationItem setBackBarButtonItem:newBackBarItem];
    }
}


#pragma mark - UIViewControllerTransitioningDelegate

/// Переопределить переход со Splash-экрана с кастомным аниматором
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


@end
