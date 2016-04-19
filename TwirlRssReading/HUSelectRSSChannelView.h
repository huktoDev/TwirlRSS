//
//  HUSelectRSSChannelView.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HURSSChannelTextField.h"
#import "HURSSChannelButton.h"
#import "CZPicker.h"
#import "URBNAlert.h"


/**
    @protocol HURSSChannelSelectionDelegate
    @author HuktoDev
    @updated 20.04.2016
    @abstract Делегат для передачи информацию презентеру о выбранном канале
 */
@protocol HURSSChannelSelectionDelegate <NSObject>

@required
- (void)didSelectedChannelWithIndex:(NSUInteger)indexChannel;

@end


/**
    @class HUSelectRSSChannelView
    @author HuktoDev
    @updated 20.04.2016
    @abstract Корневая вьюшка SelectChannel-экрана
    @discussion
    Вьюшка VIPER-модуля SelectChannel. Предоставляет удобный интерфейс для различных реализаций SelectChannel-вьюшки.
 
    <h4> Интерфейс содержит ряд возможностей : </h4>
    <ol type="a">
        <li> Конфигурирует и запоминает вьюшки свойствами </li>
        <li> Дает удобные мутаторы для некоторых свойств </li>
        <li> Установить обработчики разных событий </li>
        <li> Показывает разные важные диалоги </li>
    </ol>
 
    @see
    HUSelectRSSChannelPresenter \n
 */
@interface HUSelectRSSChannelView : UIView <CZPickerViewDataSource, CZPickerViewDelegate>


#pragma mark - SelectChannel Subviews
// Сабвьюшки HUSelectRSSChannelView

@property (strong, nonatomic) UILabel *enterChannelLabel;
@property (strong, nonatomic) UILabel *selectSuggestedLabel;

@property (strong, nonatomic) HURSSChannelTextField *channelTextField;
@property (strong, nonatomic) HURSSChannelButton *showChannelButton;
@property (strong, nonatomic) HURSSChannelButton *feedsButton;



#pragma mark - Initialization
+ (instancetype)createChannelView;


#pragma mark - Dependencies
// Инжектировать зависимости

- (void)injectDependencies;


#pragma mark - Config UI Elements
// Конфигурировать UI

- (UILabel*)configEnterChannelLabel;
- (HURSSChannelTextField*)configChannelTextField;
- (UILabel*)configSelectSuggestedLabel;
- (HURSSChannelButton*)configShowChannelButton;
- (HURSSChannelButton*)configGetFeedsButton;


#pragma mark - Setters
// Установить URL канала на интерфейс

- (void)showChannelURLLink:(NSURL*)channelURL;


#pragma mark - SET BUTTONs HANDLER's
// Установить обработчики кнопок

- (void)setShowChannelHandler:(SEL)actionHandler withTarget:(id)actionTarget;
- (void)setGetFeedsHandler:(SEL)actionHandler withTarget:(id)actionTarget;


#pragma mark - SELECT CHANNEL Dialog
// Диалог выбора канала

@property (weak, nonatomic) id<HURSSChannelSelectionDelegate> selectionDelegate;
- (void)showChannelWithNames:(NSArray<NSString*>*)channelNames withSelectionDelegate:(id<HURSSChannelSelectionDelegate>)selDelegate;


#pragma mark - SELECT Obtatining FEEDS Dialog
// Диалог получения новостей

- (void)showObtainingFeedsAlertForChannelName:(NSString*)channelName;
- (void)setObtainingFeedsAlertHandler:(SEL)actionHandler withTarget:(id)actionTarget;


@end
