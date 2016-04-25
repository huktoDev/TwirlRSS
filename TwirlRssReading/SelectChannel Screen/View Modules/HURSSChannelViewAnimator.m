//
//  HURSSChannelViewAnimator.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelViewAnimator.h"


@implementation HURSSChannelViewAnimator{
    
    // Указать отложенные действия
    BOOL _needDelayedCreateAliasTextField;
    BOOL _needDelayedDestroyAliasTextField;
    
    BOOL _needDelayedCreateAddButton;
    BOOL _needDelayedDestroyAddButton;
    
    BOOL _needDelayedCreateRemoveButton;
    BOOL _needDelayedDestroyRemoveButton;
    
    // Вьюшка, для которой формируются анимации
    HUSelectRSSChannelView  *_animationChannelView;
    
    // Вспомогательные модули аниматора
    id <HURSSChannelViewConfiguratorInterface> _presentConfigurator;
    
}

#pragma mark - Syntesized STATEs VARs
// Синтезация свойств интерфейса

@synthesize creationAliasTextFieldAnimationEnded = _creationAliasTextFieldAnimationEnded;
@synthesize destroyAliasTextFieldAnimationEnded = _destroyAliasTextFieldAnimationEnded;

@synthesize creationAddButtonAnimationEnded = _creationAddButtonAnimationEnded;
@synthesize destroyAddButtonAnimationEnded = _destroyAddButtonAnimationEnded;

@synthesize creationRemoveButtonAnimationEnded = _creationRemoveButtonAnimationEnded;
@synthesize destroyRemoveButtonAnimationEnded = _destroyRemoveButtonAnimationEnded;


#pragma mark - Construction & Destroying

/**
    @abstract Инициализатор для аниматора вьюшки SelectChannel-экрана
    @discussion
    Для работы аниматора - требуется передать 2 параметра :
    @param channelRootView      Корневая вьюшка, для которой создается аниматор
    @param viewConfigurer        Конфигуратор вьюшки
    @return Готовый аниматор
 */
- (instancetype)initWithRootView:(HUSelectRSSChannelView*)channelRootView withConfigurer:(id<HURSSChannelViewConfiguratorInterface>)viewConfigurer{
    if(self = [super init]){
        
        _animationChannelView = channelRootView;
        _presentConfigurator = viewConfigurer;
        
        _creationAliasTextFieldAnimationEnded = YES;
        _creationAddButtonAnimationEnded = YES;
        _creationRemoveButtonAnimationEnded = YES;
        
        _destroyAliasTextFieldAnimationEnded = YES;
        _destroyAddButtonAnimationEnded = YES;
        _destroyRemoveButtonAnimationEnded = YES;
    }
    return self;
}

/// Конструктор для аниматора (использующий назначенный инициализатор)
+ (instancetype)createAnimatorForRootView:(HUSelectRSSChannelView*)channelRootView withConfigurer:(id<HURSSChannelViewConfiguratorInterface>)viewConfigurer{
    
    HURSSChannelViewAnimator *newManager = [[HURSSChannelViewAnimator alloc] initWithRootView:channelRootView withConfigurer:viewConfigurer];
    return newManager;
}


#pragma mark - FALL Animations

/**
    @abstract Метод анимирования падения текстового поля названия канала
    @discussion
    Когда пользователь вводит более менее валидный URL для канала - ему анимированно показывается текстовое поле для ввода псевдонима канала
 
    @note Анимация выполняется с эффектом пружины (как-будто элемент падает и отскакивает)
    @note Анимированно так-же изменяется размер контента
    @note После окончания анимации - запускает колбэк, после чего пытается уничтожить текст филд, если пользователь уже вновь изменил текст
    @note Менять переменную состояния анимации
 
    @param animCompletion       Обработчик окончания анимации
 */
