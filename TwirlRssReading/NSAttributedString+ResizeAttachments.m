//
//  NSAttributedString+ResizeAttachments.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "NSAttributedString+ResizeAttachments.h"
#import "NSTextAttachment+ImageResizing.h"

@implementation NSAttributedString (ResizeAttachments)

// Перечисляет все NSTextAttachment (аттрибуты с NSAttachmentAttributeName) (картинки), и каждую картинку ресайзит (в зависимости от максимальной длины строки)
- (void)resizeAllAttachmentImagesWithMaxWidth:(CGFloat)maxStringWidth{
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        NSTextAttachment *currentAttachment = (NSTextAttachment*)value;
        [currentAttachment resizeImageWithMaxWidth:maxStringWidth];
    }];
}

@end
