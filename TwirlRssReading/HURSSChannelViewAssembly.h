//
//  HURSSChannelViewAssembly.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HUSelectRSSChannelView.h"
#import "HURSSChannelViewStyler.h"
#import "HURSSChannelTextFieldManager.h"
#import "HURSSChannelViewConfigurator.h"
#import "HURSSChannelViewAnimator.h"
#import "HURSSChannelViewConstraintsFactory.h"


@interface HURSSChannelViewAssembly : NSObject

+ (instancetype)defaultAssemblyForChannelView;

- (HUSelectRSSChannelView*)createSelectChannelView;

- (id <HURSSTextFieldManagerInterface>)getTextFieldManager;
- (id <HURSSChannelViewStylizationInterface>)getViewStyler;
- (id <HURSSChannelViewConfiguratorInterface>)getViewConfigurator;
- (id <HURSSChannelViewAnimatorInterface>)getViewAnimator;
- (id <HURSSChannelViewPositionRulesInterface>)getConstraintsFactory;

@end
