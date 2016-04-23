//
//  HUSelectRSSChannelView.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSelectRSSChannelView.h"

#import "Masonry.h"

#import "HURSSChannelViewAssembly.h"

//TODO: Запилить кэширование названия канала


@implementation HUSelectRSSChannelView{
    
    // Переменные состояния анимации уничтожения вьюшек (для расчета высоты нужно удаляемые вьюшки игнорировать)
    BOOL _startDestroyingAliasTextField;
    BOOL _startDestroyingAddButton;
    BOOL _startDestroyingDeleteButton;
    
    // Переменные для Action-Target паттерна
    __weak id _addChannelActionTarget;
    SEL _addChannelActionHandler;
    
    __weak id _deleteChannelActionTarget;
    SEL _deleteChannelActionHandler;
    
    // Дополнительные диалоги
    CZPickerView *_channelPickerView;
    URBNAlertViewController *_obtainFeedsAlertVC;
    URBNAlertViewController *_actionChannelAlertVC;
    URBNAlertViewController *_feedsAlertVC;
    
    // Названия каналов для пикера
    NSArray <NSString*> *_pickerChannelNames;
    
    // Рабочие объекты вьюшки
    id <HURSSTextFieldManagerInterface> _textFieldManager;
    id <HURSSChannelViewConfiguratorInterface> _presentConfigurator;
    HURSSChannelViewAnimator *_presentAnimator;
}


#pragma mark - Initialization

/// Конструктор для этого вью-пакета (Вместо прямого создания - используется специальная фабрика)
+ (instancetype)createChannelView{
    
    HURSSChannelViewAssembly *viewAssembly = [HURSSChannelViewAssembly defaultAssemblyForChannelView];
    HUSelectRSSChannelView *channelView = [viewAssembly createSelectChannelView];
    
    return channelView;
}

#pragma mark - Dependencies

/// Инжектировать зависимости
- (void)injectDependencies{
    
    HURSSChannelViewAssembly *viewAssembly = [HURSSChannelViewAssembly defaultAssemblyForChannelView];
    
    _textFieldManager = [viewAssembly getTextFieldManager];
    _presentConfigurator = [viewAssembly getViewConfigurator];
    _presentAnimator = [viewAssembly getViewAnimator];
}


#pragma mark - Config UI Elements

/**
    @abstract Основной конфигурирующий метод вьюшки (config Root)
    @discussion
    Создает и конфигурирует все сабвьюшки для корневой вьюшки SelectChannel-экрана
    Кроме всего, сначала устанавливает фон.
 
    Создает следующие вьюшки :
    <ol type="1">
        <li> Базовое ScrollView (для того, чтобы контент скроллировался) </li>
        <li> Создает верхний лейбл (крепит его к верху экрана) </li>
        <li> Создает текстовое поле  для ввода URLа канала (крепится к верхнему лейблу) </li>
        <li> Создает нижний лейбл (крепится к текстовому полю) </li>
        <li> Создает кнопку "Смотреть" (крепится к нижнему лейблу) </li>
        <li> Создает кнопку "Получить" (крепится к низу вьюшки) </li>
    </ol>
 
    @note Логика создания всех вьюшек - скрыта в конфигураторе
 */
- (void)configurationAllStartedViews{
    
    [_presentConfigurator configBackground];
    self.channelContentView = [_presentConfigurator createContentScrollView];
    self.enterChannelLabel = [_presentConfigurator createEnterChannelLabel];
    self.channelTextField = [_presentConfigurator createChannelTextField];
    self.selectSuggestedLabel = [_presentConfigurator createSelectSuggestedLabel];
    self.showChannelButton = [_presentConfigurator createShowChannelButton];
    self.feedsButton = [_presentConfigurator createGetFeedsButton];
}

#pragma mark - Type TextFields

