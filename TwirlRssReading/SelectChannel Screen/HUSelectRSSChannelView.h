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




typedef NS_ENUM(NSUInteger, HURSSChannelActionType) {
    HURSSChannelActionAdd = 1,
    HURSSChannelActionModify,
    HURSSChannelActionDelete
};



typedef NS_ENUM(NSUInteger, HURSSChannelState) {
    HURSSChannelStateImpossible = 0,
    HURSSChannelStatePossibleAdd,
    HURSSChannelStatePossibleModifyDel
};


/**
    @enum HURSSChannelTextFieldType
    @abstract Тип SelectChannel текстового поля
 
    @constant HURSSChannelUnrecognizedFieldType
        Нераспознанное для данного экрана текстовое поле
    @constant HURSSChannelEnterURLFieldType
        Текстовое поле для ввода URL-адреса
    @constant HURSSChannelAliasFieldType
        Текстовое поле для ввода названия канала
 */
typedef NS_ENUM(NSUInteger, HURSSChannelTextFieldType) {
    HURSSChannelUnrecognizedFieldType = 0,
    HURSSChannelEnterURLFieldType,
    HURSSChannelAliasFieldType
};


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

@property (strong, nonatomic) UIScrollView *channelContentView;

@property (strong, nonatomic) UILabel *enterChannelLabel;
@property (strong, nonatomic) UILabel *selectSuggestedLabel;

@property (strong, nonatomic) HURSSChannelTextField *channelTextField;
@property (strong, nonatomic) HURSSChannelTextField *channelAliasTextField;
@property (strong, nonatomic) HURSSChannelButton *addChannelButton;
@property (strong, nonatomic) HURSSChannelButton *deleteChannelButton;
@property (strong, nonatomic) HURSSChannelButton *showChannelButton;
@property (strong, nonatomic) HURSSChannelButton *feedsButton;



#pragma mark - Initialization
+ (instancetype)createChannelView;


#pragma mark - Dependencies
// Инжектировать зависимости

- (void)injectDependencies;


#pragma mark - Config UI Elements
// Конфигурировать UI


- (void)configurationAllStartedViews;


#pragma mark - Type TextFields
// Получить  тип текстового поля

- (HURSSChannelTextFieldType)getChannelTextFieldType:(HURSSChannelTextField*)channelTextField;


#pragma mark - Accessors & Mutators
// Установить URL канала на интерфейс

- (void)showChannelURLLink:(NSURL*)channelURL;
- (void)showChannelAlias:(NSString*)channelAlias;

- (NSURL*)getChannelURLLink;
- (NSString*)getChannelAlias;


#pragma mark - SET BUTTONs HANDLER's
// Установить обработчики кнопок

- (void)setShowChannelHandler:(SEL)actionHandler withTarget:(id)actionTarget;
- (void)setGetFeedsHandler:(SEL)actionHandler withTarget:(id)actionTarget;
- (void)setAddChannelHandler:(SEL)actionHandler withTarget:(id)actionTarget;
- (void)setDeleteChannelHandler:(SEL)actionHandler withTarget:(id)actionTarget;

#pragma mark - SELECT CHANNEL Dialog
// Диалог выбора канала

@property (weak, nonatomic) id<HURSSChannelSelectionDelegate> selectionDelegate;
- (void)showChannelWithNames:(NSArray<NSString*>*)channelNames withSelectionDelegate:(id<HURSSChannelSelectionDelegate>)selDelegate;


#pragma mark - SELECT Obtatining FEEDS Dialog
// Диалог получения новостей

- (void)showObtainingFeedsAlertForChannelName:(NSString*)channelName;
- (void)setObtainingFeedsAlertHandler:(SEL)actionHandler withTarget:(id)actionTarget;

// Добавлен
// Удален
// Изменен
- (void)showAlertPostAction:(HURSSChannelActionType)channelActionType ForChannelName:(NSString*)channelName withURL:(NSURL*)channelURl;

- (void)showFeedsFailRecivingAlertForChannelName:(NSString*)channelName withErrorDescription:(NSString*)feedsErrorDescription;
- (void)setFeedsRepeatAlertHandler:(SEL)actionHandler withTarget:(id)actionTarget;


#pragma mark - UPDATE UI To States
// Обновить UI при разных состояниях

- (void)updateUIWhenEnteredChannelURLValidate:(BOOL)passValidate;
- (void)updateUIWhenChannelChangeState:(HURSSChannelState)channelState;



- (void)createChannelAliasTextField;
- (void)createChannelAddButton;

- (void)destroyChannelAliasTextField;
- (void)destroyChannelAddButton;


- (void)createChannelDeleteButton;
- (void)destroyChannelDeleteButton;



#pragma mark - UPDATE Content Size
// Обновить размер контента

- (void)updateContentSizeWithLayout:(BOOL)needLayout;



#pragma mark - Keyboard SHOW/HIDE
// Работа с клавиатурой

- (void)showKeyboardActionsWithDuration:(NSTimeInterval)animationDuration withKeyboardSize:(CGSize)keyboardSize withChannelFieldType:(HURSSChannelTextFieldType)channelFieldType withCompletionBlock:(dispatch_block_t)keyboardActionCompletion;

- (void)hideKeyboardActionsWithDuration:(NSTimeInterval)animationDuration withKeyboardSize:(CGSize)keyboardSize withChannelFieldType:(HURSSChannelTextFieldType)channelFieldType withCompletionBlock:(dispatch_block_t)keyboardActionCompletion;

- (void)hideKeyboard;


- (void)startFeedsWaiting;
- (void)endFeedsWaitingWithCompletion:(dispatch_block_t)waitingCompletion;


@end



