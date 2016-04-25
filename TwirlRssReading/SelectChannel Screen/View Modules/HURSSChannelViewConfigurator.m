//
//  HURSSChannelViewConfigurator.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 21.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelViewConfigurator.h"

@implementation HURSSChannelViewConfigurator{
    
    // Корневая вьюшка (для которой и существует конфигуратор)
    HUSelectRSSChannelView  *_configurationChannelView;
    
    // UI-элементы SelectChannel-вьюшки
    UIScrollView            *_channelContentView;
    
    UILabel                 *_enterChannelLabel;
    UILabel                 *_selectSuggestedLabel;
    
    HURSSChannelTextField   *_channelTextField;
    HURSSChannelTextField   *_channelAliasTextField;
    HURSSChannelButton      *_addChannelButton;
    HURSSChannelButton      *_deleteChannelButton;
    HURSSChannelButton      *_showChannelButton;
    HURSSChannelButton      *_feedsButton;
    
    CZPickerView            *_channelPickerView;
    URBNAlertViewController *_obtainFeedsAlertVC;
    
    URBNAlertViewController *_channelAlertVC;
    URBNAlertViewController *_feedsNotRecievingAlertVC;
    
    
    // Вспомогательные сервисы - Стилизатор и Фабрика правил интерфейса
    id <HURSSChannelViewStylizationInterface> _presentStyle;
    id <HURSSChannelViewPositionRulesInterface> _constraintsFactory;
}


#pragma mark - Construction & Destroying

/**
    @abstract Инициализатор для конфигуратора
    @discussion
    Для работы конфигуратора - требуется передать 3 параметра :
    @param channelRootView      Корневая вьюшка, для которой создается конфигуратор
    @param viewStyler        Стилизатор вьюшки
    @param viewRules        Правила интерфейса
    @return Готовый конфигуратор
 */
- (instancetype)initWithRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler withConstraintsFactory:(id<HURSSChannelViewPositionRulesInterface>)viewRules{
    
    if(self = [super init]){
        _configurationChannelView = channelRootView;
        _presentStyle = viewStyler;
        _constraintsFactory = viewRules;
    }
    return self;
}

/// Конструктор для конфигуратора (использующий назначенный инициализатор)
+ (instancetype)createConfiguratorForRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler withConstraintsFactory:(id<HURSSChannelViewPositionRulesInterface>)viewRules{
    
    HURSSChannelViewConfigurator *newManager = [[HURSSChannelViewConfigurator alloc] initWithRootView:channelRootView withStyler:viewStyler withConstraintsFactory:viewRules];
    return newManager;
}


#pragma mark - Config BACKGROUND

/// Сконфигурировать фон корневой вьюшки
- (void)configBackground{
    
    UIColor *selectChannelBackColor = [_presentStyle selectChannelScreenColor];
    [_configurationChannelView setBackgroundColor:selectChannelBackColor];
}

#pragma mark - CONFIG UI ELEMENTS -

#pragma mark Create SCROLL

/// Создать и добавить контент вьюшку (скролл вью для скроллирования) (вписать в корневую вьюшку)
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


#pragma mark - Create LABELs

/// Конфигурирует верхний лейбл ("введите URL")
- (UILabel*)createEnterChannelLabel{
    
    UILabel *enterChannelLabel = [UILabel new];
    enterChannelLabel.numberOfLines = 2;
    enterChannelLabel.font = [UIFont systemFontOfSize:24.f];
    enterChannelLabel.text = @"Введите URL вашего\nканала :";
    enterChannelLabel.textAlignment = NSTextAlignmentCenter;
    
    [_channelContentView addSubview:enterChannelLabel];
    _enterChannelLabel = enterChannelLabel;
    
    [self configPresentLocationEnterChannelLabel];

    return enterChannelLabel;
}

