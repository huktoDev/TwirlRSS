//
//  HURSSChannelButton.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelButton.h"
#import "HURSSTwirlStyle.h"

@implementation HURSSChannelButton{
    id<HURSSStyleProtocol> _presentStyle;
}

- (instancetype)init{
    if(self = [super init]){
        
        [self injectDependencies];
        [self configUI];
        [self addBaseTouchHandlers];
    }
    return self;
}

- (void)injectDependencies{
    _presentStyle = [HURSSTwirlStyle sharedStyle];
}

- (void)configUI{
    
    // Задать фон
    UIColor *normalColorChannelButton = [_presentStyle channelButtonBackColor];
    [self setBackgroundColor:normalColorChannelButton];
    
    // Задать шрифт
    UIFont *channelButtonTitleFont = [_presentStyle channelButtonTextFont];
    [self.titleLabel setFont:channelButtonTitleFont];
    
    // Задать цвет текста кнопки и тайтл
    UIColor *channelButtonTextColor = [_presentStyle channelButtonTextColor];
    [self setTitleColor:channelButtonTextColor forState:UIControlStateNormal];
    
    // Получить предпочитаемую высоту
    const CGFloat buttonSize = [_presentStyle channelUIElementHeight];
    const CGFloat buttonCornerRadius = (buttonSize / 2.f);
    
    // Добавить границы и скругленные углы
    UIColor *borderButtonColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.25f];
    CALayer *channelButtonLayer = self.layer;
    [channelButtonLayer setBorderWidth:1.f];
    [channelButtonLayer setBorderColor:borderButtonColor.CGColor];
    [channelButtonLayer setCornerRadius:buttonCornerRadius];
}

- (void)addBaseTouchHandlers{
    
    [self addTarget:self action:@selector(channelButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(channelButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(channelButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(channelButtonTouchUpOutside:) forControlEvents:UIControlEventTouchCancel];
}

- (void)channelButtonTouchDown:(UIButton*)channelButton{
    
    [self performDirectCompresionAnimation];
}

- (void)channelButtonTouchUpInside:(UIButton*)channelButton{
    
    [self performReverseCompressionAnimation];
}

- (void)channelButtonTouchUpOutside:(UIButton*)channelButton{
    
    [self performReverseCompressionAnimation];
}

- (void)performDirectCompresionAnimation{
    
    const NSTimeInterval compressAnimDuration = 0.2f;
    UIColor *highlightedColorChannelButton = [_presentStyle channelButtonHighlightedBackColor];
    
    [UIView animateWithDuration:compressAnimDuration animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.85f, 0.92f);
        self.backgroundColor = highlightedColorChannelButton;
    }];
}

- (void)performReverseCompressionAnimation{
    
    const NSTimeInterval compressAnimDuration = 0.5f;
    UIColor *normalColorChannelButton = [_presentStyle channelButtonBackColor];
    
    [UIView animateWithDuration:compressAnimDuration delay:0.f usingSpringWithDamping:0.18f initialSpringVelocity:0.f options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        self.backgroundColor = normalColorChannelButton;
        
    } completion:nil];
}

@end


