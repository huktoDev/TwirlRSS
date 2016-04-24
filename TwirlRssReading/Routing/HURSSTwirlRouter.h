//
//  HURSSTwirlRouter.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

@import UIKit;


/**
    @protocol HUBaseRouterProtocol
    @author HuktoDev
    @updated 18.04.2016
    @abstract Протокол, который должен реализовывать каждый объект-роутер приложения
    @discussion
    Содержит 3 метода :
    <ol type="1">
        <li> Метод вызова перехода 
                performTransitionSegue:forScreen: </li>
        <li> Набор возможных сег для экрана 
                possibleSeguesForScreen: </li>
        <li> Возможно ли выполнить конкретный переход с определенного экрана? 
                canPerformSegue:forScreen: </li>
    </ol>
    
    @note Обязателен для реализации - только метод performTransitionSegue:forScreen:
 */
@protocol HUBaseRouterProtocol <NSObject>

@required
- (void)performTransitionSegue:(NSString*)nameSegue forScreen:(UIViewController*)screenVC;


@optional
- (NSSet <NSString*> *)possibleSeguesForScreen:(UIViewController*)screenVC;
- (BOOL)canPerformSegue:(NSString*)nameSegue forScreen:(UIViewController*)screenVC;


@end


/**
    @class HURSSTwirlRouter
    @author HuktoDev
    @updated 18.04.2016
    @abstract Класс-роутер для юзер-стори имеющегося приложения
    @discussion
    По сути является Router-ом архитектуры VIPER. Единственное отличие от канонического VIPER-а в том, что здесь не 1 роутер для 1 экрана (выгодно  в случае нагруженный экранов), и 1 роутер на юзер-стори
 
    Конкретные классы контроллеров экранов можно подменять через метод configService. 
    Недостаток в том, что на самом деле класс реализует все-же функционал близкий, к базовому роутеру, и по идее он должен реализовывать методы переходов.
    Вместо этого методы переходов выносятся в отдельную категорию (для удобства)
    
    @note Является реализацией синглтон-паттерна
    @warning Имеются некоторые недостатки в реализации роутера - нету достаточной расширяемости, и имеется некоторая свзяность самого роутера, с его категорией
 */
@interface HURSSTwirlRouter : NSObject <HUBaseRouterProtocol>{
    
    @protected
    Class _splashScreenController;
    Class _baseNavController;
    Class _selectChannelController;
    Class _feedsController;
    Class _itemDetailsController;
}


#pragma mark - CREATION & CONFIGURATION

+ (instancetype)sharedRouter;
- (void)configService;


#pragma mark - HUBaseRouterProtocol IMP
// Реализация протокола

- (void)performTransitionSegue:(NSString*)nameSegue forScreen:(UIViewController*)screenVC;

- (NSSet <NSString*> *)possibleSeguesForScreen:(UIViewController*)screenVC;
- (BOOL)canPerformSegue:(NSString*)nameSegue forScreen:(UIViewController*)screenVC;


@end

///////////////////////////////////////////////////////////////////////////
/// ИМПОРТ КАТЕГОРИИ с кастомными переходами///
///////////////////////////////////////////////////////////////////////////

#import "HURSSTwirlRouter+CustomSegues.h"

///////////////////////////////////////////////////////////////////////////

