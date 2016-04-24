//
//  HURSSChannelViewAssembly.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelViewAssembly.h"

@implementation HURSSChannelViewAssembly{
    
    // Корневая вьюшка
    HUSelectRSSChannelView *_channelView;
    
    // Модули вью-пакета
    id <HURSSTextFieldManagerInterface> _textFieldManager;
    id <HURSSChannelViewStylizationInterface> _presentStyler;
    id <HURSSChannelViewConfiguratorInterface> _presentConfigurator;
    id <HURSSChannelViewAnimatorInterface> _presentAnimator;
    id <HURSSChannelViewPositionRulesInterface> _constraintsFactory;
}


#pragma mark - DEFAULT ASSEMBLY

/// Расшаренная фабрика по-умолчанию
+ (instancetype)defaultAssemblyForChannelView{
    
    static HURSSChannelViewAssembly *_defaultAssembly = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultAssembly = [HURSSChannelViewAssembly new];
    });
    return _defaultAssembly;
}


#pragma mark - CREATE ROOT View

/// При создании новой вьюшки - обнуляются ссылки на модули, инжектировать требуемые модули
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


#pragma mark - ACCESSORs Modules

// Геттер менеджера текстовых полей (с отложенной инициализацией)
- (id <HURSSTextFieldManagerInterface>)getTextFieldManager{
    
    if(! _textFieldManager){
        _textFieldManager = [HURSSChannelTextFieldManager createManagerForRootView:_channelView];
    }
    return _textFieldManager;
}

// Геттер стилизатора вью (с отложенной инициализацией)
- (id <HURSSChannelViewStylizationInterface>)getViewStyler{
    
    if(! _presentStyler){
        _presentStyler = [HURSSChannelViewStyler new];
    }
    return _presentStyler;
}

// Геттер конфигуратора вью (с отложенной инициализацией)
- (id <HURSSChannelViewConfiguratorInterface>)getViewConfigurator{
    
    if(! _presentConfigurator){
        _presentConfigurator = [HURSSChannelViewConfigurator createConfiguratorForRootView:_channelView withStyler:[self getViewStyler] withConstraintsFactory:[self getConstraintsFactory]];
    }
    return _presentConfigurator;
}

// Геттер аниматора вью (с отложенной инициализацией)
- (id <HURSSChannelViewAnimatorInterface>)getViewAnimator{
    
    if(! _presentAnimator){
        _presentAnimator = [HURSSChannelViewAnimator createAnimatorForRootView:_channelView withConfigurer:[self getViewConfigurator]];
    }
    return _presentAnimator;
}

// Геттер правил местоположений вью (с отложенной инициализацией)
- (id <HURSSChannelViewPositionRulesInterface>)getConstraintsFactory{
    
    if(! _constraintsFactory){
        _constraintsFactory = [HURSSChannelViewConstraintsFactory new];
    }
    return _constraintsFactory;
}


@end
