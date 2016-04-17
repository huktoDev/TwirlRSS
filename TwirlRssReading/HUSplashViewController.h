//
//  ViewController.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    @class HUSplashViewController
    @author HuktoDev
    @updated 17.04.2016
    @abstract Класс-Контроллер первого экрана, и вьюшки Splash-экрана
    @discussion
    Крайне простой класс, размещает по центру экрана логотип, и запускает у роутера переход к следующему экрану (это навигационный контроллер HURSSNavigationController, с корневым HUSelectRSSChannelPresenter)
 
    @note Выполнен по простому MVC, т.к для такого простого экрана что-либо другое будет явно избыточно
 
    @note Использование отдельного Splash-контроллера может продлевать момент, когда пользователь получит доступ к функционалу приложения, однако я считаю, что лишние 2-3 секунды не дадут профита! Наличие специального контроллера позволяет выполнять различные интересные эффекты, и обеспечивает большую гибкость при загрузке приложения
 
    @see
    HURSSTwirlRouter \n
    HURSSTwirlStyle \n
 */
@interface HUSplashViewController : UIViewController


@end

