//
//  HUSplashTransitionAnimator.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSplashTransitionAnimator.h"

/**
    @constant HU_CA_ANIMATION_ID_KEY
        Ключ для запоминания ID анимации CAAnimation
 
    @constant HURotateTransitionAnimKey
        Ключ для анимации вращения CAAnimation
    @constant HUScaleTransitionAnimKey
        Ключ для анимации скейлинга CAAnimation
 */

NSString *const HU_CA_ANIMATION_ID_KEY = @"animationID";
NSString *const HURotateTransitionAnimKey = @"rotateTransitionSplashAnim";
NSString *const HUScaleTransitionAnimKey = @"scaleTransitionSplashAnim";


@implementation HUSplashTransitionAnimator{
    
    //MARK: Думал изначально передавать переменные в методы (а не использовать переменные класса), но методы с количеством переменных более 2х - редко бывают удобны, и не слишком читабельны
    
    dispatch_group_t _dispatchAnimGroup;
    
    id<UIViewControllerContextTransitioning> _currentTransitionContext;
    
    CGFloat _firstPartTransitionDuration;
    CGFloat _secondPartTransitionDuration;
    
    UIView *_fromView;
    UIView *_toView;
}


#pragma mark - UIViewControllerAnimatedTransitioning IMP

/// Сообщаем контексту длительность перехода
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 2.2f;
}

/**
    @abstract Реализация метода анимирования перехода
    @discussion
    Вся последовательность выполнения состоит из 4х частей :
    <ol type="1">
        <li> Подготовить различные переменные (получить вьюшки, добавить вьюшки, рассчитать длительность анимаций) </li>
        <li> Выполнить первую часть перехода </li>
        <li> Выполнить вторую часть перехода </li>
        <li> Выполнить колбэк (сообщить контексту об окончании анимаций, и раздизейблить UI) </li>
    </ol>
 
    @param transitionContext         Контекст перехода, содержащий некоторую важную информацию для перехода
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    // Запомнить контекст
    _currentTransitionContext = transitionContext;
    
    // Если аниматору был передан некорректный тип перехода
    NSAssert(self.needPresenting, @"Incorrect USE HUSplashTransitionAnimator (needPresenting must be already set to YES)");
    
    // Извлечь source & destination Views
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    _fromView = fromViewController.view;
    _toView = toViewController.view;
    
    if (self.needPresenting) {
        
        // Дизейблим UI
        transitionContext.containerView.userInteractionEnabled = NO;
        _fromView.userInteractionEnabled = NO;
        _toView.userInteractionEnabled = NO;
        
        // Добавляем вьюшки на контекст
        [transitionContext.containerView addSubview:_fromView];
        [transitionContext.containerView insertSubview:_toView belowSubview:_fromView];
        
        // Рассчитываем длительность анимаций
        CGFloat transitionDuration = [self transitionDuration:transitionContext];
        _firstPartTransitionDuration = transitionDuration * 0.55f;
        _secondPartTransitionDuration = transitionDuration - _firstPartTransitionDuration;
        
        // Запускаю первую часть перехода
        [self performFirstPartAnimation];
    }
}


#pragma mark - PERFORM Animations

/// Выполнить первую часть анимации (только скейлит, с эффектом пружины, и запускает после вторую часть)
- (void)performFirstPartAnimation{

    [UIView animateWithDuration:_firstPartTransitionDuration delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // Заскейлить (слегка уменьшить вьюшку)
        _fromView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
    }completion:^(BOOL finished) {
        
        // По окончании - запустить вторую часть анимации
        [self performSecondPartAnimation];
    }];
}

/**
    @abstract Метод выполнения второй части анимации
    @discussion
    Запускается после окончания первой части.
    Осуществляет 3 обособленные транзакции в Core Animation :
    <ul>
        <li> Добавляет транзакцию через UIView (с center и alpha свойствами) </li>
        <li> Добавляет транзкцию через возможности слоя (вращение слоя через transform.rotate) </li>
        <li> Добавляет транзакцию черех возможности слоя (скейлинг слоя через transform.scale) </li>
    </ul>
 
    @note Использует возможности GCD dispatch_group для задания общего completion-обработчика (через dispatch_enter / dispatch_leave)
    @note completion-обработчик раздизейбливает UI, и сообщает контексту об окончании анимации
 */
- (void)performSecondPartAnimation{
    
    // Создать диспатч-группу для того, чтобы поймать общий колбэк
    _dispatchAnimGroup = dispatch_group_create();
    dispatch_group_enter(_dispatchAnimGroup);
    
    CGFloat animationDuration = _secondPartTransitionDuration;
    // Добавить анимации
    [self addSimpleViewSecondAnimationsWithDuration:animationDuration toView:_fromView withDispatchGroup:_dispatchAnimGroup];
    [self addRotationAnimationWithDuration:animationDuration toLayer:_fromView.layer withDispatchGroup:_dispatchAnimGroup];
    [self addScaleAnimationWithDuration:animationDuration toLayer:_fromView.layer withDispatchGroup:_dispatchAnimGroup];
    
    // Общий колбэк всех анимаций
    dispatch_group_leave(_dispatchAnimGroup);
    dispatch_group_notify(_dispatchAnimGroup, dispatch_get_main_queue(), ^{
        
        _fromView.userInteractionEnabled = YES;
        _toView.userInteractionEnabled = YES;
        _currentTransitionContext.containerView.userInteractionEnabled = YES;
        
        [_currentTransitionContext completeTransition:YES];
    });
}


