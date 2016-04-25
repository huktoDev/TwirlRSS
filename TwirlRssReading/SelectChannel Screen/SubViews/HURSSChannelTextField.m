//
//  HURSSChannelTextField.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 18.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelTextField.h"

@implementation HURSSChannelTextField{
    
    // Вьюшка экрана (для отправления энейбл/дизейбл событий)
    __weak HUSelectRSSChannelView *_parentView;
    
    // ImageView иконки текстового поля (которая слева)
    UIImageView *_iconImageView;
    
    // Стилизатор кнопки
    id<HURSSChannelViewStylizationInterface> _presentStyler;
}

#pragma mark - Construction

/// Назначенный инициализатор (передает стилизатор, и конфигурирует Ui)
- (instancetype)initWithRootView:(HUSelectRSSChannelView*)rootView Styler:(id<HURSSChannelViewStylizationInterface>)viewStyler{
    if(self = [super init]){
        
        _parentView = rootView;
        _presentStyler = viewStyler;
        [self configUI];
        [self disableMultiTouch];
    }
    return self;
}

/// Статический конструктор со стилизатором
+ (instancetype)channelTextFieldWithRootView:(HUSelectRSSChannelView*)rootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler{
    
    HURSSChannelTextField *newTextField = [[HURSSChannelTextField alloc] initWithRootView:rootView Styler:viewStyler];
    return newTextField;
}


#pragma mark - Configuration

/// Конфигурация внешнего вида
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
    [channelFieldLayer setBorderWidth:2.f];
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
    
    
    // Рассчитать размеры иконки
    const CGFloat SIDE_SIZE_TEXTFIELD_ICON = 25.f;
    const CGRect baseTextFieldIconBounds = CGRectMake(0.f, 0.f, SIDE_SIZE_TEXTFIELD_ICON, SIDE_SIZE_TEXTFIELD_ICON);
    const CGRect wrapperImageBounds = CGRectMake(0.f, 0.f, 2.f * SIDE_SIZE_TEXTFIELD_ICON, SIDE_SIZE_TEXTFIELD_ICON);
    
    // Создать ImageView для иконки (пока не заполняя ее конкретной картинкой)
    UIImageView *textFieldImageView = [[UIImageView alloc] initWithFrame:baseTextFieldIconBounds];
    textFieldImageView.contentMode = UIViewContentModeScaleToFill;
    textFieldImageView.alpha = 0.6f;
    
    // Завернуть иконку в специальный враппер, чтобы в нем реализовывать Content Offset
    UIView *offsetWrapperView = [[UIView alloc] initWithFrame:wrapperImageBounds];
    [textFieldImageView setCenter:CGPointMake(SIDE_SIZE_TEXTFIELD_ICON, SIDE_SIZE_TEXTFIELD_ICON / 2.f)];
    [offsetWrapperView addSubview:textFieldImageView];
    
    // Установить иконку
    self.leftView = offsetWrapperView;
    self.leftViewMode = UITextFieldViewModeAlways;
    _iconImageView = textFieldImageView;
}


#pragma mark - Setters

/// Устанавливает иконку в текст филд
- (void)setImage:(UIImage *)innerImage{
    [_iconImageView setImage:innerImage];
}

/// Устанавливает текст в текст филд (при установке текста - автоматически генерить нотификейшен (в этом случае  did change автоматически не срабатывает))
- (void)setText:(NSString *)text{
    [super setText:text];
    [[NSNotificationCenter defaultCenter]  postNotificationName:UITextFieldTextDidChangeNotification object:self];
}



@end

