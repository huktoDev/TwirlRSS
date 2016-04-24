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


@end
