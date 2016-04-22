//
//  HURSSChannelViewAssembly.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelViewAssembly.h"

@implementation HURSSChannelViewAssembly{
    
    HUSelectRSSChannelView *_channelView;
    
    id <HURSSTextFieldManagerInterface> _textFieldManager;
    id <HURSSChannelViewStylizationInterface> _presentStyler;
    id <HURSSChannelViewConfiguratorInterface> _presentConfigurator;
    id <HURSSChannelViewAnimatorInterface> _presentAnimator;
    id <HURSSChannelViewPositionRulesInterface> _constraintsFactory;
}


+ (instancetype)defaultAssemblyForChannelView{
    
    static HURSSChannelViewAssembly *_defaultAssembly = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultAssembly = [HURSSChannelViewAssembly new];
    });
    return _defaultAssembly;
}

- (HUSelectRSSChannelView*)createSelectChannelView{
    
    _textFieldManager = nil;
    _presentStyler = nil;
    _presentConfigurator = nil;
    _presentAnimator = nil;
    _constraintsFactory = nil;
    
    _channelView = [HUSelectRSSChannelView new];
    [_channelView injectDependencies];
    
    return _channelView;
}

- (id <HURSSTextFieldManagerInterface>)getTextFieldManager{
    
    if(! _textFieldManager){
        _textFieldManager = [HURSSChannelTextFieldManager createManagerForRootView:_channelView];
    }
    return _textFieldManager;
}

- (id <HURSSChannelViewStylizationInterface>)getViewStyler{
    
    if(! _presentStyler){
        _presentStyler = [HURSSChannelViewStyler new];
    }
    return _presentStyler;
}

- (id <HURSSChannelViewConfiguratorInterface>)getViewConfigurator{
    
    if(! _presentConfigurator){
        _presentConfigurator = [HURSSChannelViewConfigurator createConfiguratorForRootView:_channelView withStyler:[self getViewStyler] withConstraintsFactory:[self getConstraintsFactory]];
    }
    return _presentConfigurator;
}

- (id <HURSSChannelViewAnimatorInterface>)getViewAnimator{
    
    if(! _presentAnimator){
        _presentAnimator = [HURSSChannelViewAnimator createAnimatorForRootView:_channelView withStyler:[self getViewStyler] withConfigurer:[self getViewConfigurator]];
    }
    return _presentAnimator;
}

- (id <HURSSChannelViewPositionRulesInterface>)getConstraintsFactory{
    
    if(! _constraintsFactory){
        _constraintsFactory = [HURSSChannelViewConstraintsFactory new];
    }
    return _constraintsFactory;
}


@end