/**
    @abstract Получить информацию о типе текстового поля
    @discussion
    Используется для того, чтобы изнутри вьюшки не проверять напрямую, какая вьюшка среагировала. 
 
    @param channelTextField      Искомое текстовое поле
    @return Конкретный тип текстового поля из перечисления HURSSChannelTextFieldType (HURSSChannelUnrecognizedFieldType - поле не найдено)
 */
- (HURSSChannelTextFieldType)getChannelTextFieldType:(HURSSChannelTextField*)channelTextField{
    
    HURSSChannelTextFieldType channelTextFieldType = HURSSChannelUnrecognizedFieldType;
    
    // Найти эквивалентное текстовое поле
    BOOL isEnterURLTextField = [self.channelTextField isEqual:channelTextField];
    BOOL isAliasTextField = [self.channelAliasTextField isEqual:channelTextField];
    
    // Определить тип тексового поля
    if(isEnterURLTextField){
        channelTextFieldType = HURSSChannelEnterURLFieldType;
    }else if(isAliasTextField){
        channelTextFieldType = HURSSChannelAliasFieldType;
    }
    
    return channelTextFieldType;
}


#pragma mark - Accessors & Mutators

/// Установить в интерфейс отображение ссылку канала (устанавливает в текстовое поле)
- (void)showChannelURLLink:(NSURL*)channelURL{
    
    NSString *channelLinkString = channelURL.absoluteString;
    [self.channelTextField setText:channelLinkString];
}

/// Устанавливает в интерфейс название канала (в текстовое поле)
- (void)showChannelAlias:(NSString*)channelAlias{
    [self.channelAliasTextField setText:channelAlias];
}

/// Возвратить введенный URL (тот, который в текстовом поле)
- (NSURL*)getChannelURLLink{
    NSString *channelLinkString = self.channelTextField.text;
    NSURL *channelURL = [NSURL URLWithString:channelLinkString];
    return channelURL;
}

/// Возвратить введенное название канала (то, которое в текстовое поле)
- (NSString*)getChannelAlias{
    NSString *channelAlias = self.channelAliasTextField.text;
    return channelAlias;
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

/// Установить обработчик для кнопки "ДОБАВИТЬ" (должен добавлять новый канал)
- (void)setAddChannelHandler:(SEL)actionHandler withTarget:(id)actionTarget{
    
    _addChannelActionTarget = actionTarget;
    _addChannelActionHandler = actionHandler;
}

/// Установить обработчик для кнопки "УДАЛИТЬ" (должен удалять имеющийся канал)
- (void)setDeleteChannelHandler:(SEL)actionHandler withTarget:(id)actionTarget{
    
    _deleteChannelActionTarget = actionTarget;
    _deleteChannelActionHandler = actionHandler;
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

/**
    @abstract Установить обработчик для алерта на получение новостей 
    @discussion
    Когда пользователь  выбирает канал из списка - ему показывается диалог (получить ли список новостей?). С помощь этого метода назначается обработчик кнопки "Да". По идее, после нажатия на нее - должно иницироваться получение новостей.
 
    @param actionHandler      Метод-обработчик получения новостей
    @param actionTarget       Таргет у которого вызывается селектор
 */
- (void)setObtainingFeedsAlertHandler:(SEL)actionHandler withTarget:(id)actionTarget{
    
    NSArray <URBNAlertAction*>*actions = _obtainFeedsAlertVC.alertConfig.actions;
    URBNAlertAction *obtainingAction = actions[1];
    
    __weak __block typeof(self) weakTarget = actionTarget;
    [obtainingAction setCompletionBlock:^(URBNAlertAction *action) {
        __strong __block typeof(weakTarget) strongTarget = weakTarget;
        
        [strongTarget performSelector:actionHandler withObject:nil afterDelay:0.f];
    }];
}


#pragma mark - CHANNEL Action Dialog -

/**
    @abstract Показать алерт для различных действий с каналами
    @discussion
    Показать алерт URBNAlertViewController, с одной кнопкой - "ОК". Просто информировать пользователя о том, что действие было совершено. Тексты в диалоге генерятся с учетом названия канала, и URL-а.
 
    @param channelActionType      Тип действия с каналом
    @param channelName       Название канала
    @param channelURl       URL -канала
 */
- (void)showAlertPostAction:(HURSSChannelActionType)channelActionType ForChannelName:(NSString*)channelName withURL:(NSURL*)channelURl{
    
    // Создать алерт-контроллер
    URBNAlertViewController *channelActionAlertVC = [_presentConfigurator createChannelAlertWithPostAction:channelActionType WithChannelName:channelName andWithURL:channelURl];
    
    // Показать алерт
    [channelActionAlertVC show];
    
    // Запомнить объект алерта
    _actionChannelAlertVC = channelActionAlertVC;
}


#pragma mark - FAIL Feeds Dialog -

/**
    @abstract Диалог в случае неудачного получения новостей
    @discussion
    Если новости получить не удалось - показать диалог. В диалоге будут 2 кнопки - "Жаль" и "Еще раз".
 
    @note Показывать не сразу - чтобы корректно были показаны все анимации (все равно весь UI дизейблится)
 
    @param channelName       Название канала
    @param feedsErrorDescription      Описание ошибки получения новостей
 */
- (void)showFeedsFailRecivingAlertForChannelName:(NSString*)channelName withErrorDescription:(NSString*)feedsErrorDescription{
    
    URBNAlertViewController *feedsAlertVC = [_presentConfigurator createFeedsRecvievingAlertWithChannelname:channelName withErrorDescription:feedsErrorDescription];
    
    // Запомнить объект алерта
    _feedsAlertVC = feedsAlertVC;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // Показать алерт
        [feedsAlertVC show];
    });
}

