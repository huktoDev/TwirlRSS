//
//  NSTextAttachment+ImageResizing.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    @category NSTextAttachment (ImageResizing)
    @author HuktoDev
    @updated 25.04.2016
    @abstract Категория для аттачмента NSTextAttachment для NSAttributedString, позволяющая ресайзить изображение, и устанавливать в аттачмент новые параметры изображения
 */
@interface NSTextAttachment (ImageResizing)

- (void)resizeImageWithMaxWidth:(CGFloat)maxImageWidth;

@end
