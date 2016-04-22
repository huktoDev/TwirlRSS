//
//  HURSSChannelButton.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelButton.h"
#import "HURSSChannelViewStyler.h"
#import "HURSSChannelViewAssembly.h"

@implementation HURSSChannelButton{
    id<HURSSChannelViewStylizationInterface> _presentStyler;
}

#pragma mark - Initialization

- (instancetype)init{
    if(self = [super init]){
        
        // Init Root
        [self injectDependencies];
        [self configUI];
        [self addBaseTouchHandlers];
    }
    return self;
}

#pragma mark - Dependencies

/// Инъекция зависимостей (в данном случае - стиля)
- (void)injectDependencies{
    
    HURSSChannelViewAssembly *viewAssembly = [HURSSChannelViewAssembly defaultAssemblyForChannelView];
    
    _presentStyler = [viewAssembly getViewStyler];
}


#pragma mark - Configuration

/// Установка различных параметров, присущих данному классу кнопок
- (void)configUI{
    
    // Задать фон (автоматически задает фон)
    self.enabled = YES;
    
    // Задать шрифт
    UIFont *channelButtonTitleFont = [_presentStyler channelButtonTextFont];
    [self.titleLabel setFont:channelButtonTitleFont];
    
    // Задать цвет текста кнопки и тайтл
    UIColor *channelButtonTextColor = [_presentStyler channelButtonTextColor];
    [self setTitleColor:channelButtonTextColor forState:UIControlStateNormal];
    
    // Получить предпочитаемую высоту
    const CGFloat buttonSize = [_presentStyler channelUIElementHeight];
    const CGFloat buttonCornerRadius = (buttonSize / 2.f);
    
    // Добавить границы и скругленные углы
    UIColor *borderButtonColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.25f];
    CALayer *channelButtonLayer = self.layer;
    [channelButtonLayer setBorderWidth:1.f];
    [channelButtonLayer setBorderColor:borderButtonColor.CGColor];
    [channelButtonLayer setCornerRadius:buttonCornerRadius];
}


- (void)setTouchHandler:(SEL)actionHandler toTarget:(id)actionTarget{
    
    [self addTarget:actionTarget action:actionHandler forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Touch handlers

/**
    @abstract Добавить обработчики для анимирования нажатия
    @discussion
    У этих кнопок должна быть схожая реакция на нажатия. Поэтому подписываюсь на обработку событий тачей, и выполняю соответствующие анимации сжатия/разжатия
 */
- (void)addBaseTouchHandlers{
    
    [self addTarget:self action:@selector(channelButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(channelButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(channelButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(channelButtonTouchUpOutside:) forControlEvents:UIControlEventTouchCancel];
}


- (void)setEnabled:(BOOL)enabled{
    
    [super setEnabled:enabled];
    
    UIColor *buttonBackgroundColor =  [_presentStyler channelButtonBackColor];
    UIColor *buttonDisabledBackgroundColor = [buttonBackgroundColor colorWithAlphaComponent:0.5f];
    
    self.backgroundColor = enabled ? buttonBackgroundColor : buttonDisabledBackgroundColor;
}

/// Событие тач-дауна (сжать кнопку)
- (void)channelButtonTouchDown:(UIButton*)channelButton{
    
    [self performDirectCompresionAnimation];
}

/// Событие тач аута внутри кнопки (разжать кнопку)
- (void)channelButtonTouchUpInside:(UIButton*)channelButton{
    
    [self performReverseCompressionAnimation];
}

/// Событие тач аута изнутри кнопки, либо touch cancel (разжать кнопку)
- (void)channelButtonTouchUpOutside:(UIButton*)channelButton{
    
    [self performReverseCompressionAnimation];
}


#pragma mark - COMPRESS Anim

/// Запустить анимацию сжатия кнопки
- (void)performDirectCompresionAnimation{
    
    const NSTimeInterval compressAnimDuration = 0.2f;
    UIColor *highlightedColorChannelButton = [_presentStyler channelButtonHighlightedBackColor];
    
    [UIView animateWithDuration:compressAnimDuration animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.85f, 0.92f);
        self.backgroundColor = highlightedColorChannelButton;
    }];
}

/// Запустить анимацию разжатия кнопки (дольше, чем анимация сжатия)
- (void)performReverseCompressionAnimation{
    
    const NSTimeInterval compressAnimDuration = 0.5f;
    UIColor *normalColorChannelButton = [_presentStyler channelButtonBackColor];
    
    [UIView animateWithDuration:compressAnimDuration delay:0.f usingSpringWithDamping:0.18f initialSpringVelocity:0.f options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        self.backgroundColor = normalColorChannelButton;
        
    } completion:nil];
}

@end


