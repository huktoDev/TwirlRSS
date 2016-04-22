//
//  HURSSChannelViewAnimator.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUSelectRSSChannelView.h"
#import "HURSSChannelViewStyler.h"
#import "HURSSChannelViewConfigurator.h"

@protocol HURSSChannelViewAnimatorInterface <NSObject>

@end


@interface HURSSChannelViewAnimator : NSObject <HURSSChannelViewAnimatorInterface>

+ (instancetype)createAnimatorForRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler withConfigurer:(id<HURSSChannelViewConfiguratorInterface>)viewConfigurer;

- (void)performAnimateFallAliasTextFieldWithCompletion:(dispatch_block_t)animCompletion;
- (void)performAnimateFallChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion;
- (void)performAnimateFallChannelRemoveButtonWithCompletion:(dispatch_block_t)animCompletion;

- (void)performAnimateMoveAwayAliasTextFieldWithCompletion:(dispatch_block_t)animCompletion;
- (void)performAnimateMoveAwayChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion;
- (void)performAnimateMoveAwayChannelRemoveButtonWithCompletion:(dispatch_block_t)animCompletion;


- (void)performCreationAliasTextField;
- (void)performDestroyAliasTextField;
- (void)performCreationChannelAddButton;
- (void)performDestroyChannelAddButton;

- (void)performCreationChannelRemoveButton;
- (void)performDestroyChannelRemoveButton;


- (void)performAnimateShowKeyboardWithDuration:(NSTimeInterval)animDuration withKeyboardSize:(CGSize)keyboardSize withCopletionBlock:(dispatch_block_t)keyboardCompletion;
- (void)performAnimateHideKeyboardWithDuration:(NSTimeInterval)animDuration withKeyboardSize:(CGSize)keyboardSize withCopletionBlock:(dispatch_block_t)keyboardCompletion;

@end
