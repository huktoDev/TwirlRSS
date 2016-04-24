//
//  HURSSManagedChannel.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "HURSSChannel.h"
#import "HURSSFeedInfo.h"
#import "HURSSFeedItem.h"

#import "HURSSManagedFeedInfo.h"
#import "HURSSManagedFeedItem.h"

@interface HURSSManagedChannel : NSManagedObject


+ (NSManagedObjectContext*)usedManagedContext;
+ (NSString*)entityName;
+ (instancetype)createChannelFrom:(HURSSChannel*)feedChannel andFillWithInfo:(HURSSFeedInfo*)feedInfo andFillWithFeeds:(NSArray<HURSSFeedItem*>*)feedItems;

//- (HURSSFeedInfo*)convertToSimpleRSSInfoModel;


@property (copy, nonatomic) NSString *channelAlias;
@property (copy, nonatomic) NSString *channelURL;
@property (copy, nonatomic) NSNumber *channelType;

@property (strong, nonatomic) HUSSManagedFeedInfo *channelFeeds;
@property (strong, nonatomic) NSArray <HURSSManagedFeedItem*> *channelFeeds;

@end
