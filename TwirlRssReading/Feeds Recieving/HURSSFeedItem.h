//
//  HURSSFeedItem.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 24.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <MWFeedParser/MWFeedParser.h>

typedef void(^HURSSFeedItemBlock)(NSAttributedString *recievedString, CGFloat heightContent);



@interface HURSSFeedItem : MWFeedItem

@property (strong, nonatomic) NSAttributedString *attributedSummary;
@property (assign, nonatomic) CGFloat summaryContentHeight;

- (void)parseSummaryHTMLWithContentWidth:(const CGFloat)summaryContentWidth WithCompletion:(HURSSFeedItemBlock)completionBlock;

+ (instancetype)feedItemConvertedFrom:(MWFeedItem*)feedItem;

@end
