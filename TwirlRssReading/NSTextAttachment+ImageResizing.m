//
//  NSTextAttachment+ImageResizing.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "NSTextAttachment+ImageResizing.h"

@implementation NSTextAttachment (ImageResizing)

/// Выполнить ресайз изображения по максимальной длине (к сожалению, ресайз не идеальный, так как информацию в NSFileWrapper не пишет, и при следующей загрузке не выдает)
- (void)resizeImageWithMaxWidth:(CGFloat)maxImageWidth{
    
    CGRect boundsAttachmentImage = self.bounds;
    
    // Если размер изображения аттачмента больше, чем ширина контента - ресайзить
    if(boundsAttachmentImage.size.width > maxImageWidth){
        
        // Вычисляется требуемый коэффициент скалирования
        CGFloat feedSummaryScale = (maxImageWidth / boundsAttachmentImage.size.width);
        
        // Извлекается изображения из загруженного файла
        NSData *imageFileContent = [self.fileWrapper regularFileContents];
        UIImage *attachmentImage = [[UIImage alloc] initWithData:imageFileContent];
        
        // Вычисляются новые размеры изображения
        CGSize newImageSize = CGSizeApplyAffineTransform(attachmentImage.size, CGAffineTransformMakeScale(feedSummaryScale, feedSummaryScale));
        
        // Создается контекст, и изображение на нем рендерится
        UIGraphicsBeginImageContextWithOptions(newImageSize, YES, 0.f);
        [attachmentImage drawInRect:CGRectMake(0.f, 0.f, newImageSize.width, newImageSize.height)];
        
        // Снимается новый UIImage с контекста
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Устанавливается новое изображение, и новый размер
        self.image = scaledImage;
        self.bounds = CGRectMake(0.f, 0.f, scaledImage.size.width, scaledImage.size.height);
    }

}

@end
