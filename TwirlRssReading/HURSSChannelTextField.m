//
//  HURSSChannelTextField.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 18.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelTextField.h"
#import "HURSSChannelViewStyler.h"
#import "HURSSChannelViewAssembly.h"

@implementation HURSSChannelTextField{
    
    UIImageView *_iconImageView;
    
    id<HURSSChannelViewStylizationInterface> _presentStyler;
}

- (instancetype)init{
    if(self = [super init]){
        
        [self injectDependencies];
        [self configUI];
    }
    return self;
}

- (void)injectDependencies{
    
    HURSSChannelViewAssembly *channelViewAssembly = [HURSSChannelViewAssembly defaultAssemblyForChannelView];
    _presentStyler = [channelViewAssembly getViewStyler];
}

- (void)configUI{
    
    // Установить фон
    UIColor *channelTextFieldColor = [_presentStyler channelTextFieldBackColor];
    [self setBackgroundColor:channelTextFieldColor];
    
    // Получить предпочитаемую высоту
    const CGFloat textFieldSize = [_presentStyler channelUIElementHeight];
    const CGFloat textFieldCornerRadius = (textFieldSize / 2.f);
    
    // Добавить границы и скругленные углы
    UIColor *borderTextFieldColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.25f];
    CALayer *channelFieldLayer = self.layer;
    [channelFieldLayer setBorderWidth:1.f];
    [channelFieldLayer setBorderColor:borderTextFieldColor.CGColor];
    [channelFieldLayer setCornerRadius:textFieldCornerRadius];
    
    // Задать шрифт
    UIFont *channelTextFont = [_presentStyler channelTextFieldFont];
    [self setFont:channelTextFont];
    
    // Задать цвет
    UIColor *channelTextColor = [_presentStyler channelTextFieldTextColor];
    [self setTextColor:channelTextColor];
    
    // Задать цвет курсора
    UIColor *cursorChannelFieldColor = [_presentStyler selectChannelScreenColor];
    [self setTintColor:cursorChannelFieldColor];
    
    
    // Создать ImageView для иконки (пока не заполняя ее конкретной картинкой)
    const CGFloat SIDE_SIZE_TEXTFIELD_ICON = 25.f;
    const CGRect baseTextFieldIconBounds = CGRectMake(0.f, 0.f, SIDE_SIZE_TEXTFIELD_ICON, SIDE_SIZE_TEXTFIELD_ICON);
    const CGRect wrapperImageBounds = CGRectMake(0.f, 0.f, 2.f * SIDE_SIZE_TEXTFIELD_ICON, SIDE_SIZE_TEXTFIELD_ICON);
    
    UIImageView *textFieldImageView = [[UIImageView alloc] initWithFrame:baseTextFieldIconBounds];
    textFieldImageView.contentMode = UIViewContentModeScaleToFill;
    textFieldImageView.alpha = 0.6f;
    
    UIView *offsetWrapperView = [[UIView alloc] initWithFrame:wrapperImageBounds];
    [textFieldImageView setCenter:CGPointMake(SIDE_SIZE_TEXTFIELD_ICON, SIDE_SIZE_TEXTFIELD_ICON / 2.f)];
    [offsetWrapperView addSubview:textFieldImageView];
    
    self.leftView = offsetWrapperView;
    self.leftViewMode = UITextFieldViewModeAlways;
    _iconImageView = textFieldImageView;
}

- (void)setImage:(UIImage *)innerImage{
    [_iconImageView setImage:innerImage];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [[NSNotificationCenter defaultCenter]  postNotificationName:UITextFieldTextDidChangeNotification object:self];
}

@end
