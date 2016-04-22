//
//  HURSSChannelViewAnimator.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelViewAnimator.h"


@implementation HURSSChannelViewAnimator{
    
    BOOL _needDelayedCreateAliasTextField;
    BOOL _needDelayedDestroyAliasTextField;
    BOOL _creationAliasTextFieldAnimationEnded;
    BOOL _destroyAliasTextFieldAnimationEnded;
    
    BOOL _needDelayedCreateAddButton;
    BOOL _needDelayedDestroyAddButton;
    BOOL _creationAddButtonAnimationEnded;
    BOOL _destroyAddButtonAnimationEnded;
    
    BOOL _needDelayedCreateRemoveButton;
    BOOL _needDelayedDestroyRemoveButton;
    BOOL _creationRemoveButtonAnimationEnded;
    BOOL _destroyRemoveButtonAnimationEnded;
    
    
    HUSelectRSSChannelView  *_animationChannelView;
    
    id <HURSSChannelViewStylizationInterface> _presentStyle;
    id <HURSSChannelViewConfiguratorInterface> _presentConfigurator;
    
}

#pragma mark - Construction & Destroying

- (instancetype)initWithRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler withConfigurer:(id<HURSSChannelViewConfiguratorInterface>)viewConfigurer{
    if(self = [super init]){
        _animationChannelView = channelRootView;
        _presentStyle = viewStyler;
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

/// Конструктор для конфигуратора
+ (instancetype)createAnimatorForRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler withConfigurer:(id<HURSSChannelViewConfiguratorInterface>)viewConfigurer{
    
    HURSSChannelViewAnimator *newManager = [[HURSSChannelViewAnimator alloc] initWithRootView:channelRootView withStyler:viewStyler withConfigurer:viewConfigurer];
    return newManager;
}


- (void)performAnimateFallAliasTextFieldWithCompletion:(dispatch_block_t)animCompletion{
    
    _creationAliasTextFieldAnimationEnded = NO;
    [UIView animateWithDuration:0.8f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configPresentLocationAliasTextField];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        if(animCompletion){
            animCompletion();
        }
        
        _creationAliasTextFieldAnimationEnded = YES;
        if(_needDelayedDestroyAliasTextField){
            [_animationChannelView destroyChannelAliasTextField];
            _needDelayedDestroyAliasTextField = NO;
        }
    }];
    
    [UIView animateWithDuration:0.6f delay:0.2f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //[_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:nil];
}

- (void)performAnimateFallChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion{
    
    _creationAddButtonAnimationEnded = NO;
    [UIView animateWithDuration:0.8f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configPresentLocationChannelAddButton];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        if(animCompletion){
            animCompletion();
        }
        
        _creationAddButtonAnimationEnded = YES;
        if(_needDelayedDestroyAddButton){
            [_animationChannelView destroyChannelAddButton];
            _needDelayedDestroyAddButton = NO;
        }
    }];
    
    [UIView animateWithDuration:0.6f delay:0.2f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //[_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:nil];
}

- (void)performAnimateFallChannelRemoveButtonWithCompletion:(dispatch_block_t)animCompletion{
    
    _creationRemoveButtonAnimationEnded = NO;
    [UIView animateWithDuration:0.8f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configPresentLocationChannelRemoveButton];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        if(animCompletion){
            animCompletion();
        }
        
        _creationRemoveButtonAnimationEnded = YES;
        if(_needDelayedDestroyRemoveButton){
            [_animationChannelView destroyChannelDeleteButton];
            _needDelayedDestroyRemoveButton = NO;
        }
    }];
}

- (void)performAnimateMoveAwayAliasTextFieldWithCompletion:(dispatch_block_t)animCompletion{
    
    _destroyAliasTextFieldAnimationEnded = NO;
    
    [UIView animateWithDuration:1.1f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configDestroyedLocationAliasTextField];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        if(animCompletion){
            animCompletion();
        }
        
        _destroyAliasTextFieldAnimationEnded = YES;
        if(_needDelayedCreateAliasTextField){
            [_animationChannelView createChannelAliasTextField];
            _needDelayedCreateAliasTextField = NO;
        }
    }];
    
    [UIView animateWithDuration:0.6f delay:0.2f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configBaseLocationSuggestedLabel];
        [_animationChannelView layoutIfNeeded];
        
    }completion:nil];
}

- (void)performAnimateMoveAwayChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion{
    
    _destroyAddButtonAnimationEnded = NO;
    
    [UIView animateWithDuration:1.1f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configDestroyedLocationChannelAddButton];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        if(animCompletion){
            animCompletion();
        }
        
        _destroyAddButtonAnimationEnded = YES;
        if(_needDelayedCreateAddButton){
            [_animationChannelView createChannelAddButton];
            _needDelayedCreateAddButton = NO;
        }
    }];
    
    [UIView animateWithDuration:0.6f delay:0.2f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configSecondLocationSuggestedLabel];
        [_animationChannelView layoutIfNeeded];
        //[_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:nil];
}

