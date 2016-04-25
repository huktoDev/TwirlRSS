//
//  NSAttributedString+ResizeAttachments.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    @category NSAttributedString (ResizeAttachments)
    @author HuktoDev
    @updated 25.04.2016
    @abstract Категория для строки с аттрибутами, позволяющая ресайзить аттачменты (картинки)
 */
@interface NSAttributedString (ResizeAttachments)

- (void)resizeAllAttachmentImagesWithMaxWidth:(CGFloat)maxStringWidth;

@end
