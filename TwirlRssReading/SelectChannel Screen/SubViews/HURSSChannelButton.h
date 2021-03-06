//
//  HURSSChannelButton.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    @class HURSSChannelButton
    @author HuktoDev
    @updated 19.04.2016
    @abstract Кнопка экрана выбора канала
    @discussion
    На SelectChannel-экране имеются 2 кнопки, у этих кнопок общий вид, и общая реакция на касание. Поэтому решено было сделать подкласс.
 
    Кроме всего, кнопка имеет встроенный индикатор ожидания
 */
@interface HURSSChannelButton : UIButton


#pragma mark - Construction
// Создание кнопки

+ (instancetype)channelButtonWithRootView:(HUSelectRSSChannelView*)rootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler;



#pragma mark - Touch Event
/// Назначить обработчик нажатия (уже кнопка сама определяет, когда его обрабатывать (тач даун или тач аут))
- (void)setTouchHandler:(SEL)actionHandler toTarget:(id)actionTarget;


#pragma mark - Waiting Indicator
// Активити индикатор

- (void)startWaitingIndicator;
- (void)endWaitingIndicator;


@end