/// Конфигурирует лейбл "Выберите из предложенных"
- (UILabel*)createSelectSuggestedLabel{
    
    UILabel *selectSuggestedLabel = [UILabel new];
    selectSuggestedLabel.numberOfLines = 3;
    selectSuggestedLabel.font = [UIFont systemFontOfSize:24.f];
    selectSuggestedLabel.text = @"или\nвыберите из\nпредложенных :";
    selectSuggestedLabel.textAlignment = NSTextAlignmentCenter;
    
    [_channelContentView addSubview:selectSuggestedLabel];
    _selectSuggestedLabel = selectSuggestedLabel;
    
    [self configBaseLocationSuggestedLabel];
    
    return selectSuggestedLabel;
}


#pragma mark - Create TEXTFIELDs

/// Конфигурирует текст филд для ввода  канала
- (HURSSChannelTextField*)createChannelTextField{
    
    HURSSChannelTextField *channelTextField = [HURSSChannelTextField channelTextFieldWithRootView:_configurationChannelView withStyler:_presentStyle];
    
    UIImage *searchIconImage = [UIImage imageNamed:@"SearchIcon.png"];
    [channelTextField setImage:searchIconImage];
    
    channelTextField.text = @"http://";
    
    [_channelContentView addSubview:channelTextField];
    _channelTextField = channelTextField;
    
    [self configPresentLocationChannelTextField];
    
    return channelTextField;
}

/// Создает и конфигурирует текстфилд для ввода названия канала
- (HURSSChannelTextField*)createChannelAliasTextField{
    
    HURSSChannelTextField *channelAliasTextField = [HURSSChannelTextField channelTextFieldWithRootView:_configurationChannelView withStyler:_presentStyle];
    channelAliasTextField.placeholder = @"Как назвать канал?";
    
    UIImage *channelAliasImage = [UIImage imageNamed:@"RSSIconFill.png"];
    [channelAliasTextField setImage:channelAliasImage];
    
    [_channelContentView insertSubview:channelAliasTextField belowSubview:_channelTextField];
    _channelAliasTextField = channelAliasTextField;
    
    [self configCreatedLocationAliasTextField];
    
    return channelAliasTextField;
}

#pragma mark - Create BUTTONs

/// Конфигурирует кнопку "СМОТРЕТЬ" (выбор  предпочитаемых каналов)
- (HURSSChannelButton*)createShowChannelButton{
    
    HURSSChannelButton *showChannelButton = [HURSSChannelButton channelButtonWithRootView:_configurationChannelView withStyler:_presentStyle];
    [showChannelButton setTitle:@"СМОТРЕТЬ" forState:UIControlStateNormal];
    
    [_channelContentView addSubview:showChannelButton];
    _showChannelButton = showChannelButton;
    
    [self configPresentLocationShowChannelButton];
    
    return showChannelButton;
}

/// Конфигурирует кнопку "ПОЛУЧИТЬ" (получить новости выбранного канала)
- (HURSSChannelButton*)createGetFeedsButton{
    
    HURSSChannelButton *feedsButton = [HURSSChannelButton channelButtonWithRootView:_configurationChannelView withStyler:_presentStyle];
    [feedsButton setTitle:@"ПОЛУЧИТЬ" forState:UIControlStateNormal];
    feedsButton.enabled = NO;
    
    [_channelContentView addSubview:feedsButton];
    
    // Пришлось так сделать, т.к почему-то не срабатывало если прикреплять к низу скролл вью
    _feedsButton = feedsButton;
    [self configPresentLocationFeedsButton];
    
    return feedsButton;
}

/// Конфигурирует кнопку "ДОБАВИТЬ" (кнопка добавления канала)
- (HURSSChannelButton*)createChannelAddButton{
    
    HURSSChannelButton *addChannelButton = [HURSSChannelButton channelButtonWithRootView:_configurationChannelView withStyler:_presentStyle];
    [self configChangeChannelButtonToAddMode];
    
    [_channelContentView insertSubview:addChannelButton belowSubview:_channelAliasTextField];
    _addChannelButton = addChannelButton;
    
    [self configCreatedLocationChannelAddButton];
    
    return addChannelButton;
}

