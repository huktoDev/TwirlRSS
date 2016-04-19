//
//  HURSSChannelTextField.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 18.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelTextField.h"
#import "HURSSTwirlStyle.h"

@implementation HURSSChannelTextField{
    id<HURSSStyleProtocol> _presentStyle;
}

- (instancetype)init{
    if(self = [super init]){
        
        [self injectDependencies];
        [self configUI];
    }
    return self;
}

- (void)injectDependencies{
    _presentStyle = [HURSSTwirlStyle sharedStyle];
}

- (void)configUI{
    
    // Установить фон
    UIColor *channelTextFieldColor = [_presentStyle channelTextFieldBackColor];
    [self setBackgroundColor:channelTextFieldColor];
    
    // Получить предпочитаемую высоту
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    const CGFloat textFieldCornerRadius = (textFieldSize / 2.f);
    
    // Добавить границы и скругленные углы
    UIColor *borderTextFieldColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.25f];
    CALayer *channelFieldLayer = self.layer;
    [channelFieldLayer setBorderWidth:1.f];
    [channelFieldLayer setBorderColor:borderTextFieldColor.CGColor];
    [channelFieldLayer setCornerRadius:textFieldCornerRadius];
    
    // Задать шрифт
    UIFont *channelTextFont = [_presentStyle channelTextFieldFont];
    [self setFont:channelTextFont];
    
    // Задать цвет
    UIColor *channelTextColor = [_presentStyle channelTextFieldTextColor];
    [self setTextColor:channelTextColor];
}

@end
