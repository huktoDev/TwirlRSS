//
//  HURSSChannelViewConfigurator.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 21.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelViewConfigurator.h"


#import "Masonry.h"

@implementation HURSSChannelViewConfigurator{
    
    HUSelectRSSChannelView  *_configurationChannelView;
    
    UIScrollView            *_channelContentView;
    
    UILabel                 *_enterChannelLabel;
    UILabel                 *_selectSuggestedLabel;
    
    HURSSChannelTextField   *_channelTextField;
    HURSSChannelTextField   *_channelAliasTextField;
    HURSSChannelButton      *_addChannelButton;
    HURSSChannelButton      *_showChannelButton;
    HURSSChannelButton      *_feedsButton;
    
    CZPickerView            *_channelPickerView;
    URBNAlertViewController *_obtainFeedsAlertVC;
    
    
    id <HURSSStyleProtocol> _presentStyle;
}


#pragma mark - Construction & Destroying

- (instancetype)initWithRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSStyleProtocol>)viewStyler{
    if(self = [super init]){
        _configurationChannelView = channelRootView;
        _presentStyle = viewStyler;
    }
    return self;
}

/// Конструктор для конфигуратора
+ (instancetype)createConfiguratorForRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSStyleProtocol>)viewStyler{
    
    HURSSChannelViewConfigurator *newManager = [[HURSSChannelViewConfigurator alloc] initWithRootView:channelRootView withStyler:viewStyler];
    return newManager;
}


#pragma mark - Config UI Elements

- (UIScrollView*)createContentScrollView{
    
    UIScrollView *contentScrollView = [UIScrollView new];
    
    [_configurationChannelView addSubview:contentScrollView];
    _channelContentView = contentScrollView;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    screenSize.height += 2.f;
    
    [contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [contentScrollView setContentSize:screenSize];
    
    return contentScrollView;
}

/// Конфигурирует верхний лейбл ("введите URL")
- (UILabel*)createEnterChannelLabel{
    
    UILabel *enterChannelLabel = [UILabel new];
    enterChannelLabel.numberOfLines = 2;
    enterChannelLabel.font = [UIFont systemFontOfSize:24.f];
    enterChannelLabel.text = @"Введите URL вашего\nканала :";
    enterChannelLabel.textAlignment = NSTextAlignmentCenter;
    
    [_channelContentView addSubview:enterChannelLabel];
    
    [enterChannelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.leading.equalTo(_channelContentView.mas_leading).with.offset(20.f);
        make.top.equalTo(_channelContentView.mas_top).with.offset(60.f);
        make.height.mas_equalTo(60.f);
    }];
    
    _enterChannelLabel = enterChannelLabel;
    return enterChannelLabel;
}

/// Конфигурирует текст филд для ввода  канала
- (HURSSChannelTextField*)createChannelTextField{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    HURSSChannelTextField *channelTextField = [HURSSChannelTextField new];
    
    // Плейсхолдер текста
    
    UIImage *searchIconImage = [UIImage imageNamed:@"SearchIcon.png"];
    [channelTextField setImage:searchIconImage];
    
    channelTextField.text = @"http://";
    
    [_channelContentView addSubview:channelTextField];
    
    [channelTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.top.equalTo(_enterChannelLabel.mas_bottom).with.offset(20.f);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
    
    _channelTextField = channelTextField;
    return channelTextField;
}

/// Конфигурирует лейбл "Выберите из предложенных"
- (UILabel*)createSelectSuggestedLabel{
    
    UILabel *selectSuggestedLabel = [UILabel new];
    selectSuggestedLabel.numberOfLines = 3;
    selectSuggestedLabel.font = [UIFont systemFontOfSize:24.f];
    selectSuggestedLabel.text = @"или\nвыберите из\nпредложенных :";
    selectSuggestedLabel.textAlignment = NSTextAlignmentCenter;
    
    [_channelContentView addSubview:selectSuggestedLabel];
    
    [selectSuggestedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.top.equalTo(_channelTextField.mas_bottom).with.offset(20.f);
        make.height.mas_equalTo(90.f);
    }];
    
    _selectSuggestedLabel = selectSuggestedLabel;
    return selectSuggestedLabel;
}

/// Конфигурирует кнопку "СМОТРЕТЬ" (выбор  предпочитаемых каналов)
- (HURSSChannelButton*)createShowChannelButton{
    
    const CGFloat channelButtonSize = [_presentStyle channelUIElementHeight];
    
    HURSSChannelButton *showChannelButton = [HURSSChannelButton new];
    [showChannelButton setTitle:@"СМОТРЕТЬ" forState:UIControlStateNormal];
    
    [_channelContentView addSubview:showChannelButton];
    
    [showChannelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.top.equalTo(_selectSuggestedLabel.mas_bottom).with.offset(20.f);
        make.width.equalTo(_channelTextField.mas_width);
        make.height.mas_equalTo(channelButtonSize);
    }];
    
    _showChannelButton = showChannelButton;
    return showChannelButton;
}

/// Конфигурирует кнопку "ПОЛУЧИТЬ" (получить новости выбранного канала)
- (HURSSChannelButton*)createGetFeedsButton{
    
    //const CGFloat feedsButtonSize = [_presentStyle channelUIElementHeight];
    
    HURSSChannelButton *feedsButton = [HURSSChannelButton new];
    [feedsButton setTitle:@"ПОЛУЧИТЬ" forState:UIControlStateNormal];
    feedsButton.enabled = NO;
    
    [_channelContentView addSubview:feedsButton];
    
    // Пришлось так сделать, т.к почему-то не срабатывало если прикреплять к низу скролл вью
    _feedsButton = feedsButton;
    [self configPresentLocationFeedsButton];
    /*
    CGFloat heightScreen = [UIScreen mainScreen].bounds.size.height;
    
    [feedsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.bottom.equalTo(_channelContentView.mas_top).with.offset(heightScreen - (feedsButtonSize/2.f) - 20.f);
        make.width.equalTo(_showChannelButton.mas_width);
        make.height.mas_equalTo(feedsButtonSize);
    }];
     */
    
    
    return feedsButton;
}