/// Конфигурирует кнопку "УДАЛИТЬ" (кнопка удаления канала)
- (HURSSChannelButton*)createChannelRemoveButton{
    
    HURSSChannelButton *deleteChannelButton = [HURSSChannelButton channelButtonWithRootView:_configurationChannelView withStyler:_presentStyle];
    [deleteChannelButton setTitle:@"УДАЛИТЬ" forState:UIControlStateNormal];
    
    [_channelContentView insertSubview:deleteChannelButton belowSubview:_addChannelButton];
    _deleteChannelButton = deleteChannelButton;
    
    [self configCreatedLocationChannelRemoveButton];
    
    return deleteChannelButton;
}


#pragma mark - CONFIG DIALOGs -

#pragma mark Create CZPicker

/// Создает пикер для отображения списка каналов
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


#pragma mark - Create URBNAlertViewController

/**
    @abstract Общий конфигурационный метод для алерта
    @discussion
    Алерты URBNAlertViewController следует конфигурировать схожим образом (с одинаковой ситилизацией) - здесь и выполняется такое конфигурирование
 
    @param configureAlertVC      Алерт, который надо настроить
 */
- (void)configBaseStyleURBNViewController:(URBNAlertViewController*)configureAlertVC{
    
    // Установить стили
    URBNAlertStyle *alertStyler = configureAlertVC.alertStyler;
    
    alertStyler.blurTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    alertStyler.backgroundColor = [_presentStyle selectChannelScreenColor];
    alertStyler.titleFont = [UIFont systemFontOfSize:24.f];
    alertStyler.messageFont = [UIFont systemFontOfSize:18.f];
    alertStyler.buttonCornerRadius = @([alertStyler.buttonHeight unsignedIntegerValue] / 2.f);
    alertStyler.buttonBackgroundColor = [_presentStyle  channelButtonBackColor];
    alertStyler.buttonTitleColor = [UIColor brownColor];
    
    // Сделать, чтобы по нажатию вне алерта - вьюшка отменялась
    URBNAlertConfig *alertConfig = configureAlertVC.alertConfig;
    alertConfig.touchOutsideViewToDismiss = YES;
}

