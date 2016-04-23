//
//  HURSSChannelViewAssembly.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HUSelectRSSChannelView.h"

#import "HURSSChannelViewConstraintsFactory.h"
#import "HURSSChannelViewStyler.h"
#import "HURSSChannelTextFieldManager.h"
#import "HURSSChannelViewConfigurator.h"
#import "HURSSChannelViewAnimator.h"


/**
    @class HURSSChannelViewAssembly 
    @author HuktoDev
    @updated 23.04.2016
    @abstract Класс-Фабрика для View-модуля SelectChannel-экрана
    @discussion
    Умеет создавать :
    <ol type="a">
        <li> Корневую вьюшку для Select-Channel экрана </li>
        <li> Менеджер текстовых полей </li>
        <li> Стилизатор вьюшки </li>
        <li> Конфигуратора вьюшки </li>
        <li> Аниматор вьюшки </li>
        <li> Фабрика констрейнтов вьюшки </li>
    </ol>
 
    @see
    HUSelectRSSChannelView \n
    
    HURSSTextFieldManagerInterface \n
    HURSSChannelViewStylizationInterface \n
    HURSSChannelViewConfiguratorInterface \n
    HURSSChannelViewAnimatorInterface \n
    HURSSChannelViewPositionRulesInterface \n
 */
@interface HURSSChannelViewAssembly : NSObject

#pragma mark - DEFAULT ASSEMBLY
+ (instancetype)defaultAssemblyForChannelView;


#pragma mark - CREATE ROOT View

// Создание корневой вьюшки
- (HUSelectRSSChannelView*)createSelectChannelView;


#pragma mark - ACCESSORs Modules
// Модули вью-пакета
- (id <HURSSTextFieldManagerInterface>)getTextFieldManager;
- (id <HURSSChannelViewStylizationInterface>)getViewStyler;
- (id <HURSSChannelViewConfiguratorInterface>)getViewConfigurator;
- (id <HURSSChannelViewAnimatorInterface>)getViewAnimator;
- (id <HURSSChannelViewPositionRulesInterface>)getConstraintsFactory;


@end



