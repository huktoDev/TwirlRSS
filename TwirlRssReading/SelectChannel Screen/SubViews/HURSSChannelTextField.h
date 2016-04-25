//
//  HURSSChannelTextField.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 18.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HURSSChannelViewStyler.h"
#import "HURSSChannelViewAssembly.h"

/**
    @class HURSSChannelTextField
    @author HuktoDev
    @updated 25.04.2016
    @abstract Кастомное поле для ввода текста на SplashScreen-экране
    @discussion
    Обладает кастомным внешним видом и дизайном, определяемым внутри класса, для всех экземпляров данного класса.
    Имеет дополнительный сеттер для иконки филда
 */
@interface HURSSChannelTextField : UITextField


#pragma mark - Construction
// Создание текстового поля

+ (instancetype)channelTextFieldWithStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler;


#pragma mark - Setters
// Сэттеры свойств

- (void)setImage:(UIImage*)innerImage;
- (void)setText:(NSString *)text;



@end
