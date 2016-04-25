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

#import "BLMultiColorLoader.h"

@implementation HURSSChannelButton{
    
    // Вьюшка экрана (для отправления энейбл/дизейбл событий)
    __weak HUSelectRSSChannelView *_parentView;
    
    // Кастомный активити
    BLMultiColorLoader *_loaderIndicator;
    
    // Стилизатор кнопки
    id<HURSSChannelViewStylizationInterface> _presentStyler;
}

#pragma mark - Initialization

- (instancetype)initWithRootView:(HUSelectRSSChannelView*)rootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler{
    if(self = [super init]){
        
        _parentView =  rootView;
        _presentStyler = viewStyler;
        
        [self configUI];
        [self addBaseTouchHandlers];
        [self disableMultiTouch];
    }
    return self;
}

+ (instancetype)channelButtonWithRootView:(HUSelectRSSChannelView*)rootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler{
    
    HURSSChannelButton *newChannelButton = [[HURSSChannelButton alloc] initWithRootView:rootView withStyler:viewStyler];
    return newChannelButton;
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
    [channelButtonLayer setBorderWidth:2.f];
    [channelButtonLayer setBorderColor:borderButtonColor.CGColor];
    [channelButtonLayer setCornerRadius:buttonCornerRadius];
}



#pragma mark - EXTERNAL Touch Handling

/// Назначение обработчик действия на кнопку (на тач ап)
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


#pragma mark - Waiting Indicator

/// Добавить индикацию ожидания на кнопку
- (void)startWaitingIndicator{
    
    // Вычисление фреймов и местоположения
    const CGFloat indicatorHeight = 32.f;
    CGRect loaderIndicatorBounds = CGRectMake(0.f, 0.f, indicatorHeight, indicatorHeight);
    CGPoint loaderIndicatorCenter = CGPointMake(CGRectGetWidth(self.frame) / 2.f, CGRectGetHeight(self.frame) / 2.f);
    
    // Инициализация индикатора
    _loaderIndicator = [BLMultiColorLoader new];
    
    // Параметризация индикатора
    _loaderIndicator.backgroundColor = [UIColor clearColor];
    _loaderIndicator.lineWidth = 4.0;
    
    // Определение и установка цветов индикатора
    UIColor *firstColor = [[UIColor redColor] colorWithAlphaComponent:0.6f];
    UIColor *secondColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.6f];
    UIColor *thirdColor = [[UIColor yellowColor] colorWithAlphaComponent:0.6f];
    
    _loaderIndicator.colorArray = @[firstColor, secondColor, thirdColor];
    
    // Задание фрейма
    [_loaderIndicator setBounds:loaderIndicatorBounds];
    [_loaderIndicator setCenter:loaderIndicatorCenter];
    
    // Добавить на кнопку, и стартовать анимаци
    [self addSubview:_loaderIndicator];
    [_loaderIndicator startAnimation];
}

/// Снять индикацию ожидания с кнопки
- (void)endWaitingIndicator{
    
    // Останавливает анимацию, и убирает вьюшку
    [_loaderIndicator stopAnimation];
    [_loaderIndicator removeFromSuperview];
    _loaderIndicator = nil;
}


@end