- (void)performAnimateFallAliasTextFieldWithCompletion:(dispatch_block_t)animCompletion{
    
    _creationAliasTextFieldAnimationEnded = NO;
    [UIView animateWithDuration:0.8f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // Анимировать эти действия (после настройки текст-филда пересобрать макет)
        [_presentConfigurator configPresentLocationAliasTextField];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        // Обработчик окончания анимации
        if(animCompletion){
            animCompletion();
        }
        
        // Если нужно - после создания сразу уничтожить вьюшку
        _creationAliasTextFieldAnimationEnded = YES;
        if(_needDelayedDestroyAliasTextField){
            [_animationChannelView destroyChannelAliasTextField];
            _needDelayedDestroyAliasTextField = NO;
        }
    }];
    
}

/**
    @abstract Метод анимирования падения кнопки добавления
    @discussion
    Когда пользователь вводит достаточно  длинный текст в поле названия канала - анимированно требуется показать кнопку "ДОБАВИТь"
 
    @note Анимация выполняется с эффектом пружины (как-будто элемент падает и отскакивает)
    @note Анимированно так-же изменяется размер контента
    @note После окончания анимации - запускает колбэк, после чего пытается уничтожить кнопку, если пользователь уже вновь изменил текст
    @note Менять переменную состояния анимации
 
    @param animCompletion       Обработчик окончания анимации
 */
- (void)performAnimateFallChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion{
    
    _creationAddButtonAnimationEnded = NO;
    [UIView animateWithDuration:0.8f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // Анимировать эти действия (после настройки кнопки пересобрать макет)
        [_presentConfigurator configPresentLocationChannelAddButton];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        // Обработчик окончания анимации
        if(animCompletion){
            animCompletion();
        }
        
        // Если нужно - после создания сразу уничтожить вьюшку
        _creationAddButtonAnimationEnded = YES;
        if(_needDelayedDestroyAddButton){
            [_animationChannelView destroyChannelAddButton];
            _needDelayedDestroyAddButton = NO;
        }
    }];
}

/**
    @abstract Метод анимирования падения кнопки удаления
    @discussion
    Когда пользователь вводит название канала, которое есть в кеше хранилища - анимированно показывается кнопка "УДАЛИТЬ"
 
    @note Анимация выполняется с эффектом пружины (как-будто элемент падает и отскакивает)
    @note Анимированно так-же изменяется размер контента
    @note После окончания анимации - запускает колбэк, после чего пытается уничтожить кнопку, если пользователь уже вновь изменил текст
    @note Менять переменную состояния анимации
 
    @param animCompletion       Обработчик окончания анимации
 */
- (void)performAnimateFallChannelRemoveButtonWithCompletion:(dispatch_block_t)animCompletion{
    
    _creationRemoveButtonAnimationEnded = NO;
    [UIView animateWithDuration:0.8f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // Анимировать эти действия (после настройки кнопки пересобрать макет)
        [_presentConfigurator configPresentLocationChannelRemoveButton];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        // Обработчик окончания анимации
        if(animCompletion){
            animCompletion();
        }
        
        // Если нужно - после создания сразу уничтожить вьюшку
        _creationRemoveButtonAnimationEnded = YES;
        if(_needDelayedDestroyRemoveButton){
            [_animationChannelView destroyChannelDeleteButton];
            _needDelayedDestroyRemoveButton = NO;
        }
    }];
}


#pragma mark - MOVE AWAY Animations

/**
    @abstract Метод анимирования уезжания влево текстового поля названия канала
    @discussion
    Когда пользователь вводит URL, который более невалиден - убрать текстовое поле с анимацией уезжания. Кроме этого - возвратить лейбл снизу на  прежнее место
 
    @note Анимация выполняется с эффектом пружины
    @note Анимированно так-же изменяется размер контента
    @note После окончания анимации - запускает колбэк, после чего пытается вновь создать текстовое поле (если требуется)
    @note Менять переменную состояния анимации
 
    @param animCompletion       Обработчик окончания анимации
 */
