//
//  HURSSFeedItem.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 24.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedItem.h"

@implementation HURSSFeedItem


+ (instancetype)feedItemConvertedFrom:(MWFeedItem*)feedItem{
    
    HURSSFeedItem *convertedFeedItem = [HURSSFeedItem new];
    
    convertedFeedItem.identifier = feedItem.identifier;
    convertedFeedItem.title = feedItem.title;
    convertedFeedItem.link = feedItem.link;
    convertedFeedItem.date = feedItem.date;
    convertedFeedItem.updated = feedItem.updated;
    convertedFeedItem.summary = feedItem.summary;
    convertedFeedItem.content = feedItem.content;
    convertedFeedItem.author = feedItem.author;
    convertedFeedItem.enclosures = feedItem.enclosures;
    
    return convertedFeedItem;
}

- (void)parseSummaryHTMLWithContentWidth:(const CGFloat)summaryContentWidth WithCompletion:(HURSSFeedItemBlock)completionBlock{
    
    if(self.attributedSummary){
        completionBlock(self.attributedSummary, self.summaryContentHeight);
        return;
    }
    
    NSData *summaryData = [self.summary dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *attribStringOptions = @{
        NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)};
    
    
    NSError *feedAttribStringError = nil;
    NSAttributedString *feedAttribString =[[NSAttributedString alloc] initWithData:summaryData options:attribStringOptions documentAttributes:nil error:&feedAttribStringError];
    
    [feedAttribString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, feedAttribString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        NSTextAttachment *currentAttachment = (NSTextAttachment*)value;
        CGRect boundsAttachmentImage = currentAttachment.bounds;
        
        //NSDate *testx = [currentAttachment.fileWrapper serializedRepresentation];
        
        
        if(boundsAttachmentImage.size.width > summaryContentWidth){
            
            CGFloat feedSummaryScale = (summaryContentWidth / boundsAttachmentImage.size.width);
            
            NSData *imageFileContent = [currentAttachment.fileWrapper regularFileContents];
            UIImage *attachmentImage = [[UIImage alloc] initWithData:imageFileContent];
            
            CGSize newImageSize = CGSizeApplyAffineTransform(attachmentImage.size, CGAffineTransformMakeScale(feedSummaryScale, feedSummaryScale));
            
            UIGraphicsBeginImageContextWithOptions(newImageSize, YES, 0.f);
            [attachmentImage drawInRect:CGRectMake(0.f, 0.f, newImageSize.width, newImageSize.height)];
            
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            currentAttachment.image = scaledImage;
            currentAttachment.bounds = CGRectMake(0.f, 0.f, scaledImage.size.width, scaledImage.size.height);
        }
    }];
    
    NSStringDrawingOptions drawingOptions = (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGRect feedSummaryStringRect = [feedAttribString boundingRectWithSize:CGSizeMake(summaryContentWidth, 10000.f) options:drawingOptions context:nil];
    CGFloat feedSummaryStringHeight = feedSummaryStringRect.size.height;
    
    CGRect feedTitleStringRect = [self.title boundingRectWithSize:CGSizeMake(summaryContentWidth, 10000.f) options:drawingOptions attributes:@{NSFontAttributeName : [[HURSSTwirlStyle sharedStyle] channelTextFieldFont]} context:nil];
    CGFloat feedTitleStringHeight = feedTitleStringRect.size.height;
    
    NSDateFormatter *feedDateFormatter = [NSDateFormatter new];
    [feedDateFormatter setDateFormat:@"dd MMMM yyyy, hh:mm a"];
    NSString *formattedFeedDate = [feedDateFormatter stringFromDate:self.date];
    
    
    self.attributedSummary = feedAttribString;
    self.summaryContentHeight = feedSummaryStringHeight;
    self.titleContentHeight = feedTitleStringHeight;
    self.formattedCreationDate = formattedFeedDate;
    
    if(completionBlock){
        completionBlock(feedAttribString, feedSummaryStringHeight);
    }
}

@end
