//
//  HUSelectRSSChannelView.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSelectRSSChannelView.h"

#import "HURSSTwirlStyle.h"
#import "Masonry.h"

#import "HURSSChannelTextFieldManager.h"
#import "HURSSChannelViewConfigurator.h"
#import "HURSSChannelViewAnimator.h"

//TODO: Запилить кэширование названия канала


@implementation HUSelectRSSChannelView{
    
    // Дополнительные диалоги
    CZPickerView *_channelPickerView;
    URBNAlertViewController *_obtainFeedsAlertVC;
    
    // Названия каналов для пикера
    NSArray <NSString*> *_pickerChannelNames;
    
    UITapGestureRecognizer *_keyboardHideGesture;
    NSTimer *_keyboardHideTimer;
    
    CGFloat _maxYShowChannelButtonPosition;
    
    // Стили
    id <HURSSStyleProtocol> _presentStyle;
    id <HURSSTextFieldManagerInterface> _textFieldManager;
    id <HURSSChannelViewConfiguratorInterface> _presentConfigurator;
    HURSSChannelViewAnimator *_presentAnimator;
}

#pragma mark - Initialization

- (instancetype)init{
    if(self = [super init]){
        
        // Инжектировать зависимости
        [self injectDependencies];
        
        // Установить цвет бэкграунда
        UIColor *selectChannelBackColor = [_presentStyle selectChannelScreenColor];
        [self setBackgroundColor:selectChannelBackColor];
    }
    return self;
}

+ (instancetype)createChannelView{
    
    HUSelectRSSChannelView *channelView = [HUSelectRSSChannelView new];
    return channelView;
}


#pragma mark - Dependencies

/// Инжектировать зависимости
- (void)injectDependencies{
    _presentStyle = [HURSSTwirlStyle sharedStyle];
    _textFieldManager = [HURSSChannelTextFieldManager createManagerForRootView:self];
    _presentConfigurator = [HURSSChannelViewConfigurator createConfiguratorForRootView:self withStyler:_presentStyle];
    _presentAnimator = [HURSSChannelViewAnimator createAnimatorForRootView:self withStyler:_presentStyle withConfigurer:_presentConfigurator];
}


#pragma mark - Config UI Elements

- (void)configurationAllStartedViews{
    
    self.channelContentView = [_presentConfigurator createContentScrollView];
    self.enterChannelLabel = [_presentConfigurator createEnterChannelLabel];
    self.channelTextField = [_presentConfigurator createChannelTextField];
    self.selectSuggestedLabel = [_presentConfigurator createSelectSuggestedLabel];
    self.showChannelButton = [_presentConfigurator createShowChannelButton];
    self.feedsButton = [_presentConfigurator createGetFeedsButton];
}


#pragma mark - Setters

/// Установить в интерфейс отображение ссылку канала (устанавливает в текстовое поле)
- (void)showChannelURLLink:(NSURL*)channelURL{
    
    NSString *channelLinkString = channelURL.absoluteString;
    [self.channelTextField setText:channelLinkString];
}

- (void)showChannelAlias:(NSString*)channelAlias{
    [self.channelAliasTextField setText:channelAlias];
}


#pragma mark - SET BUTTONs HANDLER's

/// Установить обработчик для кнопки "СМОТРЕТЬ" (должен показать список каналов)
- (void)setShowChannelHandler:(SEL)actionHandler withTarget:(id)actionTarget{
    [self.showChannelButton setTouchHandler:actionHandler toTarget:actionTarget];
}

/// Установить обработчик для кнопки "ПОКАЗАТЬ" (должен перейти к отображению новостей)
- (void)setGetFeedsHandler:(SEL)actionHandler withTarget:(id)actionTarget{
    [self.feedsButton setTouchHandler:actionHandler toTarget:actionTarget];
}


#pragma mark - SELECT CHANNEL Dialog -

/**
    @abstract Показать пикер со списком каналов
    @discussion
    Использует специальный пикер CZPickerView, заполняет его с помощью dataSource - названиями каналов. Показывает 2 кнопки : "Отмена"/"Выбрать".
    С помощью вспомогательного протокола и делегирования - возвращает презентеру информацию о том, какой именно канал выбрал пользователь.
 
    @note Использует CZPickerView, чем создает дополнительную зависимость
 
    @param channelNames       Список названий каналов
    @param selDelegate       Делегат-адаптер для события выбора CZPickerView (через него возвращает информацию о выбранном канале)
 */