- (void)performAnimateMoveAwayAliasTextFieldWithCompletion:(dispatch_block_t)animCompletion{
    
    // Анимировать эти действия (после настройки текстового поля пересобрать макет)
    _destroyAliasTextFieldAnimationEnded = NO;
    [UIView animateWithDuration:0.85f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configDestroyedLocationAliasTextField];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        // Обработчик окончания анимации
        if(animCompletion){
            animCompletion();
        }
        
        // Если нужно - после уничтожения вновь создать вьюшку
        _destroyAliasTextFieldAnimationEnded = YES;
        if(_needDelayedCreateAliasTextField){
            [_animationChannelView createChannelAliasTextField];
            _needDelayedCreateAliasTextField = NO;
        }
    }];
    
    // Перепривязать лейбл к UI-элементу выше
    [UIView animateWithDuration:0.6f delay:0.2f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configBaseLocationSuggestedLabel];
        [_animationChannelView layoutIfNeeded];
        
    }completion:nil];
}

/**
    @abstract Метод анимирования уезжания влево кнопки "ДОБАВИТЬ"
    @discussion
    Когда пользователь вводит вновь недостаточно длинное название канала - убрать кнопку с анимацией уезжания. Кроме этого - возвратить лейбл снизу на  прежнее место
 
    @note Анимация выполняется с эффектом пружины
    @note Анимированно так-же изменяется размер контента
    @note После окончания анимации - запускает колбэк, после чего пытается вновь создать кнопку (если требуется)
    @note Менять переменную состояния анимации
 
    @param animCompletion       Обработчик окончания анимации
 */
- (void)performAnimateMoveAwayChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion{
    
    // Анимировать эти действия (после настройки кнопки пересобрать макет)
    _destroyAddButtonAnimationEnded = NO;
    [UIView animateWithDuration:0.85f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configDestroyedLocationChannelAddButton];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        // Обработчик окончания анимации
        if(animCompletion){
            animCompletion();
        }
        
        // Если нужно - после уничтожения вновь создать вьюшку
        _destroyAddButtonAnimationEnded = YES;
        if(_needDelayedCreateAddButton){
            [_animationChannelView createChannelAddButton];
            _needDelayedCreateAddButton = NO;
        }
    }];
    
    // Перепривязать лейбл к UI-элементу выше
    [UIView animateWithDuration:0.6f delay:0.2f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configSecondLocationSuggestedLabel];
        [_animationChannelView layoutIfNeeded];
        
    }completion:nil];
}

/**
    @abstract Метод анимирования уезжания влево кнопки "УДАЛИТЬ"
    @discussion
    Когда пользователь вводит вновь неизвестное название канала - убрать кнопку с анимацией уезжания. Кроме этого - возвратить лейбл снизу на  прежнее место
 
    @note Анимация выполняется с эффектом пружины
    @note Анимированно так-же изменяется размер контента
    @note После окончания анимации - запускает колбэк, после чего пытается вновь создать кнопку (если требуется)
    @note Менять переменную состояния анимации
 
    @param animCompletion       Обработчик окончания анимации
 */
- (void)performAnimateMoveAwayChannelRemoveButtonWithCompletion:(dispatch_block_t)animCompletion{
    
    // Анимировать эти действия (после настройки кнопки пересобрать макет)
    _destroyRemoveButtonAnimationEnded = NO;
    [UIView animateWithDuration:0.85f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configDestoyedLocationChannelRemoveButton];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        // Обработчик окончания анимации
        if(animCompletion){
            animCompletion();
        }
        
        // Если нужно - после уничтожения вновь создать вьюшку
        _destroyRemoveButtonAnimationEnded = YES;
        if(_needDelayedCreateRemoveButton){
            [_animationChannelView createChannelDeleteButton];
            _needDelayedCreateRemoveButton = NO;
        }
    }];
    
    // Перепривязать лейбл к UI-элементу выше
    [UIView animateWithDuration:0.6f delay:0.2f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configThirdLocationSuggestedLabel];
        [_animationChannelView layoutIfNeeded];
        
    }completion:nil];
}

