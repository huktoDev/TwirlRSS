//
//  HURSSChannelButton.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    @class HURSSChannelButton
    @author HuktoDev
    @updated 19.04.2016
    @abstract Кнопка экрана выбора канала
    @discussion
    На SelectChannel-экране имеются 2 кнопки, у этих кнопок общий вид, и общая реакция на касание. Поэтому решено было сделать подкласс
 */
@interface HURSSChannelButton : UIButton

- (void)setTouchHandler:(SEL)actionHandler toTarget:(id)actionTarget;

@end