- (void)showChannelWithNames:(NSArray<NSString*>*)channelNames withSelectionDelegate:(id<HURSSChannelSelectionDelegate>)selDelegate{
    
    // Устанавливает делегата и источник данных пикера
    _pickerChannelNames = channelNames;
    self.selectionDelegate = selDelegate;
    
    // Создает пикер
    CZPickerView *channelPickerView = [_presentConfigurator createChannelsPickerView];
    
    // Установить источник данных и делегат
    channelPickerView.dataSource = self;
    channelPickerView.delegate = self;
    
    // Показать пикер
    [channelPickerView show];
    
    // Запомнить вьюшку пикера
    _channelPickerView = channelPickerView;
}

#pragma mark - CZPickerViewDataSource

/// Количество рядов в пикере (столько же, сколько и каналов)
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return _pickerChannelNames.count;
}

/// Возвращает строку для конкретного ряда пикера (название канала)
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    
    NSString *channelName = _pickerChannelNames[row];
    return channelName;
}

#pragma mark - CZPickerViewDelegate

/// Если пользователь выбирает кнопку "Выбрать" - передает делегату HURSSChannelSelectionDelegate индекс выбранного канала
- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    
    // Передать информацию делегату, если имеется
    if(self.selectionDelegate && [self.selectionDelegate conformsToProtocol:@protocol(HURSSChannelSelectionDelegate)] && [self.selectionDelegate respondsToSelector:@selector(didSelectedChannelWithIndex:)]){
        
        [self.selectionDelegate didSelectedChannelWithIndex:row];
    }
    
    // Обнуляет делегата и источник данных
    _pickerChannelNames = nil;
    self.selectionDelegate = nil;
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    
    // Обнуляет делегата и источник данных
    _pickerChannelNames = nil;
    self.selectionDelegate = nil;
}


#pragma mark - SELECT Obtatining FEEDS Dialog -

/**
    @abstract Показать алерт с запросом на получение новостей
    @discussion
    Когда пользователь выбирает канал - ему нужно показать диалог - получить ли новости данного канала сразу? Если пользователь выбирает "Да" - следует на презентере перейти к показу новостей.
 
    Показывает 2 кнопки - "Да" и "Нет".
    
    @note Использует URBNAlertViewController, чем создает дополнительную зависимость
    @note НЕ назначает сразу обработчик. Обработчик кнопки "Да" - назначается с помощью отдельного метода
 
    @param channelName       Название канала, для которого запрашивается получение новостей
 */
- (void)showObtainingFeedsAlertForChannelName:(NSString*)channelName{
    
    // Создать алерт-контроллер
    URBNAlertViewController *obtainFeedsAlertVC = [_presentConfigurator createObtainingFeedsAlertWithChannelName:channelName];
    
    // Показать алерт
    [obtainFeedsAlertVC show];
    
    // Запомнить объект алерта
    _obtainFeedsAlertVC = obtainFeedsAlertVC;
}

/// Установить обработчик для алерта на получение новостей
- (void)setObtainingFeedsAlertHandler:(SEL)actionHandler withTarget:(id)actionTarget{
    
    NSArray <URBNAlertAction*>*actions = _obtainFeedsAlertVC.alertConfig.actions;
    URBNAlertAction *obtainingAction = actions[1];
    
    __weak __block typeof(self) weakTarget = actionTarget;
    [obtainingAction setCompletionBlock:^(URBNAlertAction *action) {
        __strong __block typeof(weakTarget) strongTarget = weakTarget;
        
        [strongTarget performSelector:actionHandler withObject:nil afterDelay:0.f];
    }];
}

- (void)updateUIWhenEnteredChannelURLValidate:(BOOL)passValidate{
    
    if(passValidate){
        self.channelTextField.textColor = [UIColor darkGrayColor];
        self.feedsButton.enabled = YES;
        
        [_presentAnimator performCreationAliasTextField];
        
    }else{
        self.channelTextField.textColor = [_presentStyle channelTextFieldTextColor];
        self.feedsButton.enabled = NO;
        
        [_presentAnimator performDestroyAliasTextField];
    }
}

- (void)createChannelAliasTextField{
    
    HURSSChannelTextField *channelAliasTextField = [_presentConfigurator createChannelAliasTextField];
    self.channelAliasTextField = channelAliasTextField;
    
    [_textFieldManager refreshObserving];
    
    [_presentConfigurator configSecondLocationSuggestedLabel];

    [self layoutIfNeeded];
    
    [_presentAnimator performAnimateFallAliasTextFieldWithCompletion:nil];
}