/**
    @abstract Повесть обработчик для кнопки "Еще раз" фейл-диалога
    @discussion
    Когда  пользователю показывается диалог в случае неудачного получения новостей - то там есть кнопка "Еще раз". При нажатии на эту кнопку следует еще раз перезагружать новости. С помощью этого метода на эту кнопку назначается обработчик
 
    @param actionHandler      Метод-обработчик
    @param actionTarget        Таргет, в котором ищется селектор
 */
- (void)setFeedsRepeatAlertHandler:(SEL)actionHandler withTarget:(id)actionTarget{
    
    NSArray <URBNAlertAction*>*actions = _feedsAlertVC.alertConfig.actions;
    URBNAlertAction *obtainingAction = actions[1];
    
    __weak __block typeof(self) weakTarget = actionTarget;
    [obtainingAction setCompletionBlock:^(URBNAlertAction *action) {
        __strong __block typeof(weakTarget) strongTarget = weakTarget;
        
        [strongTarget performSelector:actionHandler withObject:nil afterDelay:0.f];
    }];
}


#pragma mark - UPDATE UI To States -

/**
    @abstract Обновить UI, когда успешно/неудачно валидируется RSS URL
    @discussion
    Когда пользователь вводит URL, достаточно валидный - ему требуется анимированно показать текст филд для ввода названия канала, и включить кнопку "Получить".
    В ином случае - задизейблить кнопку, и анимированно  убрать дополнительные UI-элементы
 
    @param passValidate      Успешно ли URL прошел валидацию
 */
- (void)updateUIWhenEnteredChannelURLValidate:(BOOL)passValidate{
    
    if(passValidate){
        // Валидация была  успешно проведена - показать текстовое  поле
        [_presentConfigurator configGetFeedsEnable];
        [_presentAnimator performAnimatedCreationAliasTextField];
        
    }else{
        // Валидация была провалена - убрать текстовое поле
        [_presentConfigurator configGetFeedsDisable];
        [_presentAnimator performAnimatedDestroyAliasTextField];
    }
}

/**
    @abstract Обновить UI в зависимости от нового состояния
    @discussion
    Имеется всего 3 состояния :
    <ol type="a">
        <li> HURSSChannelStateImpossible :
            Длина названия канала недостаточно длинна, не показывать дополнительных кнопок </li>
        <li> HURSSChannelStatePossibleAdd :
            Пользователь может сохранить канал (добавить) - показать кнопку "Добавить"</li>
        <li> HURSSChannelStatePossibleModifyDel :
            Пользователь имеет введенное название уже имеющегося канала - и его можно изменить (показать кнопки "Добавить" и "Удалить") </li>
    </ol>
 
    @param channelState      Новое состояние использования канала
 */
