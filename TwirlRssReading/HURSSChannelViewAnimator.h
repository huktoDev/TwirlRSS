//
//  HURSSChannelViewAnimator.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUSelectRSSChannelView.h"
#import "HURSSTwirlStyle.h"
#import "HURSSChannelViewConfigurator.h"

@interface HURSSChannelViewAnimator : NSObject

+ (instancetype)createAnimatorForRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSStyleProtocol>)viewStyler withConfigurer:(id<HURSSChannelViewConfiguratorInterface>)viewConfigurer;

- (void)performAnimateFallAliasTextFieldWithCompletion:(dispatch_block_t)animCompletion;
- (void)performAnimateFallChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion;

- (void)performAnimateMoveAwayAliasTextFieldWithCompletion:(dispatch_block_t)animCompletion;
- (void)performAnimateMoveAwayChannelAddButtonWithCompletion:(dispatch_block_t)animCompletion;

- (void)performCreationAliasTextField;
- (void)performDestroyAliasTextField;
- (void)performCreationChannelAddButton;
- (void)performDestroyChannelAddButton;


@end
