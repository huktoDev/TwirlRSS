//
//  HURSSChannelTextFieldManager.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 21.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelTextFieldManager.h"

/**
    @constant HURSS_CHANNEL_TEXT_FIELD_WAITING
        Сколько времени ожидать при бездействии поля до сокрытия клавиатуры (8 секунд по дефолту)
 */
const NSTimeInterval HURSS_CHANNEL_TEXT_FIELD_WAITING = 8.f;

@implementation HURSSChannelTextFieldManager{
    
    // Вьюшка, с текст филдами которой идет работа
    __weak HUSelectRSSChannelView *_managedChannelRootView;
    
    // Жест и таймер для сокрытия клавиатуры
    UITapGestureRecognizer *_keyboardHideGesture;
    NSTimer *_keyboardHideTimer;
    
    // Текущее состояние наблюдения за событиями курсора
    BOOL _isCursorActionsObserving;
    
    // Центр наблюдения (в частности за событиями клавиатуры)
    NSNotificationCenter *_notifCenter;
}


#pragma mark - Construction & Destroying

/**
    @abstract Инициализатор для менеджера
    @discussion
    При инициализации стартует наблюдение за событиями клавиатуры 
    will Show и will Hide (начинает показываться и начинает сокрываться)
 
    Кроме всего, устанвливает корневую вьюшку, с которой будет  вестись работа
 
    @param channelRootView      Корневая вьюшка SelectChannel-экрана, текст-филды которой будут управляться
    @return Готовый объект менеджера
 */