/// Создать диалог для "Получения новостей" после выбора канала в пикере
- (URBNAlertViewController*)createObtainingFeedsAlertWithChannelName:(NSString*)channelName{
    
    // Получить тексты
    NSString *obtainFeedsAlertTitle = @"Получить новости?";
    NSString *obtainFeedsAlertDescription = [NSString stringWithFormat:@"Вами был выбран канал %@. Применить его и получить новости этого RSS-канала?", channelName];
    
    // Инициализировать Alert Controller
    URBNAlertViewController *obtainFeedsAlertVC = [[URBNAlertViewController alloc] initWithTitle:obtainFeedsAlertTitle message:obtainFeedsAlertDescription];
    
    [self configBaseStyleURBNViewController:obtainFeedsAlertVC];
    
    // Добавить пустые экшены
    [obtainFeedsAlertVC addAction:[URBNAlertAction actionWithTitle:@"Нет" actionType:URBNAlertActionTypeCancel actionCompleted:nil]];
    [obtainFeedsAlertVC addAction:[URBNAlertAction actionWithTitle:@"Да" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    
    _obtainFeedsAlertVC = obtainFeedsAlertVC;
    return obtainFeedsAlertVC;
}

/**
    @abstract Создать алерт для ситуации, когда выполнено определенное  действие с каналом
    @discussion
    При выполнении определенного действия (Добавить/Изменить/Удалить) - алерт настраивается по-своему
 
    @param channelActionType      Тип действия с каналом (Добавить/Изменить/Удалить)
    @param channelName       Название  канала
    @param channelURL        URL-ссылка канала
 
    @return Готовый алерт
 */
- (URBNAlertViewController*)createChannelAlertWithPostAction:(HURSSChannelActionType)channelActionType WithChannelName:(NSString*)channelName andWithURL:(NSURL*)channelURL{
    
    NSString *actionString = nil;
    if(channelActionType == HURSSChannelActionAdd){
        actionString = @"добавлен";
    }else if(channelActionType == HURSSChannelActionModify){
        actionString = @"изменен";
    }else if(channelActionType == HURSSChannelActionDelete){
        actionString = @"удален";
    }
    
    // Получить тексты
    NSString *channelAlertTitle = [NSString stringWithFormat:@"Канал успешно %@!", actionString];
    NSString *channelAlertDescription = [NSString stringWithFormat:@"Был успешно %@ RSS-канал %@ с адресом \n%@", actionString, channelName, channelURL];
    
    // Инициализировать Alert Controller
    URBNAlertViewController *channelAlertVC = [[URBNAlertViewController alloc] initWithTitle:channelAlertTitle message:channelAlertDescription];
    
    [self configBaseStyleURBNViewController:channelAlertVC];
    
    // Добавить пустые экшены
    [channelAlertVC addAction:[URBNAlertAction actionWithTitle:@"ОК" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    
    _channelAlertVC = channelAlertVC;
    return channelAlertVC;
}

/**
    @abstract Создать алерт для ситуации, когда новости RSS-канала не удалось получить
    @discussion
    В алерте обычно отображается описание ошибки и несколько кнопок.
    <ol type="a">
        <li> Кнопка "Блин/жаль", (отмена) </li>
        <li> Кнопка "Еще раз" </li>
        <li> Если needOfflineRequest == YES - кнопка "Смотреть сохраненные ранее" </li>
    </ol>
 
    @note Алерт настраивается стандартным образом в схожем стиле с другими URBNAlertViewController
 
    @param channelName       Название канала, для которого не удалось получить новости
    @param feedsErrorDescription      Описание ошибки (причины неудачи)
    @param needOfflineRequest      Есть ли закэшированные новости? Можно ли извлечь их из БД?
 
    @return Готовый алерт
 */
- (URBNAlertViewController*)createFeedsRecvievingAlertWithChannelname:(NSString*)channelName withErrorDescription:(NSString*)feedsErrorDescription withOfflineFeedsRequest:(BOOL)needOfflineRequest{
    
    // Получить тексты
    NSString *feedsAlertTitle = @"Новости получить не удалось";
    NSString *feedsAlertDescription = [NSString stringWithFormat:@"Не удалось получить новости RSS-канала %@\n\nОписание ошибки :\n%@", channelName, feedsErrorDescription];
    
    // Инициализировать Alert Controller
    URBNAlertViewController *feedsNotRecievedAlertVC = [[URBNAlertViewController alloc] initWithTitle:feedsAlertTitle message:feedsAlertDescription];
    
    [self configBaseStyleURBNViewController:feedsNotRecievedAlertVC];
    
    NSString *feedsAlertButtonTitle = nil;
    if(arc4random() % 2 == 0){
        feedsAlertButtonTitle = @"Жаль";
    }else{
        feedsAlertButtonTitle = @"Блин";
    }
    
    // Добавить пустые экшены
    [feedsNotRecievedAlertVC addAction:[URBNAlertAction actionWithTitle:feedsAlertButtonTitle actionType:URBNAlertActionTypeCancel actionCompleted:nil]];
    [feedsNotRecievedAlertVC addAction:[URBNAlertAction actionWithTitle:@"Еще раз" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    
    if(needOfflineRequest){
        [feedsNotRecievedAlertVC addAction:[URBNAlertAction actionWithTitle:@"Смотреть сохраненные ранее" actionType:URBNAlertActionTypeNormal actionCompleted:nil]];
    }
    
    _feedsNotRecievingAlertVC = feedsNotRecievedAlertVC;
    return feedsNotRecievedAlertVC;
}


#pragma mark - CONFIG LOCATIONs -

#pragma mark CONFIG Label

///  Конфигурировать местоположение верхнего лейбла
- (void)configPresentLocationEnterChannelLabel{
    
    [_enterChannelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.leading.equalTo(_channelContentView.mas_leading).with.offset(20.f);
        make.top.equalTo(_channelContentView.mas_top).with.offset(60.f);
        make.height.mas_equalTo(60.f);
    }];
}

///  Конфигурировать местоположение нижнего лейбла (базовое - под URL textField-ом)
- (void)configBaseLocationSuggestedLabel{
    
    [_selectSuggestedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.top.equalTo(_channelTextField.mas_bottom).with.offset(20.f);
        make.height.mas_equalTo(90.f);
    }];
}

///  Конфигурировать местоположение нижнего лейбла (второе - под Alias textField-ом)
- (void)configSecondLocationSuggestedLabel{
    
    [_selectSuggestedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.top.equalTo(_channelAliasTextField.mas_bottom).with.offset(20.f);
        make.height.mas_equalTo(90.f);
    }];
}

///  Конфигурировать местоположение нижнего лейбла (третье - под Add кнопкой)
- (void)configThirdLocationSuggestedLabel{
    
    [_selectSuggestedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.top.equalTo(_addChannelButton.mas_bottom).with.offset(20.f);
        make.height.mas_equalTo(90.f);
    }];
}

///  Конфигурировать местоположение нижнего лейбла (четвертое - под Delete кнопкой)
- (void)configFourLocationSuggestedLabel{
    
    [_selectSuggestedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.top.equalTo(_deleteChannelButton.mas_bottom).with.offset(20.f);
        make.height.mas_equalTo(90.f);
    }];
}


#pragma mark - CONFIG TextFields

///  Конфигурировать местоположение URL TextField-а
- (void)configPresentLocationChannelTextField{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_channelTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.top.equalTo(_enterChannelLabel.mas_bottom).with.offset(20.f);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}

/// Конфигурировать истинное местоположение Alias TextField-а (после анимации падения)
- (void)configPresentLocationAliasTextField{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_channelAliasTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.top.equalTo(_channelTextField.mas_bottom).with.offset(20.f);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}

/// Конфигурировать базовое местоположение Alias TextField-а (при создании)
- (void)configCreatedLocationAliasTextField{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_channelAliasTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.centerY.equalTo(_channelTextField.mas_centerY);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}

/// Конфигурировать последнее местоположение Alias TextField-а (при уничтожении куда уезжает элемент)
- (void)configDestroyedLocationAliasTextField{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_channelAliasTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView).with.offset(- CGRectGetWidth(_configurationChannelView.frame));
        make.top.equalTo(_channelTextField.mas_bottom).with.offset(20.f);
        make.width.equalTo(_channelTextField.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}


#pragma mark - CONFIG Buttons

- (void)configPresentLocationShowChannelButton{
    
    const CGFloat channelButtonSize = [_presentStyle channelUIElementHeight];
    
    [_showChannelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.top.equalTo(_selectSuggestedLabel.mas_bottom).with.offset(20.f);
        make.width.equalTo(_channelTextField.mas_width);
        make.height.mas_equalTo(channelButtonSize);
    }];
}