#pragma mark - Add Second Part Animations

/**
    @abstract Метод, выполняющий создание и добавление первой транзакции в Core Animation
    @discussion
    Использует dispatch_group, смещает исходную вьюшку налево, и делает ее практически невидимой
 
    @param animDuration      Длительность анимации
    @param animatingView      Вью, который требуется анимировать
    @param animDispatchGroup      Группа диспетчеризации, для синхронизации
 */
- (void)addSimpleViewSecondAnimationsWithDuration:(CGFloat)animDuration toView:(UIView*)animatingView withDispatchGroup:(dispatch_group_t)animDispatchGroup{
    
    dispatch_group_enter(animDispatchGroup);
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat widthScreen = CGRectGetWidth(screenBounds);
    [UIView animateWithDuration:animDuration animations:^{
        
        animatingView.center = CGPointMake(animatingView.center.x - widthScreen, animatingView.center.y);
        animatingView.alpha = 0.2f;
        
    }completion:^(BOOL finished) {
        
        dispatch_group_leave(animDispatchGroup);
    }];
}

/**
    @abstract Метод, выполняющий создание и добавление второй транзакции в Core Animation
    @discussion
    Использует dispatch_group, вращает исходный слой (использует CAKeyFrameAnimation, чтобы сделать поэтапную анимацию)
 
    @param animDuration      Длительность анимации
    @param animatingLayer      Слой, который требуется анимировать
    @param animDispatchGroup      Группа диспетчеризации, для синхронизации
 */
- (CAAnimation*)addRotationAnimationWithDuration:(CGFloat)animDuration toLayer:(CALayer*)animatingLayer withDispatchGroup:(dispatch_group_t)animDispatchGroup{
    
    dispatch_group_enter(animDispatchGroup);
    
    CAKeyframeAnimation *rotationViewAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationViewAnimation.values = @[@(0.f), @(- M_PI_2), @(-M_PI), @(- M_PI - M_PI_2), @(0.f)];
    rotationViewAnimation.keyTimes = @[@0.f, @0.4f, @0.65f, @0.88f, @1.f];
    
    rotationViewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationViewAnimation.duration = animDuration;
    rotationViewAnimation.repeatCount = 1;
    
    rotationViewAnimation.fillMode = kCAFillModeForwards;
    
    rotationViewAnimation.delegate = self;
    [rotationViewAnimation setValue:HURotateTransitionAnimKey forKey:HU_CA_ANIMATION_ID_KEY];
    [animatingLayer addAnimation:rotationViewAnimation forKey:HURotateTransitionAnimKey];
    
    return rotationViewAnimation;
}

/**
    @abstract Метод, выполняющий создание и добавление третьей транзакции в Core Animation
    @discussion
    Использует dispatch_group, уменьшает в размере исходный слой (использует CABasicAnimation, так как требуется простая анимация)
 
    @param animDuration      Длительность анимации
    @param animatingLayer      Слой, который требуется анимировать
    @param animDispatchGroup      Группа диспетчеризации, для синхронизации
 */
- (CAAnimation*)addScaleAnimationWithDuration:(CGFloat)animDuration toLayer:(CALayer*)animatingLayer withDispatchGroup:(dispatch_group_t)animDispatchGroup{
    
    dispatch_group_enter(animDispatchGroup);
    
    CATransform3D startTransform = animatingLayer.transform;
    CATransform3D endTransform = CATransform3DMakeScale(0.2f, 0.2f, 1.f);
    
    CABasicAnimation *scaleViewAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleViewAnimation.fromValue = [NSValue valueWithCATransform3D: startTransform];
    scaleViewAnimation.toValue = [NSValue valueWithCATransform3D: endTransform];
    
    scaleViewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleViewAnimation.duration = animDuration;
    scaleViewAnimation.repeatCount = 1;
    
    scaleViewAnimation.fillMode = kCAFillModeForwards;
    
    scaleViewAnimation.delegate = self;
    [scaleViewAnimation setValue:HUScaleTransitionAnimKey forKey:HU_CA_ANIMATION_ID_KEY];
    [animatingLayer addAnimation:scaleViewAnimation forKey:HUScaleTransitionAnimKey];
    
    return scaleViewAnimation;
}


#pragma mark - CAAnimationDelegate IMP

/**
    @abstract Метод делегата CAAnimationDelegate, отлавливающий моменты окончания анимаций CAAimation
    @discussion
    Для распознания анимаций используюся возможности KVC (к объектам прикрепляется специальный ID), с помощью этого ID отлавливается, какая именно анимация окончила выполнение.
 
    Вызывается только  для синхронизации колбэка, при каждой анимации асинхронный семафор GCD
 
    @param anim      Объект завершенной анимации
    @param flag      Хрен знает, по идее никогда не использовал этот флаг ;)
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSString *animationKey = [anim valueForKey:HU_CA_ANIMATION_ID_KEY];
    BOOL isRotationAnimStopped = [animationKey isEqualToString:HURotateTransitionAnimKey];
    BOOL isScaleAnimStopped = [animationKey isEqualToString:HUScaleTransitionAnimKey];
    
    if(isRotationAnimStopped || isScaleAnimStopped){
        dispatch_group_leave(_dispatchAnimGroup);
    }
}


@end