- (void)destroyChannelAliasTextField{
    
    if(self.addChannelButton){
        [self destroyChannelAddButton];
    }
    
    [_presentAnimator performAnimateMoveAwayAliasTextFieldWithCompletion:^{
        
        [self.channelAliasTextField removeFromSuperview];
        self.channelAliasTextField = nil;
    }];
    
}


- (void)updateUIWhenEnteredChannelAliasValidate:(BOOL)passValidate{
    
    if(passValidate){
        
        [_presentAnimator performCreationChannelAddButton];
        
    }else{
        
        [_presentAnimator performDestroyChannelAddButton];
    }
}

- (void)createChannelAddButton{
    
    HURSSChannelButton *addChannelButton = [_presentConfigurator createChannelAddButton];
    self.addChannelButton = addChannelButton;
    
    [_presentConfigurator configThirdLocationSuggestedLabel];
    [self layoutIfNeeded];
    
    [_presentAnimator performAnimateFallChannelAddButtonWithCompletion:nil];
}

- (void)destroyChannelAddButton{
    
    [_presentAnimator performAnimateMoveAwayChannelAddButtonWithCompletion:^{
        
        [self.addChannelButton removeFromSuperview];
        self.addChannelButton = nil;
    }];
}

- (void)updateContentSizeWithLayout:(BOOL)needLayout{
    
    CGFloat maxYContentPosition = CGRectGetMaxY(self.showChannelButton.frame);
    CGFloat minYBottomButtonPosition = CGRectGetMinY(self.feedsButton.frame);
    CGFloat screenSizeheight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat newContentHeight = 0.f;
    if((maxYContentPosition + 20.f) >= minYBottomButtonPosition){
        // увеличить контент сайз
        
        CGFloat diffContentPositions = (maxYContentPosition + 20.f) - minYBottomButtonPosition;
        newContentHeight = screenSizeheight + diffContentPositions + 2.f;
    }else{
        newContentHeight = screenSizeheight + 2.f;
    }
    
    CGSize newContentSize = CGSizeMake(self.channelContentView.contentSize.width, newContentHeight);
    [self.channelContentView setContentSize:newContentSize];
    
    
    [_presentConfigurator configPresentLocationFeedsButton];
    
    if(needLayout){
        [self layoutIfNeeded];
    }
}


- (HURSSChannelTextFieldType)getChannelTextFieldType:(HURSSChannelTextField*)channelTextField{
    
    HURSSChannelTextFieldType channelTextFieldType = HURSSChannelUnrecognizedFieldType;
    
    BOOL isEnterURLTextField = [self.channelTextField isEqual:channelTextField];
    BOOL isAliasTextField = [self.channelAliasTextField isEqual:channelTextField];
    
    if(isEnterURLTextField){
        channelTextFieldType = HURSSChannelEnterURLFieldType;
    }else if(isAliasTextField){
        channelTextFieldType = HURSSChannelAliasFieldType;
    }
    
    return channelTextFieldType;
}

- (void)showKeyboardActionsWithDuration:(NSTimeInterval)animationDuration withKeyboardSize:(CGSize)keyboardSize withChannelFieldType:(HURSSChannelTextFieldType)channelFieldType withCompletionBlock:(dispatch_block_t)keyboardActionCompletion{
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        UIEdgeInsets channelViewContentInset = UIEdgeInsetsMake(0.f, 0.f, keyboardSize.height, 0.f);
        [self.channelContentView setContentInset:channelViewContentInset];
        [self.channelContentView setScrollIndicatorInsets:channelViewContentInset];
        
    } completion:^(BOOL finished) {
        // Добавить тап и таймер
        keyboardActionCompletion();
    }];
}

- (void)hideKeyboardActionsWithDuration:(NSTimeInterval)animationDuration  withChannelFieldType:(HURSSChannelTextFieldType)channelFieldType withCompletionBlock:(dispatch_block_t)keyboardActionCompletion{
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        UIEdgeInsets channelViewContentInset = UIEdgeInsetsZero;
        [self.channelContentView setContentInset:channelViewContentInset];
        [self.channelContentView setScrollIndicatorInsets:channelViewContentInset];
        
    } completion:^(BOOL finished) {
        // Убрать тап и таймер
        keyboardActionCompletion();
    }];
}


- (void)hideKeyboard{
    
    [_textFieldManager hideKeyboard];
}


@end