#pragma mark - Special ANIMATION States

/// Выполняется ли хотя-бы одна из анимаций?
- (BOOL)isAllChannelAnimationEnded{
    return (_creationAddButtonAnimationEnded && _creationAliasTextFieldAnimationEnded && _creationRemoveButtonAnimationEnded && _destroyAddButtonAnimationEnded && _destroyAliasTextFieldAnimationEnded && _destroyRemoveButtonAnimationEnded);
}

/// Сброс всех отложенных действий
- (void)resetAllDelayedChannelAnimations{
    
    _needDelayedCreateAliasTextField = NO;
    _needDelayedDestroyAliasTextField = NO;
    
    _needDelayedCreateAddButton = NO;
    _needDelayedDestroyAddButton = NO;
    
    _needDelayedCreateRemoveButton = NO;
    _needDelayedDestroyRemoveButton = NO;
}


#pragma mark - PERFORM ANIM Creations

/**
    @abstract Враппер для анимированного создания текстового поля псевдонима
    @discussion
    Если текстовое поле еще не создано, и анимации не выполняются - создать текстовое поле, и анимировать его
    Иначе - ставит анимацию на ожидание
 */
- (void)performAnimatedCreationAliasTextField{
    
    if(! _animationChannelView.channelAliasTextField && [self isAllChannelAnimationEnded]){
        
        [self resetAllDelayedChannelAnimations];
        [_animationChannelView createChannelAliasTextField];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedCreateAliasTextField = YES;
    }
}

/**
    @abstract Враппер для анимированного уничтожения текстового поля псевдонима
    @discussion
    Если текстовое поле еще не создано, и анимации не выполняются - создать текстовое поле, и анимировать его
    Иначе - ставит анимацию на ожидание
 
    @note Если выполняются анимации уничтожения других элементов (могут быть связанными) - все равно выполнить уничтожение
 */
- (void)performAnimatedDestroyAliasTextField{
    
    if( _animationChannelView.channelAliasTextField && (_creationAddButtonAnimationEnded && _creationAliasTextFieldAnimationEnded && _creationRemoveButtonAnimationEnded &&  _destroyAliasTextFieldAnimationEnded)){
        
        [self resetAllDelayedChannelAnimations];
        [_animationChannelView destroyChannelAliasTextField];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedDestroyAliasTextField = YES;
    }
}

/**
    @abstract Враппер для анимированного сздания кнопки добавления канала
    @discussion
    Если кнопка еще не создана, и анимации не выполняются - создать кнопку, и анимировать ее
    Иначе - ставит анимацию на ожидание
 
    @note Если выполняются анимация создания текстового пол уже (связанная) - не блокировать
 */
- (void)performAnimatedCreationChannelAddButton{
    
    if(! _animationChannelView.addChannelButton && (_creationAddButtonAnimationEnded && _creationRemoveButtonAnimationEnded && _destroyAddButtonAnimationEnded && _destroyAliasTextFieldAnimationEnded && _destroyRemoveButtonAnimationEnded)){
        
        [self resetAllDelayedChannelAnimations];
        [_animationChannelView createChannelAddButton];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedCreateAddButton = YES;
    }
}

/**
    @abstract Враппер для анимированного уничтожения кнопки добавления канала
    @discussion
    Если кнопка еще не уничтожена, и анимации не выполняются - унчтожить кнопку, и анимировать это
    Иначе - ставит анимацию на ожидание
 
    @note Если выполняются анимация уничтожения кнопки "удалить" - уже (связанная) - не блокировать
 */
- (void)performAnimatedDestroyChannelAddButton{
    
    if( _animationChannelView.addChannelButton && (_creationAliasTextFieldAnimationEnded && _creationAddButtonAnimationEnded && _creationRemoveButtonAnimationEnded && _destroyAddButtonAnimationEnded && _destroyAliasTextFieldAnimationEnded )){
        
        [self resetAllDelayedChannelAnimations];
        [_animationChannelView destroyChannelAddButton];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedDestroyAddButton = YES;
    }
}

