//
//  HURSSChannelViewConfigurator.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 21.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
    @protocol HURSSChannelViewConfiguratorInterface
    @author HuktoDev
    @updated 23.04.2016
    @abstract Интерфейс для конфигуратора вьюшки SelectChannel-экрана
    @discussion
    Предоставляет интерфейс для объекта HURSSChannelViewConfigurator, выступающего в роли конфигуратора вьюшки.
    <b> Основные задачи конфигуратора : </b>
    <ol type="a">
        <li> Создает сабвьюшки </li>
        <li> Задает местоположения сабвьюшек </li>
        <li> Меняет UI, в зависимости от некоторых состояний  </li>
    </ol>
 
    @see 
    HURSSChannelViewConfigurator \n
    HUSelectRSSChannelView \n
 */
@protocol HURSSChannelViewConfiguratorInterface <NSObject>

@required

#pragma mark - Config BACKGROUND
// Конфигурирование фона

- (void)configBackground;


#pragma mark - CREATE UI ELEMENTS -
// Конструкторы всех сабвьюшек

#pragma mark Create SCROLL
- (UIScrollView*)createContentScrollView;

#pragma mark - Create LABELs
- (UILabel*)createEnterChannelLabel;
- (UILabel*)createSelectSuggestedLabel;

#pragma mark - Create TEXTFIELDs
- (HURSSChannelTextField*)createChannelTextField;
- (HURSSChannelTextField*)createChannelAliasTextField;

#pragma mark - Create BUTTONs
- (HURSSChannelButton*)createShowChannelButton;
- (HURSSChannelButton*)createGetFeedsButton;
- (HURSSChannelButton*)createChannelAddButton;
- (HURSSChannelButton*)createChannelRemoveButton;

#pragma mark Create CZPicker
- (CZPickerView*)createChannelsPickerView;

#pragma mark - Create URBNAlertViewController
- (URBNAlertViewController*)createObtainingFeedsAlertWithChannelName:(NSString*)channelName;
- (URBNAlertViewController*)createChannelAlertWithPostAction:(HURSSChannelActionType)channelActionType WithChannelName:(NSString*)channelName andWithURL:(NSURL*)channelURL;
- (URBNAlertViewController*)createFeedsRecvievingAlertWithChannelname:(NSString*)channelName withErrorDescription:(NSString*)feedsErrorDescription withOfflineFeedsRequest:(BOOL)needOfflineRequest;


#pragma mark - CONFIG LOCATIONs -
// Конфигурировать размер и местоположение сабвьюшек

#pragma mark CONFIG Label
- (void)configPresentLocationEnterChannelLabel;

- (void)configBaseLocationSuggestedLabel;
- (void)configSecondLocationSuggestedLabel;
- (void)configThirdLocationSuggestedLabel;
- (void)configFourLocationSuggestedLabel;

#pragma mark - CONFIG TextFields
- (void)configPresentLocationChannelTextField;

- (void)configPresentLocationAliasTextField;
- (void)configCreatedLocationAliasTextField;
- (void)configDestroyedLocationAliasTextField;

#pragma mark - CONFIG Buttons
- (void)configPresentLocationShowChannelButton;

- (void)configPresentLocationChannelAddButton;
- (void)configCreatedLocationChannelAddButton;
- (void)configDestroyedLocationChannelAddButton;

- (void)configPresentLocationChannelRemoveButton;
- (void)configCreatedLocationChannelRemoveButton;
- (void)configDestoyedLocationChannelRemoveButton;

- (void)configPresentLocationFeedsButton;
- (void)configWaitingLocationFeedsButton;

#pragma mark - CONFIG State's
// Конфигурировать разные состояния Ui

- (void)configGetFeedsDisable;
- (void)configGetFeedsEnable;

- (void)configChangeChannelButtonToAddMode;
- (void)configChangeChannelButtonToModifyMode;


#pragma mark - CONFIG for Keyboard
/// Отступ для клавиатуры

- (void)configKeyboardWithInsets:(UIEdgeInsets)contentInset;
    
@end


/**
    @class HURSSChannelViewConfigurator
    @author HuktoDev
    @updated 23.04.2016
    @abstract Является реализацией протокола конфигуратора HURSSChannelViewConfiguratorInterface для SelectScreen-вьюшки
    @discussion
    Реализует все методы данного протокола (по идее, можно подставлять другие конфигураторы (чем осуществляется инверсия зависимостей))
    Кроме всего, в своей деятельность использует 2 объекта :
    <ol type="a">
        <li> Объект стилизатора (возвращает стили различных вьюшек) </li>
        <li> Фабрику правил интерфейса (благодаря ей - задатся разые местоположения) </li>
    </ol>
 
    @note Имеет удобный конструктор
 */
@interface HURSSChannelViewConfigurator : NSObject <HURSSChannelViewConfiguratorInterface>

+ (instancetype)createConfiguratorForRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler withConstraintsFactory:(id<HURSSChannelViewPositionRulesInterface>)viewRules;


@end