/// Конфигурировать истинное местоположение Add Button-а (после анимации падения)
- (void)configPresentLocationChannelAddButton{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_addChannelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.top.equalTo(_channelAliasTextField.mas_bottom).with.offset(20.f);
        make.width.equalTo(_channelAliasTextField.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}

/// Конфигурировать базовое местоположение Add Button-а (при создании)
- (void)configCreatedLocationChannelAddButton{
    
    const CGFloat channelButtonSize = [_presentStyle channelUIElementHeight];
    
    [_addChannelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.centerY.equalTo(_channelAliasTextField.mas_centerY);
        make.width.equalTo(_channelAliasTextField.mas_width);
        make.height.mas_equalTo(channelButtonSize);
    }];
}

/// Конфигурировать последнее местоположение Add Button-а (при уничтожении куда уезжает элемент)
- (void)configDestroyedLocationChannelAddButton{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    [_addChannelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView).with.offset(- CGRectGetWidth(_configurationChannelView.frame));
        make.top.equalTo(_channelAliasTextField.mas_bottom).with.offset(20.f);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
}

/// Конфигурировать истинное местоположение Delete Button-а (после анимации падения)
- (void)configPresentLocationChannelRemoveButton{
    
    const CGFloat channelButtonSize = [_presentStyle channelUIElementHeight];
    
    [_deleteChannelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.top.equalTo(_addChannelButton.mas_bottom).with.offset(20.f);
        make.width.equalTo(_channelTextField.mas_width);
        make.height.mas_equalTo(channelButtonSize);
    }];
}

