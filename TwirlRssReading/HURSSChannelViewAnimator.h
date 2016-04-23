//
//  HURSSChannelViewAnimator.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
    @protocol HURSSChannelViewAnimatorInterface
    @author HuktoDev
    @updated 23.04.2016
    @abstract Интерфейс для аниматора вьюшки SelectChannel-экрана
    @discussion
    Предоставляет интерфейс для объекта HURSSChannelViewAnimator, выступающего в роли аниматора вьюшки.
    <b> Основные задачи аниматора : </b>
    <ol type="a">
        <li> Предоставляет состояния анимации </li>
        <li> Выполняет анимации падения элементов при создании </li>
        <li> Выполняет анимации смещения при удалении </li>
        <li> Выполняет анимации клавиатуры </li>
    </ol>
 
    @see
    HURSSChannelViewAnimator \n
    HUSelectRSSChannelView \n
 */
@protocol HURSSChannelViewAnimatorInterface <NSObject>

#pragma mark - ANIMATION STATEs
// Состояния анимаций
@property (assign, nonatomic) BOOL creationAliasTextFieldAnimationEnded;
@property (assign, nonatomic) BOOL destroyAliasTextFieldAnimationEnded;

@property (assign, nonatomic) BOOL creationAddButtonAnimationEnded;
@property (assign, nonatomic) BOOL destroyAddButtonAnimationEnded;

@property (assign, nonatomic) BOOL creationRemoveButtonAnimationEnded;
@property (assign, nonatomic) BOOL destroyRemoveButtonAnimationEnded;


#pragma mark - FALL Animation's
// Анимации падения

- (void)performAnimateFallAliasTextFieldWithCompletion:(dispatch_block_t)animCompletion;
- (void)performAnimateFallChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion;
- (void)performAnimateFallChannelRemoveButtonWithCompletion:(dispatch_block_t)animCompletion;

#pragma mark - MoveAway Animation's
// Анимации уезжания

- (void)performAnimateMoveAwayAliasTextFieldWithCompletion:(dispatch_block_t)animCompletion;
- (void)performAnimateMoveAwayChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion;
- (void)performAnimateMoveAwayChannelRemoveButtonWithCompletion:(dispatch_block_t)animCompletion;


#pragma mark - MoveAway Animation's
// Врапперы для анимированного создания и уничтожения

- (void)performAnimatedCreationAliasTextField;
- (void)performAnimatedDestroyAliasTextField;

- (void)performAnimatedCreationChannelAddButton;
- (void)performAnimatedDestroyChannelAddButton;

- (void)performAnimatedCreationChannelRemoveButton;
- (void)performAnimatedDestroyChannelRemoveButton;


#pragma mark - KEYBOARD's Animation's
// Анимации клавиатуры

- (void)performAnimateShowKeyboardWithDuration:(NSTimeInterval)animDuration withKeyboardSize:(CGSize)keyboardSize withCopletionBlock:(dispatch_block_t)keyboardCompletion;
- (void)performAnimateHideKeyboardWithDuration:(NSTimeInterval)animDuration withKeyboardSize:(CGSize)keyboardSize withCopletionBlock:(dispatch_block_t)keyboardCompletion;



@end

/**
    @class HURSSChannelViewAnimator
    @author HuktoDev
    @updated 23.04.2016
    @abstract Является реализацией протокола аниматора
    @discussion
    Реализует все методы данного протокола (по идее, можно подставлять другие аниматоры (чем осуществляется инверсия зависимостей))
    
    @note Использует в своей деятельность модуль конфигуратора вьюшки (для того, чтобы знать местоположения)
    @note Имеет удобный конструктор
 */
@interface HURSSChannelViewAnimator : NSObject <HURSSChannelViewAnimatorInterface>

+ (instancetype)createAnimatorForRootView:(HUSelectRSSChannelView*)channelRootView withConfigurer:(id<HURSSChannelViewConfiguratorInterface>)viewConfigurer;



@end








