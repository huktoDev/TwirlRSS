//
//  HURSSChannelTextFieldManager.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 21.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HUSelectRSSChannelView.h"
#import "HURSSChannelTextField.h"


/**
    @protocol HURSSTextFieldManagerInterface
    @author HuktoDev
    @updated 25.04.2016
    @abstract Интерфейс для менеджера текстовых полей
    @discussion
    Должен реализовывать собственное наблюдение за текстовыми полями, и уметь скрывать клавиатуру. И уметь ловить события изменения текста
 */
@protocol HURSSTextFieldManagerInterface <NSObject>

@required

- (void)refreshObserving;
- (void)hideKeyboard;

- (void)startCatchChangeTextEvents;
- (void)stopCatchChangeTextEvents;

@optional

- (void)startObserving;
- (void)endObserving;


@end


/**
    @class HURSSChannelTextFieldManager
    @author HuktoDev
    @updated 21.04.2016
    @abstract Объект-менеджер текстовых полей вьюшки SelectChannel-экрана
    @discussion
    Выполняет задачу менеджмента текстовых полей :
    <ol type="a">
        <li> Перенаправляет события появление клавиатуры </li>
        <li> Назначает тап-жест для сокрытия клавиатуры </li>
        <li> Назначает таймер для сокрытия клавиатуры </li>
        <li> Следит за событиями изменения фокуса текстовых полей, изменений текста, и изменений позиции курсора </li>
    </ol>
 */
@interface HURSSChannelTextFieldManager : NSObject <HURSSTextFieldManagerInterface>

#pragma mark - Constuctor
+ (instancetype)createManagerForRootView:(HUSelectRSSChannelView*)channelRootView;


#pragma mark - Observing keyboard
// Наблюдение за клавиатурой

- (void)startObserving;
- (void)endObserving;
- (void)refreshObserving;


#pragma mark - Text CHANGED Actions
// События изменения текста

- (void)startCatchChangeTextEvents;
- (void)stopCatchChangeTextEvents;


#pragma mark - HIDE Keyboard
// Скрывать клавиатуру

- (void)hideKeyboard;


@end

