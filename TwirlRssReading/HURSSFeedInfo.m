//
//  HURSSFeedInfo.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 24.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedInfo.h"

@implementation HURSSFeedInfo

+ (instancetype)feedInfoConvertedFrom:(MWFeedInfo*)feedInfo{
    
    HURSSFeedInfo *convertedFeedInfo = [HURSSFeedInfo new];
    
    convertedFeedInfo.title = feedInfo.title;
    convertedFeedInfo.link = feedInfo.link;
    convertedFeedInfo.summary = feedInfo.summary;
    convertedFeedInfo.url = feedInfo.url;
    
    return convertedFeedInfo;
}


@end