/// Конфигурировать базовое местоположение Delete Button-а (при создании)
- (void)configCreatedLocationChannelRemoveButton{
    
    const CGFloat channelButtonSize = [_presentStyle channelUIElementHeight];
    
    [_deleteChannelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.centerY.equalTo(_addChannelButton.mas_centerY);
        make.width.equalTo(_addChannelButton.mas_width);
        make.height.mas_equalTo(channelButtonSize);
    }];
}

/// Конфигурировать последнее местоположение Delete Button-а (при уничтожении куда уезжает элемент)
- (void)configDestoyedLocationChannelRemoveButton{
    
    const CGFloat channelButtonSize = [_presentStyle channelUIElementHeight];
    
    [_deleteChannelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView).with.offset(- CGRectGetWidth(_configurationChannelView.frame));
        make.top.equalTo(_addChannelButton.mas_bottom).with.offset(20.f);
        make.width.equalTo(_enterChannelLabel.mas_width);
        make.height.mas_equalTo(channelButtonSize);
    }];
}

/// Конфигурировать основное местоположение Feeds Button-а (внизу экрана)
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

/// Конфигурировать местоположение Feeds Button-а (внизу экрана) (и размер кнопки в режиме ожидания)
- (void)configWaitingLocationFeedsButton{
    
    const CGFloat feedsButtonSize = [_presentStyle channelUIElementHeight];
    const CGSize currentContentSize = _channelContentView.contentSize;
    const CGFloat currentContentHeight = currentContentSize.height;
    
    [_feedsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_channelContentView);
        make.bottom.equalTo(_channelContentView.mas_top).with.offset(currentContentHeight - (feedsButtonSize/2.f) - 20.f);
        make.width.mas_equalTo(feedsButtonSize);
        make.height.mas_equalTo(feedsButtonSize);
    }];
}


#pragma mark - CONFIG State's

/// Задизейблить получение новостей
- (void)configGetFeedsDisable{
    
    _channelTextField.textColor = [_presentStyle channelTextFieldTextColor];
    _feedsButton.enabled = NO;
}

/// Включить возможность получения новостей
- (void)configGetFeedsEnable{
    
    _channelTextField.textColor = [UIColor darkGrayColor];
    _feedsButton.enabled = YES;
}

/// Конфигурировать Add-кнопку в режим Добавления канала
- (void)configChangeChannelButtonToAddMode{
    [_addChannelButton setTitle:@"ДОБАВИТЬ" forState:UIControlStateNormal];
}

/// Конфигурировать Modify-кнопку в режим  Изменения канала
- (void)configChangeChannelButtonToModifyMode{
    [_addChannelButton setTitle:@"ИЗМЕНИТЬ" forState:UIControlStateNormal];
}


#pragma mark - CONFIG for Keyboard

/// Конфигурировать отступ для клавиатуры (когда выезжает клавиатура, или уезжает)
- (void)configKeyboardWithInsets:(UIEdgeInsets)contentInset{
    
    [_channelContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentInset);
    }];
    [_configurationChannelView layoutIfNeeded];
}



@end