- (void)updateUIWhenChannelChangeState:(HURSSChannelState)channelState{
    
    if(channelState == HURSSChannelStatePossibleModifyDel){
        
        [_presentAnimator performAnimatedCreationChannelAddButton];
        [_presentAnimator performAnimatedCreationChannelRemoveButton];
        
        [_presentConfigurator configChangeChannelButtonToModifyMode];
        
    }else if(channelState == HURSSChannelStatePossibleAdd){
        
        [_presentAnimator performAnimatedCreationChannelAddButton];
        [_presentAnimator performAnimatedDestroyChannelRemoveButton];
        
        [_presentConfigurator configChangeChannelButtonToAddMode];
        
    }else if(channelState == HURSSChannelStateImpossible){
        
        [_presentAnimator performAnimatedDestroyChannelRemoveButton];
        [_presentAnimator performAnimatedDestroyChannelAddButton];
    }
}


#pragma mark - CREATE Additional UI Elems


/// Создание текстового поля для ввода псевдонима RSS-канала
- (void)createChannelAliasTextField{
    
    // Создать текстовое поле для ввода псевдонима
    HURSSChannelTextField *channelAliasTextField = [_presentConfigurator createChannelAliasTextField];
    self.channelAliasTextField = channelAliasTextField;
    
    // Сделать, чтобы текстовое поле нормально реагировало и продлевало таймер клавиатуры
    [_textFieldManager refreshObserving];
    
    // Конфигурировать лейбл "или выберите из предложенных" - привязать его к новому  текст филду, и пересобрать макет
    [_presentConfigurator configSecondLocationSuggestedLabel];
    [self layoutIfNeeded];
    
    // Запустить анимацию "падения" текстового поля
    [_presentAnimator performAnimateFallAliasTextFieldWithCompletion:nil];
}

/// Создание кнопки для добавления канала
- (void)createChannelAddButton{
    
    // Создать кнопку добавления канала (назначить стартовую позицию)
    HURSSChannelButton *addChannelButton = [_presentConfigurator createChannelAddButton];
    self.addChannelButton = addChannelButton;
    
    // Конфигурировать лейбл "или выберите из предложенных" - привязать его к новой кнопке, и пересобрать макет
    [_presentConfigurator configThirdLocationSuggestedLabel];
    [self layoutIfNeeded];
    
    // Запустить анимацию "падения" кнопки добавления
    [_presentAnimator performAnimateFallChannelAddButtonWithCompletion:^{
        // Когда кнопка успешно добавлена - повесить на нее обработчик
        [self.addChannelButton setTouchHandler:_addChannelActionHandler toTarget:_addChannelActionTarget];
    }];
}

/// Создание кнопки для удаления канала
- (void)createChannelDeleteButton{
    
    // Создать кнопку удаления канала (назначить стартовую позицию)
    HURSSChannelButton *deleteChannelButton = [_presentConfigurator createChannelRemoveButton];
    self.deleteChannelButton = deleteChannelButton;
    
    // Конфигурировать лейбл "или выберите из предложенных" - привязать его к новой кнопке, и пересобрать макет
    [_presentConfigurator configFourLocationSuggestedLabel];
    [self layoutIfNeeded];
    
    // Запустить анимацию "падения" для кнопки "Удалить"
    [_presentAnimator performAnimateFallChannelRemoveButtonWithCompletion:^{
        // Когда кнопка успешно добавлена - повесить на нее обработчик
        [self.deleteChannelButton setTouchHandler:_deleteChannelActionHandler toTarget:_deleteChannelActionTarget];
    }];
    
}


#pragma mark - DESTROY Additional UI Elems

