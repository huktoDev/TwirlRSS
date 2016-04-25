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
    NSAssert(hasImplementTransitioning, @"ROOT Navigation Controller do not implement UIViewControllerTransitioningDelegate protocol");
    
    modalNavController.transitioningDelegate = (id<UIViewControllerTransitioningDelegate>)modalNavController;
    modalNavController.modalTransitionStyle = UIModalPresentationCustom;
    
    [sourceVC presentViewController:modalNavController animated:YES completion:nil];
}

/**
    @abstract Выполнение перехода со SelectChannel-экрана на Feeds-экран
    @discussion
    По юзер-стори пользователь после выбора канала, и удачной загрзки новостей - попадет на Feeds-экран. Feeds-экрану требуется передать полученные  новости. 
    Получение и передача осуществляется с помощью специализированных протоколов
 
    @param sourceVC      Базовый контроллер, инициировавший переход (HURSSSelectScreenPresenter)
 */
- (void)performChannelSelectedSegueFromScreen:(UIViewController*)sourceVC{
    
    UIViewController *feedsViewController = [_feedsController new];
    
    // Реализованы ли соответствующие интерфейсы
    BOOL hasImplementFeedsRecieving = [sourceVC conformsToProtocol:@protocol(HURSSChannelSelectRecievedFeedsProtocol)];
    NSAssert(hasImplementFeedsRecieving, @"SelectChannel Controller do not implement HURSSChannelSelectRecievedFeedsProtocol protocol for FEEDS INFO Recieving");
    
    BOOL hasImplementFeedsTransfer = [feedsViewController conformsToProtocol:@protocol(HURSSFeedsTransferProtocol)];
    NSAssert(hasImplementFeedsTransfer, @"Feeds Controller do not implement HURSSFeedsTransferProtocol protocol for FEEDS INFO Transfer");
    
    // Получить данные
    id <HURSSChannelSelectRecievedFeedsProtocol> feedsReciever = (id<HURSSChannelSelectRecievedFeedsProtocol>)sourceVC;
    
    NSArray <HURSSFeedItem*> *recievedFeeds = [feedsReciever getRecievedFeeds];
    HURSSFeedInfo *recievedFeedInfo = [feedsReciever getFeedInfo];
    
    // Передать данные
    id <HURSSFeedsTransferProtocol> waitingFeedsObject = (id<HURSSFeedsTransferProtocol>)feedsViewController;
    
    [waitingFeedsObject setFeeds:recievedFeeds];
    [waitingFeedsObject setFeedInfo:recievedFeedInfo];
    
    
    // Выполнить переход
    [sourceVC.navigationController pushViewController:feedsViewController animated:YES];
}

/// Тут по идее, должен был быть FedDetails-переход
- (void)performFeedDetailsSegueFromScreen:(UIViewController*)sourceVC{
    
}


#pragma mark - POSSIBLE Segues

/// Набор переходов со Splash-экрана
- (NSSet <NSString*>*)possibleSplashSegues{
    return [NSSet setWithArray:@[HURSSTwirlBaseNavigationSegue]];
}

/// Набор переходов с SelectChannel-экрана
- (NSSet <NSString*>*)possibleSelectChannelSegues{
    return [NSSet setWithArray:@[HURSSTwirlChannelSelectedSegue]];
}

/// Набор переходов с Feeds-экрана
- (NSSet <NSString*>*)possibleFeedsSegues{
    return [NSSet setWithArray:@[HURSSTwirlFeedDetailsSegue]];
}

/// Набор переходов с ItemDetails-экрана (так и не реализованного)
- (NSSet <NSString*>*)possibleItemDetailsSegues{
    return [NSSet new];
}


@end


