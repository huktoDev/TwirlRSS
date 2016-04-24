//
//  HURSSFeedInfo.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 24.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <MWFeedParser/MWFeedParser.h>

@interface HURSSFeedInfo : MWFeedInfo

+ (instancetype)feedInfoConvertedFrom:(MWFeedInfo*)feedInfo;

@end