/// Уничтожение текстового поля для ввода  канала (если есть кнопку "Добавить") - ее уничтожить сперва
- (void)destroyChannelAliasTextField{
    
    // Если есть кнопка (привязанная к текст филду ниже) - убрать ее сначала
    if(self.deleteChannelButton){
        [self destroyChannelDeleteButton];
    }
    if(self.addChannelButton){
        [self destroyChannelAddButton];
    }
    
    // Запустить анимацию уничтожения кнопки (уезжает в сторону), и в конце анимации уничтожается
    _startDestroyingAliasTextField = YES;
    [_presentAnimator performAnimateMoveAwayAliasTextFieldWithCompletion:^{
        
        [self.channelAliasTextField removeFromSuperview];
        self.channelAliasTextField = nil;
        _startDestroyingAliasTextField = NO;
    }];
}


/// Уничтожение кнопки для добавления канала
- (void)destroyChannelAddButton{
    
    // Прежде - уничтожить кнопку удаления (как связанную)
    if(self.deleteChannelButton){
        [self destroyChannelDeleteButton];
    }
    
    // Запустить анимацию "уезжания" кнопки, по окончанию - уничтожить кнопку
    _startDestroyingAddButton = YES;
    [_presentAnimator performAnimateMoveAwayChannelAddButtonWithCompletion:^{
        
        [self.addChannelButton removeFromSuperview];
        self.addChannelButton = nil;
        _startDestroyingAddButton = NO;
    }];
}

/// Уничтожение кнопки для удаления канала
- (void)destroyChannelDeleteButton{
    
    // Запустить анимацию "уезжания" кнопки, по окончанию - уничтожить кнопку
    _startDestroyingDeleteButton = YES;
    [_presentAnimator performAnimateMoveAwayChannelRemoveButtonWithCompletion:^{
        
        [self.deleteChannelButton removeFromSuperview];
        self.deleteChannelButton = nil;
        _startDestroyingDeleteButton = NO;
    }];
}


#pragma mark - UPDATE Content Size

/**
    @abstract Обновить размер контента
    @discussion
    Вычисляется достаточный размер контента для вьюшки (если кнопки начинают залезать друг на друга  - увеличивает размер контента). Пересобрать макет, если требуется
 
    @param needLayout      Пересобрать макет по новым правилам вьюхи, если требуется
 */
- (void)updateContentSizeWithLayout:(BOOL)needLayout{
    
    // Рассчитать и установить новый контент-сайз (и обновить макет)
    const CGFloat newContentHeight = [self evaluateContentSize];
    CGSize newContentSize = CGSizeMake(self.channelContentView.contentSize.width, newContentHeight);
    [self.channelContentView setContentSize:newContentSize];
    if(needLayout){
        [self layoutIfNeeded];
    }
    
    // Разместить кнопку GetFeeds по новому местоположению
    [_presentConfigurator configPresentLocationFeedsButton];
    
    // Пересобрать макет, если нужно
    if(needLayout){
        [self layoutIfNeeded];
    }
}

/// Расчет размера контента (пришлось сделать после  того, как иначе нормально обновлять контент-сайз не получилось)
- (CGFloat)evaluateContentSize{
    
    CGFloat evalContentSize = 60.f + CGRectGetHeight(_enterChannelLabel.frame) + 20.f + CGRectGetHeight(_channelTextField.frame) + 20.f + CGRectGetHeight(_selectSuggestedLabel.frame) + 20.f + CGRectGetHeight(_showChannelButton.frame) + 20.f;
    
    if(! _startDestroyingAliasTextField && _channelAliasTextField){
        evalContentSize += (CGRectGetHeight(_channelAliasTextField.frame) + 20.f);
    }
    if(! _startDestroyingAddButton && _addChannelButton){
        evalContentSize += (CGRectGetHeight(_addChannelButton.frame) + 20.f);
    }
    if(! _startDestroyingDeleteButton && _deleteChannelButton){
        evalContentSize += (CGRectGetHeight(_deleteChannelButton.frame) + 20.f);
    }
    
    evalContentSize += 20.f;
    evalContentSize += (20.f + CGRectGetHeight(_feedsButton.frame) + 2.f);
    
    const CGFloat viewHeight = CGRectGetHeight(self.frame);
    return (evalContentSize > viewHeight) ? evalContentSize : viewHeight;
}

