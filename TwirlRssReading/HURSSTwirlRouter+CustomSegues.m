//
//  HURSSTwirlRouter+CustomSegues.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSTwirlRouter+CustomSegues.h"

#import "AppDelegate.h"
#import "HUSplashViewController.h"
#import "HURSSNavigationController.h"
#import "HUSelectRSSChannelPresenter.h"
#import "HURSSFeedsPresenter.h"
#import "HURSSItemPresenter.h"

@implementation HURSSTwirlRouter (CustomSegues)


#pragma mark - Initial Point

/**
    @abstract  Переопределение стартовой точки приложения (чтобы в делегате рут-контроллер задавался программно)
    @discussion
    Чтобы отойти полностью от использования сторибоарда - нужно кроме всего и генерить его программно с самого начала. 
    Было решено, что Initial Pointприложения находится в юрисдикции роутера
 
    @param appDelegate      Делегат приложения проекта
 */
- (void)overrideInitialScreenCreationByAppDelegate:(AppDelegate*)appDelegate{
    
    UIViewController *intialViewController = [_splashScreenController new];
    
    CGRect deviceScreenBounds = [UIScreen mainScreen].bounds;
    UIWindow *customCreatedMainWindow = [[UIWindow alloc] initWithFrame:deviceScreenBounds];
    customCreatedMainWindow.backgroundColor = [UIColor whiteColor];
    
    appDelegate.window = customCreatedMainWindow;
    [customCreatedMainWindow setRootViewController:intialViewController];
    
    [customCreatedMainWindow makeKeyAndVisible];
}


#pragma mark - PERFORM Segues

/**
    @abstract Выполнение перехода со сплэш-скрина
    @discussion
    По юзер-стори пользователь со сплэш-скрина попадает на SelectChannel-экран (но он завернут в навигационный контроллер), так что здесь создается и презентится этот навигационный контроллер, и создается рут-контроллером SelectChannelPresenter
 
    @note Выполняется кастомный транзишен для перехода (реализуется аниматор в навигационном контроллере)
 
    @param sourceVC      Базовый контроллер, инициировавший переход
 */
- (void)performBaseNavigationSegueFromScreen:(UIViewController*)sourceVC{
    
    UIViewController *selectChannelViewController = [_selectChannelController new];
    UINavigationController *modalNavController = [[_baseNavController alloc] initWithRootViewController:selectChannelViewController];
    
    BOOL hasImplementTransitioning = [modalNavController conformsToProtocol:@protocol(UIViewControllerTransitioningDelegate)];
    NSAssert(hasImplementTransitioning, @"ROOT Navigation Controlle do not implement UIViewControllerTransitioningDelegate protocol");
    
    modalNavController.transitioningDelegate = (id<UIViewControllerTransitioningDelegate>)modalNavController;
    modalNavController.modalTransitionStyle = UIModalPresentationCustom;
    
    [sourceVC presentViewController:modalNavController animated:YES completion:nil];
}

- (void)performChannelSelectedSegueFromScreen:(UIViewController*)sourceVC{
    
}

- (void)performFeedDetailsSegueFromScreen:(UIViewController*)sourceVC{
    
}


#pragma mark - POSSIBLE Segues

- (NSSet <NSString*>*)possibleSplashSegues{
    return [NSSet setWithArray:@[HURSSTwirlBaseNavigationSegue]];
}

- (NSSet <NSString*>*)possibleSelectChannelSegues{
    return [NSSet setWithArray:@[HURSSTwirlChannelSelectedSegue]];
}

- (NSSet <NSString*>*)possibleFeedsSegues{
    return [NSSet setWithArray:@[HURSSTwirlFeedDetailsSegue]];
}

- (NSSet <NSString*>*)possibleItemDetailsSegues{
    return [NSSet new];
}


@end