/**
    @abstract Враппер для анимированного создания кнопки удаления канала
    @discussion
    Если кнопка еще не создана, и анимации не выполняются - создать кнопку, и анимировать это
    Иначе - ставит анимацию на ожидание
 
    @note Если выполняется одна из связанных анимаций (анимация создания текстового поля, или кнопки "Добавить") - все равно сразу выполнить анимацию
 */
- (void)performAnimatedCreationChannelRemoveButton{
    
    if(! _animationChannelView.deleteChannelButton && (_creationRemoveButtonAnimationEnded && _destroyAddButtonAnimationEnded && _destroyAliasTextFieldAnimationEnded && _destroyRemoveButtonAnimationEnded)){
        
        [self resetAllDelayedChannelAnimations];
        [_animationChannelView createChannelDeleteButton];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedCreateRemoveButton = YES;
    }
}

/**
    @abstract Враппер для анимированного уничтожения кнопки удаления канала
    @discussion
    Если кнопка еще не уничтожена, и анимации не выполняются - уничтожить кнопку, и анимировать это
    Иначе - ставит анимацию на ожидание
 */
- (void)performAnimatedDestroyChannelRemoveButton{
    
    if( _animationChannelView.deleteChannelButton && [self isAllChannelAnimationEnded]){
        
        [self resetAllDelayedChannelAnimations];
        [_animationChannelView destroyChannelDeleteButton];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedDestroyRemoveButton = YES;
    }
}


#pragma mark - KEYBOARD Animations

/**
    @abstract Анимированный враппер для изменения размера контента
    @discussion
    Когда  показывается клавиатура - запускается этот метод аниматора, в нем выполняются анимированные изменения контента
 
    @param animDuration      Длительность анимации клавиатуры
    @param keyboardSize       Размер клавиатуры (получаемый из уведомления)
    @param keyboardCompletion      Действия после окончания анимации
 */
- (void)performAnimateShowKeyboardWithDuration:(NSTimeInterval)animDuration withKeyboardSize:(CGSize)keyboardSize withCopletionBlock:(dispatch_block_t)keyboardCompletion{
    
    [UIView animateWithDuration:animDuration animations:^{
        
        // Изменить content Inset
        UIEdgeInsets channelViewContentInset = UIEdgeInsetsMake(0.f, 0.f, keyboardSize.height, 0.f);
        [_presentConfigurator configKeyboardWithInsets:channelViewContentInset];
        
    } completion:^(BOOL finished) {
        
        // Запустить колбэк (добавляет тап и таймер)
        if(keyboardCompletion){
            keyboardCompletion();
        }
    }];
}

/**
    @abstract Анимированный враппер для возврата размера контента
    @discussion
    Когда  убирается клавиатура - запускается этот метод аниматора, в нем выполняются анимированные изменения контента
 
    @param animDuration      Длительность анимации клавиатуры
    @param keyboardSize       Размер клавиатуры (получаемый из уведомления)
    @param keyboardCompletion      Действия после окончания анимации
 */
- (void)performAnimateHideKeyboardWithDuration:(NSTimeInterval)animDuration withKeyboardSize:(CGSize)keyboardSize withCopletionBlock:(dispatch_block_t)keyboardCompletion{
    
    [UIView animateWithDuration:animDuration animations:^{
        
        // Изменить content Inset
        UIEdgeInsets channelViewContentInset = UIEdgeInsetsZero;
        [_presentConfigurator configKeyboardWithInsets:channelViewContentInset];
        
    } completion:^(BOOL finished) {
        
        // Запустить колбэк (убрать тап и таймер)
        if(keyboardCompletion){
            keyboardCompletion();
        }
    }];
}




@end
