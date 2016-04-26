//
//  HURSSTwirlRouter+CustomSegues.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSTwirlRouter.h"
@class HURSSAppDelegate;

/**
    @constant HURSSTwirlBaseNavigationSegue
        Переход к базовому навигационному контроллеру (при входе в приложение, переходит к SelectChannel-экрану)
    @constant HURSSTwirlChannelSelectedSegue
        Переход к новостям выбранного канала (Feeds-экран)
    @constant HURSSTwirlFeedDetailsSegue
        Переход к детальной информации конкретной новости (ItemDetails-экран)
 */

extern NSString* const HURSSTwirlBaseNavigationSegue;
extern NSString* const HURSSTwirlChannelSelectedSegue;
extern NSString* const HURSSTwirlFeedDetailsSegue;


/**
    @category HURSSTwirlRouter (CustomSegues)
    @author HuktoDev
    @updated 18.04.2016
    @abstract Удобное место для выноса конкретных реализаций переходов роутера HURSSTwirlRouter
 
    <h4> На текущий момент реализует 3 перехода : </h4>
    @see
    HURSSTwirlBaseNavigationSegue \n
    HURSSTwirlChannelSelectedSegue \n
    HURSSTwirlFeedDetailsSegue \n
 
    @note Кроме всего, умеет переопределять стартовую точку входа в Presentation-слой
 */
@interface HURSSTwirlRouter (CustomSegues)


#pragma mark - Programmatically override INITIAL APP Point
// Переопределение стартовой точки приложения (чтобы в делегате рут-контроллер задавался программно)

- (void)overrideInitialScreenCreationByAppDelegate:(HURSSAppDelegate*)appDelegate;


#pragma mark - PERFORM Segues
// Выполнение конкретных сег

- (void)performBaseNavigationSegueFromScreen:(UIViewController*)sourceVC;
- (void)performChannelSelectedSegueFromScreen:(UIViewController*)sourceVC;
- (void)performFeedDetailsSegueFromScreen:(UIViewController*)sourceVC;


#pragma mark - POSSIBLE Segues
// Набор методов, содержащих информацию о возможных сегах экранов

- (NSSet <NSString*>*)possibleSplashSegues;
- (NSSet <NSString*>*)possibleSelectChannelSegues;
- (NSSet <NSString*>*)possibleFeedsSegues;
- (NSSet <NSString*>*)possibleItemDetailsSegues;


@end
