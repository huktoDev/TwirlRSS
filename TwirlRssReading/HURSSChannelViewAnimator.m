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
    
    
    HUSelectRSSChannelView  *_animationChannelView;
    
    id <HURSSStyleProtocol> _presentStyle;
    id <HURSSChannelViewConfiguratorInterface> _presentConfigurator;
    
}

#pragma mark - Construction & Destroying

- (instancetype)initWithRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSStyleProtocol>)viewStyler withConfigurer:(id<HURSSChannelViewConfiguratorInterface>)viewConfigurer{
    if(self = [super init]){
        _animationChannelView = channelRootView;
        _presentStyle = viewStyler;
        _presentConfigurator = viewConfigurer;
        
        
        _creationAliasTextFieldAnimationEnded = YES;
        _creationAddButtonAnimationEnded = YES;
        
        _destroyAddButtonAnimationEnded = YES;
        _destroyAliasTextFieldAnimationEnded = YES;
    }
    return self;
}

/// Конструктор для конфигуратора
+ (instancetype)createAnimatorForRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSStyleProtocol>)viewStyler withConfigurer:(id<HURSSChannelViewConfiguratorInterface>)viewConfigurer{
    
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
}

- (void)performAnimateFallChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion{
    
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
        
    }completion:nil];
}


- (BOOL)isAllChannelAnimationEnded{
    return (_creationAddButtonAnimationEnded && _creationAliasTextFieldAnimationEnded && _destroyAddButtonAnimationEnded && _destroyAliasTextFieldAnimationEnded);
}

- (void)resetAllDelayedChannelAnimations{
    
    _needDelayedCreateAddButton = NO;
    _needDelayedDestroyAddButton = NO;
    _needDelayedDestroyAliasTextField = NO;
    _needDelayedCreateAliasTextField = NO;
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
    
    if( _animationChannelView.channelAliasTextField && (_creationAddButtonAnimationEnded && _creationAliasTextFieldAnimationEnded && _destroyAliasTextFieldAnimationEnded)){
        
        [self resetAllDelayedChannelAnimations];
        
        [_animationChannelView destroyChannelAliasTextField];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedDestroyAliasTextField = YES;
    }
}

- (void)performCreationChannelAddButton{
    
    if(! _animationChannelView.addChannelButton && (_creationAddButtonAnimationEnded && _destroyAddButtonAnimationEnded && _destroyAliasTextFieldAnimationEnded)){
        
        [self resetAllDelayedChannelAnimations];
        
        [_animationChannelView createChannelAddButton];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        
        _needDelayedCreateAddButton = YES;
    }
}

- (void)performDestroyChannelAddButton{
    
    if( _animationChannelView.addChannelButton && [self isAllChannelAnimationEnded]){
        
        [self resetAllDelayedChannelAnimations];
        
        [_animationChannelView destroyChannelAddButton];
    }else{
        
        [self resetAllDelayedChannelAnimations];
        _needDelayedDestroyAddButton = YES;
    }
}







@end