- (CZPickerView*)createChannelsPickerView{
    
    // Создает пикер
    CZPickerView *channelPickerView = [[CZPickerView alloc] initWithHeaderTitle:@"Зарезервированные каналы"
        cancelButtonTitle:@"Отмена"
        confirmButtonTitle:@"Выбрать"];
    
    // Конфигурировать пикер
    channelPickerView.needFooterView = YES;
    channelPickerView.headerBackgroundColor = [_presentStyle secondUseLightColor];
    channelPickerView.headerTitleColor = [UIColor brownColor];
    channelPickerView.confirmButtonBackgroundColor = [_presentStyle secondUseLightColor];
    channelPickerView.confirmButtonNormalColor = [UIColor brownColor];
    
    _channelPickerView = channelPickerView;
    return channelPickerView;
}

- (URBNAlertViewController*)createObtainingFeedsAlertWithChannelName:(NSString*)channelName{
    
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
    
    _obtainFeedsAlertVC = obtainFeedsAlertVC;
    return obtainFeedsAlertVC;
}


- (HURSSChannelTextField*)createChannelAliasTextField{
    
    HURSSChannelTextField *channelAliasTextField = [HURSSChannelTextField new];
    channelAliasTextField.placeholder = @"Как назвать канал?";
    
    UIImage *channelAliasImage = [UIImage imageNamed:@"RSSIconFill.png"];
    [channelAliasTextField setImage:channelAliasImage];
    
    [_channelContentView insertSubview:channelAliasTextField belowSubview:_channelTextField];
    _channelAliasTextField = channelAliasTextField;
    
    [self configCreatedLocationAliasTextField];
    /*
    [channelAliasTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.centerY.equalTo(_channelTextField.mas_centerY);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
     */
    
    
    return channelAliasTextField;
}

- (HURSSChannelButton*)createChannelAddButton{
    
    //const CGFloat channelButtonSize = [_presentStyle channelUIElementHeight];
    
    HURSSChannelButton *addChannelButton = [HURSSChannelButton new];
    [addChannelButton setTitle:@"ДОБАВИТЬ" forState:UIControlStateNormal];
    
    [_channelContentView insertSubview:addChannelButton belowSubview:_channelAliasTextField];
    _addChannelButton = addChannelButton;
    
    [self configCreatedLocationChannelAddButton];
    /*
    [addChannelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.centerY.equalTo(_channelAliasTextField.mas_centerY);
        make.width.equalTo(_channelAliasTextField.mas_width);
        make.height.mas_equalTo(channelButtonSize);
    }];
     */
    
    return addChannelButton;
}

- (void)configPresentLocationAliasTextField{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_channelAliasTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.top.equalTo(_channelTextField.mas_bottom).with.offset(20.f);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}

- (void)configCreatedLocationAliasTextField{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_channelAliasTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.centerY.equalTo(_channelTextField.mas_centerY);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}

- (void)configDestroyedLocationAliasTextField{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_channelAliasTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView).with.offset(- CGRectGetWidth(_configurationChannelView.frame));
        make.top.equalTo(_channelTextField.mas_bottom).with.offset(20.f);
        make.width.equalTo(_channelTextField.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}


- (void)configPresentLocationChannelAddButton{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_addChannelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.top.equalTo(_channelAliasTextField.mas_bottom).with.offset(20.f);
        make.width.equalTo(_channelAliasTextField.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}

- (void)configCreatedLocationChannelAddButton{
    
    const CGFloat channelButtonSize = [_presentStyle channelUIElementHeight];
    
    [_addChannelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.centerY.equalTo(_channelAliasTextField.mas_centerY);
        make.width.equalTo(_channelAliasTextField.mas_width);
        make.height.mas_equalTo(channelButtonSize);
    }];
}

- (void)configDestroyedLocationChannelAddButton{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_addChannelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView).with.offset(- CGRectGetWidth(_configurationChannelView.frame));
        make.top.equalTo(_channelAliasTextField.mas_bottom).with.offset(20.f);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}

- (void)configBaseLocationSuggestedLabel{
    
    [_selectSuggestedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.top.equalTo(_channelTextField.mas_bottom).with.offset(20.f);
        make.height.mas_equalTo(90.f);
    }];
}

- (void)configSecondLocationSuggestedLabel{
    
    [_selectSuggestedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.top.equalTo(_channelAliasTextField.mas_bottom).with.offset(20.f);
        make.height.mas_equalTo(90.f);
    }];
}

- (void)configThirdLocationSuggestedLabel{
    
    [_selectSuggestedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.top.equalTo(_addChannelButton.mas_bottom).with.offset(20.f);
        make.height.mas_equalTo(90.f);
    }];
}

- (void)configPresentLocationFeedsButton{
    
    const CGFloat feedsButtonSize = [_presentStyle channelUIElementHeight];
    const CGSize currentContentSize = _channelContentView.contentSize;
    const CGFloat currentContentHeight = currentContentSize.height;
    
    [_feedsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.bottom.equalTo(_channelContentView.mas_top).with.offset(currentContentHeight - (feedsButtonSize/2.f) - 20.f);
        make.width.equalTo(_showChannelButton.mas_width);
        make.height.mas_equalTo(feedsButtonSize);
    }];
}






@end
