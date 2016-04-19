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


@implementation HUSelectRSSChannelView{
    
    // Дополнительные диалоги
    CZPickerView *_channelPickerView;
    URBNAlertViewController *_obtainFeedsAlertVC;
    
    // Названия каналов для пикера
    NSArray <NSString*> *_pickerChannelNames;
    
    // Стили
    id<HURSSStyleProtocol> _presentStyle;
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
}


#pragma mark - Config UI Elements

/// Конфигурирует верхний лейбл ("введите URL")
- (UILabel*)configEnterChannelLabel{
    
    UILabel *enterChannelLabel = [UILabel new];
    enterChannelLabel.numberOfLines = 2;
    enterChannelLabel.font = [UIFont systemFontOfSize:24.f];
    enterChannelLabel.text = @"Введите URL вашего\nканала :";
    enterChannelLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:enterChannelLabel];
    
    [enterChannelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.leading.equalTo(self.mas_leading).with.offset(20.f);
        make.top.equalTo(self.mas_top).with.offset(60.f);
        make.height.mas_equalTo(60.f);
        
    }];
    
    self.enterChannelLabel = enterChannelLabel;
    return enterChannelLabel;
}

/// Конфигурирует текст филд для ввода  канала
- (HURSSChannelTextField*)configChannelTextField{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    HURSSChannelTextField *channelTextField = [HURSSChannelTextField new];
    
    // Плейсхолдер текста
    channelTextField.placeholder = @"http://";
    
    [self addSubview:channelTextField];
    
    [channelTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.enterChannelLabel.mas_bottom).with.offset(20.f);
        make.width.equalTo(self.enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
    
    self.channelTextField = channelTextField;
    return channelTextField;
}

/// Конфигурирует лейбл "Выберите из предложенных"
- (UILabel*)configSelectSuggestedLabel{
    
    UILabel *selectSuggestedLabel = [UILabel new];
    selectSuggestedLabel.numberOfLines = 3;
    selectSuggestedLabel.font = [UIFont systemFontOfSize:24.f];
    selectSuggestedLabel.text = @"или\nвыберите из\nпредложенных :";
    selectSuggestedLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:selectSuggestedLabel];
    
    [selectSuggestedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self.enterChannelLabel.mas_width);
        make.top.equalTo(self.channelTextField.mas_bottom).with.offset(20.f);
        make.height.mas_equalTo(90.f);
    }];
    
    self.selectSuggestedLabel = selectSuggestedLabel;
    return selectSuggestedLabel;
}

/// Конфигурирует кнопку "СМОТРЕТЬ" (выбор  предпочитаемых каналов)
- (HURSSChannelButton*)configShowChannelButton{
    
    const CGFloat channelButtonSize = [_presentStyle channelUIElementHeight];
    
    HURSSChannelButton *showChannelButton = [HURSSChannelButton new];
    [showChannelButton setTitle:@"СМОТРЕТЬ" forState:UIControlStateNormal];
    
    [self addSubview:showChannelButton];
    
    [showChannelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.selectSuggestedLabel.mas_bottom).with.offset(20.f);
        make.width.equalTo(self.channelTextField.mas_width);
        make.height.mas_equalTo(channelButtonSize);
    }];
    
    self.showChannelButton = showChannelButton;
    return showChannelButton;
}

/// Конфигурирует кнопку "ПОЛУЧИТЬ" (получить новости выбранного канала)
- (HURSSChannelButton*)configGetFeedsButton{
    
    const CGFloat feedsButtonSize = [_presentStyle channelUIElementHeight];
    
    HURSSChannelButton *feedsButton = [HURSSChannelButton new];
    [feedsButton setTitle:@"ПОЛУЧИТЬ" forState:UIControlStateNormal];
    
    [self addSubview:feedsButton];
    
    [feedsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20.f);
        make.width.equalTo(self.showChannelButton.mas_width);
        make.height.mas_equalTo(feedsButtonSize);
    }];
    
    self.feedsButton = feedsButton;
    return feedsButton;
}


#pragma mark - Setters

/// Установить в интерфейс отображение ссылку канала (устанавливает в текстовое поле)
- (void)showChannelURLLink:(NSURL*)channelURL{
    
    NSString *channelLinkString = channelURL.absoluteString;
    [self.channelTextField setText:channelLinkString];
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
    CZPickerView *channelPickerView = [[CZPickerView alloc] initWithHeaderTitle:@"Зарезервированные каналы"
        cancelButtonTitle:@"Отмена"
        confirmButtonTitle:@"Выбрать"];
    
    // Конфигурировать пикер
    channelPickerView.needFooterView = YES;
    channelPickerView.headerBackgroundColor = [[HURSSTwirlStyle sharedStyle] secondUseLightColor];
    channelPickerView.headerTitleColor = [UIColor brownColor];
    channelPickerView.confirmButtonBackgroundColor = [[HURSSTwirlStyle sharedStyle] secondUseLightColor];
    channelPickerView.confirmButtonNormalColor = [UIColor brownColor];
    
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
    
    // Получить тексты
    NSString *obtainFeedsAlertTitle = @"Получить новости?";
    NSString *obtainFeedsAlertDescription = [NSString stringWithFormat:@"Вами был выбран канал %@. Применить его и получить новости этого RSS-канала?", channelName];
    
    // Инициализировать Alert Controller
    URBNAlertViewController *obtainFeedsAlertVC = [[URBNAlertViewController alloc] initWithTitle:obtainFeedsAlertTitle message:obtainFeedsAlertDescription];
    
    // Установить стили
    URBNAlertStyle *alertStyler = obtainFeedsAlertVC.alertStyler;
    
    alertStyler.blurTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    alertStyler.backgroundColor = [_presentStyle selectChannelScreenColor];
    alertStyler.titleFont = [UIFont systemFontOfSize:24.f];
    alertStyler.messageFont = [UIFont systemFontOfSize:18.f];
    alertStyler.buttonCornerRadius = @([alertStyler.buttonHeight unsignedIntegerValue] / 2.f);
    alertStyler.buttonBackgroundColor = [_presentStyle  channelButtonBackColor];
    alertStyler.buttonTitleColor = [UIColor brownColor];
    
    // Сделать, чтобы по нажатию вне алерта - вьюшка отменялась
    URBNAlertConfig *alertConfig = obtainFeedsAlertVC.alertConfig;
    alertConfig.touchOutsideViewToDismiss = YES;
    
    // Добавить пустые экшены
    [obtainFeedsAlertVC addAction:[URBNAlertAction actionWithTitle:@"Нет" actionType:URBNAlertActionTypeCancel actionCompleted:nil]];
    [obtainFeedsAlertVC addAction:[URBNAlertAction actionWithTitle:@"Да" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    
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



@end