- (instancetype)initWithRootView:(HUSelectRSSChannelView*)channelRootView{
    if(self = [super init]){
        
        [self injectDependencies];
        
        [_notifCenter addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [_notifCenter addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        
        _managedChannelRootView = channelRootView;
    }
    return self;
}

/// Конструктор для менеджера
+ (instancetype)createManagerForRootView:(HUSelectRSSChannelView*)channelRootView{
    HURSSChannelTextFieldManager *newManager = [[HURSSChannelTextFieldManager alloc] initWithRootView:channelRootView];
    return newManager;
}

/// Когда объект уничтожается - следует прервать наблюдение
- (void)dealloc{
    
    [_notifCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [_notifCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Dependencies

// Инжектировать зависимости
- (void)injectDependencies{
    _notifCenter = [NSNotificationCenter defaultCenter];
}


#pragma mark - Observing TEXT FIELDS

/**
    @abstract Начинает управлять текстовым полем
    @discussion
    Делает 3 вещи :
    <ol type="1">
        <li> Добавляет жест к корневой вьюшке (чтобы по тачу клавиатура закрывалась) </li>
        <li> Добавляет таймер бездействия (по окончанию которого клавиатура скрывается) </li>
        <li> Начинает наблюдение за событиями клавиатуры (если что-то еще происходит - сбрасывать таймер) </li>
    </ol>
 */
- (void)startObserving{
    [self addKeyboardHideGesture];
    [self addKeyboardHideTimer];
    [self addObserveForKeyboardActions];
}

/**
    @abstract Прекращает управлять текстовым полем
    @discussion
    Делает 3 вещи :
    <ol type="1">
        <li> Убирает жест к корневой вьюшке (чтобы по тачу клавиатура закрывалась) </li>
        <li> Убирает таймер бездействия (по окончанию которого клавиатура скрывается) </li>
        <li> Прекращает наблюдение за событиями клавиатуры (если что-то еще происходит - сбрасывать таймер) </li>
    </ol>
 */
- (void)endObserving{
    [self removeKeyboardHideGesture];
    [self removeKeyboardHideTimer];
    [self removeObserveForKeyboardActions];
}

/// Обновляет наблюдение (заново обновляет таймер и объекты, наблюдение) (Используется для случаев, когда к вьюшке во время того, как  клавиатура уже показывается - добавляется еще одно текстовое поле)
- (void)refreshObserving{
    
    [self endObserving];
    [self startObserving];
}


#pragma mark - FIND Text Fields

/**
    @abstract Найти текстовые поля во вьюшке
    @discussion
    Находит именно все текстовые поля. НА текущий момент вместо рекурсивного поиска по сабвьюшкам (более общий вариант) - банально берутся текстовые поля из свойств
 
    @return Массив текстовых полей, над которыми будет вестись управление
 */
- (NSArray <HURSSChannelTextField*>*)findTextFields{
    
    NSMutableArray <HURSSChannelTextField*> *findedTextFields = [NSMutableArray new];
    if(_managedChannelRootView.channelTextField){
        [findedTextFields addObject:_managedChannelRootView.channelTextField];
    }
    if(_managedChannelRootView.channelAliasTextField){
        [findedTextFields addObject:_managedChannelRootView.channelAliasTextField];
    }
    return [NSArray arrayWithArray:findedTextFields];
}


#pragma mark - KEYBOARD Notifications

/**
    @abstract Уведомление, приходящее, когда клавиатура начинает показываться
    @discussion
    Определяется тип поля, передается корневой вьюшке экрана управление за ходом анимирования экрана, и устанавливает коллбэк - начинает управление текстовыми полями вьюшки.
 
    @param keyboardNotification      Уведомление клавиатуры, содержащее  параметры клавиатуры, и объект текстового поля-инициатора
 */
- (void)keyboardWillShowNotification:(NSNotification*)keyboardNotification{
    
    // Получить тип текстового поля
    HURSSChannelTextField *channelTextField = (HURSSChannelTextField*)keyboardNotification.object;
    HURSSChannelTextFieldType channelFieldType = [_managedChannelRootView getChannelTextFieldType:channelTextField];
    
    // Получить информацию о клавиатуре
    NSDictionary *keyboardUserInfo = [keyboardNotification userInfo];
    CGSize keyboardSize = [[keyboardUserInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSTimeInterval keyboardAnimationDuration = [[keyboardUserInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Передать управление анимацией появление клавиатуры HUSelectRSSChannelView
    [_managedChannelRootView showKeyboardActionsWithDuration:keyboardAnimationDuration withKeyboardSize:keyboardSize withChannelFieldType:channelFieldType withCompletionBlock:^{
        
        // Добавить тап и таймер, начать следить за событиями
        [self startObserving];
    }];
}

/**
    @abstract Уведомление, приходящее, когда клавиатура начинает скрываться
    @discussion
    Определяется тип поля, передается корневой вьюшке экрана управление за ходом анимирования экрана, и устанавливает коллбэк - прекращает управление текстовыми полями вьюшки (из-за ненадобности)
 
    @param keyboardNotification      Уведомление клавиатуры, содержащее  параметры клавиатуры (например, длительность анимации клавиатуры ), и объект текстового поля-инициатора
 */
- (void)keyboardWillHideNotification:(NSNotification*)keyboardNotification{
    
    // Получить тип текстовогополя
    HURSSChannelTextField *channelTextField = (HURSSChannelTextField*)keyboardNotification.object;
    HURSSChannelTextFieldType channelFieldType = [_managedChannelRootView getChannelTextFieldType:channelTextField];
    
    // Получить информацию о клавиатуре
    NSDictionary *keyboardUserInfo = [keyboardNotification userInfo];
    CGSize keyboardSize = [[keyboardUserInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSTimeInterval keyboardAnimationDuration = [[keyboardUserInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Передать управление анимацией сокрытия клавиатуры HUSelectRSSChannelView
    [_managedChannelRootView hideKeyboardActionsWithDuration:keyboardAnimationDuration withKeyboardSize:keyboardSize withChannelFieldType:channelFieldType withCompletionBlock:^{
        
        // Убрать тап и таймер, прекратить следить за событиями
        [self endObserving];
    }];
}


#pragma mark - HIDE Keyboard

/// Скрывает Клавиатуру. Клавиатуры скрывается, если у нужного поля отобрать ответчика (просто отбирается ответчик у всех текстовых полей)
- (void)hideKeyboard{
    
    NSArray <HURSSChannelTextField*> *channelTextFields = [self findTextFields];
    for(HURSSChannelTextField *currentTextField in channelTextFields) {
        [currentTextField resignFirstResponder];
    }
}


#pragma mark - Keyboard Hide Gesture

/**
    @abstract Добавляет распознаватель жестов на  корневую вьюшку
    @discussion
    Требуется жест для того, чтобы при нажатии на вьюшку вне клавиатуры, и текстового поля - чтобы клавиатура скрылась
    @return Добавленный тап-жест
 */
- (UITapGestureRecognizer*)addKeyboardHideGesture{
    
    if(_keyboardHideGesture){
        return _keyboardHideGesture;
    }
    _keyboardHideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHideGestureHandle:)];
    [_managedChannelRootView.channelContentView addGestureRecognizer:_keyboardHideGesture];
    return _keyboardHideGesture;
}

/// Удаляет тап-жест для сокрытия клавиатуры
- (void)removeKeyboardHideGesture{
    
    if(! _keyboardHideGesture){
        return;
    }
    [_managedChannelRootView.channelContentView removeGestureRecognizer:_keyboardHideGesture];
    _keyboardHideGesture = nil;
}

/// Метод обработчик тапа (скрывает клавиатуру)
- (void)keyboardHideGestureHandle:(UITapGestureRecognizer*)keyboardHideGesture{
    
    [self hideKeyboard];
}


#pragma mark - Keyboard Hide Timer

/**
    @abstract Добавляет таймер в текущий ран луп
    @discussion
    Требуется таймер, по истечении которого - клавиатура будет убираться.
    Если пользователь делает какие-либо действия в текстовом поле, либо меняет текстовое поле, либо меняет курсор - по идее таймер должен сбрасываться
 
    @note На текущий момент жестко вшито значение 8 секунд.
    @return Добавленный таймер к клавиатуре
 */
- (NSTimer*)addKeyboardHideTimer{
    
    if(_keyboardHideTimer){
        return _keyboardHideTimer;
    }
    _keyboardHideTimer = [NSTimer scheduledTimerWithTimeInterval:HURSS_CHANNEL_TEXT_FIELD_WAITING target:self selector:@selector(keyboardTimerFired:) userInfo:nil repeats:NO];
    return _keyboardHideTimer;
}

/// Удаляет таймер для сокрытия клавиатуры
- (void)removeKeyboardHideTimer{
    if(! _keyboardHideTimer){
        return;
    }
    if([_keyboardHideTimer isValid]){
        [_keyboardHideTimer invalidate];
    }
    _keyboardHideTimer = nil;
}

/// Обновляет таймер для сокрытия клавиатуры (сбрасывает его время до нуля (заново запускает))
- (void)refreshKeyboardHideTimer{
    [self addKeyboardHideTimer];
    [self removeKeyboardHideTimer];
}

/// Когда срабатывает таймер клавиатуры - убирает клавиатуру, и уничтожает таймер
- (void)keyboardTimerFired:(NSTimer*)firedTimer{
    
    [self hideKeyboard];
    [self removeKeyboardHideTimer];
}


#pragma mark - Keyboard Observing Actions

/**
    @abstract Добавляет наблюдение за событиями текстовых полей
    @discussion
    Наблюдение за этими событиями нужно для обновления таймера сокрыти клавиатуры.
    Дважды таргет не добавляет. Если таргет уже есть - сначала его сбрасывает
 */
- (void)addObserveForKeyboardActions{
    
    SEL actionHandleSelector = @selector(channelTextFieldActionDetected:);
    UIControlEvents handledControlEvents = (UIControlEventEditingDidBegin | UIControlEventEditingChanged);
    
    NSArray <HURSSChannelTextField*> *channelTextFields = [self findTextFields];
    for(HURSSChannelTextField *currentTextField in channelTextFields) {
        
        BOOL targetActionAlreadyExist = [[currentTextField allTargets] containsObject:self];
        if(targetActionAlreadyExist){
            [currentTextField removeTarget:self action:actionHandleSelector forControlEvents:handledControlEvents];
        }
        
        [currentTextField addTarget:self action:actionHandleSelector forControlEvents:handledControlEvents];
        
        if(! _isCursorActionsObserving){
            [currentTextField addObserver:self forKeyPath:@"selectedTextRange" options:0 context:nil];
            _isCursorActionsObserving = YES;
        }
    }
}

/// Удаляет наблюдение за событиями  текстовых полей
- (void)removeObserveForKeyboardActions{
    
    SEL actionHandleSelector = @selector(channelTextFieldActionDetected:);
    UIControlEvents handledControlEvents = (UIControlEventEditingDidBegin | UIControlEventEditingChanged);
    
    NSArray <HURSSChannelTextField*> *channelTextFields = [self findTextFields];
    for(HURSSChannelTextField *currentTextField in channelTextFields) {
        
        BOOL targetActionAlreadyExist = [[currentTextField allTargets] containsObject:self];
        if(targetActionAlreadyExist){
            [currentTextField removeTarget:self action:actionHandleSelector forControlEvents:handledControlEvents];
        }
        
        if(_isCursorActionsObserving){
            [currentTextField addObserver:self forKeyPath:@"selectedTextRange" options:0 context:nil];
            _isCursorActionsObserving = NO;
        }
    }
}

/// Когда пользователь редактирует текстовое поле, или текстовое  поле меняет фокус
- (void)channelTextFieldActionDetected:(UITextField*)channelTextField{
    [self refreshKeyboardHideTimer];
}

/// KVO-обработчик (здесь диспатчится событие изменения курсора в channelTextFieldActionDetected:)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"selectedTextRange"]){
       [self channelTextFieldActionDetected:object];
    }
}


#pragma mark - Text CHANGED Actions

/// Начать ловить события изменения текста в связанных текстовых полях
- (void)startCatchChangeTextEvents{
    
    [_notifCenter addObserver:self selector:@selector(channelTextChangedNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

/// Перестать ловить события изменения текста в связанных текстовых полях
- (void)stopCatchChangeTextEvents{
    [_notifCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

/**
    @abstract Обработчик уведомления изменения текста
    @discussion
    Каждый раз, когда текст в текстовых полях изменяется - передать специальном делегату корневой вьюшки информацию об этом изменении - что изменилось и где изменилось
 
    @param channelTextNotification      Объект уведомления (содержит UI-элемент инициатор уведомления)
 */
- (void)channelTextChangedNotification:(NSNotification*)channelTextNotification{
    
    // Извлечь текстового поля и его тип
    HURSSChannelTextField *channelTextField = (HURSSChannelTextField*)channelTextNotification.object;
    HURSSChannelTextFieldType channelFieldType = [_managedChannelRootView getChannelTextFieldType:channelTextField];
    NSString *channelTextURLString = channelTextField.text;
    
    // Передать делегату информацию о событии изенения текста
    if(_managedChannelRootView.textEditingDelegate && [_managedChannelRootView.textEditingDelegate conformsToProtocol:@protocol(HURSSChannelTextChangedDelegate)] && [_managedChannelRootView.textEditingDelegate respondsToSelector:@selector(didTextChanged:forTextField:withFieldType:)]){
        
        [_managedChannelRootView.textEditingDelegate didTextChanged:channelTextURLString forTextField:channelTextField withFieldType:channelFieldType];
    }
}


@end

