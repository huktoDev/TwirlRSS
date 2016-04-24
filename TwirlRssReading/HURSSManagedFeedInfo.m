//
//  HURSSManagedFeedInfo.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSManagedFeedInfo.h"
#import "HURSSFeedInfo.h"

@implementation HURSSManagedFeedInfo


@dynamic title;
@dynamic link;
@dynamic summary;
@dynamic url;


+ (NSManagedObjectContext*)usedManagedContext{
    return [HURSSCoreDataFeedsStore feedsStore].managedObjectContext;
}

+ (instancetype)createFeedInfoFrom:(HURSSFeedInfo*)feedInfo{
    
    NSManagedObjectContext *usedContext = [[self class] usedManagedContext];
    NSString *entityName = [[self class] entityName];
    
    HURSSManagedFeedInfo *managedFeedInfo = (HURSSManagedFeedInfo*)[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:usedContext];
    
    managedFeedInfo.title = feedInfo.title;
    managedFeedInfo.link = feedInfo.link;
    managedFeedInfo.summary = feedInfo.summary;
    managedFeedInfo.url = feedInfo.url.absoluteString;
    
    return managedFeedInfo;
}

+ (NSString*)entityName{
    return @"FeedInfo";
}

- (HURSSFeedInfo*)convertToSimpleRSSInfoModel{
    
    HURSSFeedInfo *convertedFeedInfo = [HURSSFeedInfo new];
    
    convertedFeedInfo.title = self.title;
    convertedFeedInfo.link = self.link;
    convertedFeedInfo.summary = self.summary;
    convertedFeedInfo.url = [NSURL URLWithString:self.url];
    
    return convertedFeedInfo;
}


@end