#pragma mark - Keyboard SHOW/HIDE -

/// Действия с UI при появлении клавиатуры (передает  управление аниматору)
- (void)showKeyboardActionsWithDuration:(NSTimeInterval)animationDuration withKeyboardSize:(CGSize)keyboardSize withChannelFieldType:(HURSSChannelTextFieldType)channelFieldType withCompletionBlock:(dispatch_block_t)keyboardActionCompletion{
    
    [_presentAnimator performAnimateShowKeyboardWithDuration:animationDuration withKeyboardSize:keyboardSize withCopletionBlock:keyboardActionCompletion];
}

/// Действия с UI при сокрытии клавиатуры (передает  управление аниматору)
- (void)hideKeyboardActionsWithDuration:(NSTimeInterval)animationDuration withKeyboardSize:(CGSize)keyboardSize withChannelFieldType:(HURSSChannelTextFieldType)channelFieldType withCompletionBlock:(dispatch_block_t)keyboardActionCompletion{
    
    [_presentAnimator performAnimateHideKeyboardWithDuration:animationDuration withKeyboardSize:keyboardSize withCopletionBlock:keyboardActionCompletion];
}

/// Скрывает клавиатуру
- (void)hideKeyboard{
    
    [_textFieldManager hideKeyboard];
}


#pragma mark - FEEDS Waiting

/**
    @abstract Стартовать получение  новостей (показать ожидание)
    @discussion
    Когда пользователь нажимает на кнопку "Получить" - следует повесить ожидание. 
    <ol type="1">
        <li> Задизейблить UI </li>
        <li> Ждать, пока анимация восстановления кнопки завершится, прежде чем начать эту </li>
        <li> Кнопка сжимается по x оси, становясь круглой </li>
        <li> Когда кнопка сжата - на нее вешается индикатор </li>
    </ol>
 */
- (void)startFeedsWaiting{
    
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.25f animations:^{
            self.feedsButton.titleLabel.alpha = 0.f;
        }];
        
        [UIView animateWithDuration:0.6f delay:0.f usingSpringWithDamping:0.5f initialSpringVelocity:0.f options:0 animations:^{
            
            [_presentConfigurator configWaitingLocationFeedsButton];
            [self layoutIfNeeded];
            
        }completion:^(BOOL finished) {
            
            // После окончания анимаци - повесить на кнопку индикатор (после небольшой задержки)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.feedsButton startWaitingIndicator];
            });
        }];
    });
}

/**
    @abstract Окончить получение  новостей (убрать ожидание)
    @discussion
    После нажатия на  кнопку "Получить", если новости удалось, или не удалось получить - следует убрать ожидание
 
    @note Следуется сделать приличную задержку, чтобы анимации были переходящими (для случая, когда сразу же после старта приходит Failure)
    <ol type="1">
        <li> Убрать индикатор ожидания </li>
        <li> Вернуть кнопке  feedsButton нормальный размер </li>
        <li> По окончанию анимаций - раздизейблить UI </li>
    </ol>
    @param waitingCompletion      Коллбэк окончания анимации
 */
- (void)endFeedsWaitingWithCompletion:(dispatch_block_t)waitingCompletion{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.25f animations:^{
            self.feedsButton.titleLabel.alpha = 1.f;
        }];
        
        [UIView animateWithDuration:0.6f delay:0.f usingSpringWithDamping:0.5f initialSpringVelocity:0.f options:0 animations:^{
            
            [_presentConfigurator configPresentLocationFeedsButton];
            [self.feedsButton endWaitingIndicator];
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
            
            if(waitingCompletion){
                waitingCompletion();
            }
        }];
    });
}



@end


