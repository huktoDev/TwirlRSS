//
//  HURSSManagedFeedInfo.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "HURSSCoreDataFeedsStore.h"

@interface HURSSManagedFeedInfo : NSManagedObject

+ (NSManagedObjectContext*)usedManagedContext;
+ (NSString*)entityName;
+ (instancetype)createFeedInfoFrom:(HURSSFeedInfo*)feedInfo;

- (HURSSFeedInfo*)convertToSimpleRSSInfoModel;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *url;

@end
