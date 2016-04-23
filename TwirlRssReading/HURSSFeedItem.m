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
            UIImage *resizedAttachmentImage = [[UIImage alloc] initWithData:imageFileContent scale:feedSummaryScale];
            
            currentAttachment.image = resizedAttachmentImage;
            
            
            /*
            CGSize newImageSize = CGSizeMake(boundsAttachmentImage.size.width * feedSummaryScale, boundsAttachmentImage.size.height * feedSummaryScale);
            CGRect newImageBouds = CGRectMake(0.f, 0.f, newImageSize.width, newImageSize.height);
            
            currentAttachment.bounds = newImageBouds;
             */
        }
    }];
    
    
    CGRect feedSummaryStringRect = [feedAttribString boundingRectWithSize:CGSizeMake(summaryContentWidth, 10000.f) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    CGFloat feedSummaryStringHeight = feedSummaryStringRect.size.height;
    
    self.attributedSummary = feedAttribString;
    self.summaryContentHeight = feedSummaryStringHeight;
    
    if(completionBlock){
        completionBlock(feedAttribString, feedSummaryStringHeight);
    }
}

@end