- (void)performAnimateMoveAwayChannelRemoveButtonWithCompletion:(dispatch_block_t)animCompletion{
    
    _destroyRemoveButtonAnimationEnded = NO;
    
    [UIView animateWithDuration:1.1f delay:0.f usingSpringWithDamping:0.25f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configDestoyedLocationChannelRemoveButton];
        [_animationChannelView layoutIfNeeded];
        [_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:^(BOOL finished) {
        
        if(animCompletion){
            animCompletion();
        }
        
        _destroyRemoveButtonAnimationEnded = YES;
        if(_needDelayedCreateRemoveButton){
            [_animationChannelView createChannelDeleteButton];
            _needDelayedCreateRemoveButton = NO;
        }
    }];
    
    [UIView animateWithDuration:0.6f delay:0.2f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_presentConfigurator configThirdLocationSuggestedLabel];
        [_animationChannelView layoutIfNeeded];
        //[_animationChannelView updateContentSizeWithLayout:YES];
        
    }completion:nil];
}


- (BOOL)isAllChannelAnimationEnded{
    return (_creationAddButtonAnimationEnded && _creationAliasTextFieldAnimationEnded && _creationRemoveButtonAnimationEnded && _destroyAddButtonAnimationEnded && _destroyAliasTextFieldAnimationEnded && _destroyRemoveButtonAnimationEnded);
}

- (void)resetAllDelayedChannelAnimations{
    
    _needDelayedCreateAliasTextField = NO;
    _needDelayedDestroyAliasTextField = NO;
    
    _needDelayedCreateAddButton = NO;
    _needDelayedDestroyAddButton = NO;
    
    _needDelayedCreateRemoveButton = NO;
    _needDelayedDestroyRemoveButton = NO;
}


- (void)performCreationAliasTextField{
    
    if(! _animationChannelView.channelAliasTextField && [self isAllChannelAnimationEnded]){
        
        [self resetAllDelayedChannelAnimations];
        
        [_animationChannelView createChannelAliasTextField];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedCreateAliasTextField = YES;
    }
}

- (void)performDestroyAliasTextField{
    
    if( _animationChannelView.channelAliasTextField && (_creationAddButtonAnimationEnded && _creationAliasTextFieldAnimationEnded && _creationRemoveButtonAnimationEnded &&  _destroyAliasTextFieldAnimationEnded)){
        
        [self resetAllDelayedChannelAnimations];
        
        [_animationChannelView destroyChannelAliasTextField];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedDestroyAliasTextField = YES;
    }
}

- (void)performCreationChannelAddButton{
    
    if(! _animationChannelView.addChannelButton && (_creationAddButtonAnimationEnded && _creationRemoveButtonAnimationEnded && _destroyAddButtonAnimationEnded && _destroyAliasTextFieldAnimationEnded && _destroyRemoveButtonAnimationEnded)){
        
        [self resetAllDelayedChannelAnimations];
        
        [_animationChannelView createChannelAddButton];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        
        _needDelayedCreateAddButton = YES;
    }
}

- (void)performDestroyChannelAddButton{
    
    if( _animationChannelView.addChannelButton && (_creationAliasTextFieldAnimationEnded && _creationAddButtonAnimationEnded && _creationRemoveButtonAnimationEnded && _destroyAddButtonAnimationEnded && _destroyAliasTextFieldAnimationEnded )){
        
        [self resetAllDelayedChannelAnimations];
        
        [_animationChannelView destroyChannelAddButton];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedDestroyAddButton = YES;
    }
}

- (void)performCreationChannelRemoveButton{
    
    if(! _animationChannelView.deleteChannelButton && (_creationRemoveButtonAnimationEnded && _destroyAddButtonAnimationEnded && _destroyAliasTextFieldAnimationEnded && _destroyRemoveButtonAnimationEnded)){
        
        [self resetAllDelayedChannelAnimations];
        
        [_animationChannelView createChannelDeleteButton];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedCreateRemoveButton = YES;
    }
}

- (void)performDestroyChannelRemoveButton{
    
    if( _animationChannelView.deleteChannelButton && [self isAllChannelAnimationEnded]){
        
        [self resetAllDelayedChannelAnimations];
        
        [_animationChannelView destroyChannelDeleteButton];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedDestroyRemoveButton = YES;
    }
}


- (void)performAnimateShowKeyboardWithDuration:(NSTimeInterval)animDuration withKeyboardSize:(CGSize)keyboardSize withCopletionBlock:(dispatch_block_t)keyboardCompletion{
    
    [UIView animateWithDuration:animDuration animations:^{
        
        UIEdgeInsets channelViewContentInset = UIEdgeInsetsMake(0.f, 0.f, keyboardSize.height, 0.f);
        [_presentConfigurator configKeyboardWithInsets:channelViewContentInset];
        
    } completion:^(BOOL finished) {
        // Запустить колбэк (добавляет тап и таймер)
        if(keyboardCompletion){
            keyboardCompletion();
        }
    }];
}


- (void)performAnimateHideKeyboardWithDuration:(NSTimeInterval)animDuration withKeyboardSize:(CGSize)keyboardSize withCopletionBlock:(dispatch_block_t)keyboardCompletion{
    
    [UIView animateWithDuration:animDuration animations:^{
        
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
