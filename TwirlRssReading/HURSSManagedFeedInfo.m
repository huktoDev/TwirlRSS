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

// NSManagedObject динамически переопределяет методы доступа 
@dynamic title;
@dynamic link;
@dynamic summary;
@dynamic url;


#pragma mark - CONTEXT Info

/// Испоьзуемый контекст CoreData
+ (NSManagedObjectContext*)usedManagedContext{
    return [HURSSCoreDataFeedsStore feedsStore].managedObjectContext;
}

/// Название сущности этого NSManagedObject в модели CoreData
+ (NSString*)entityName{
    return @"FeedInfo";
}


#pragma mark - Convertations

/// Создаем модель для работы в контексте из основного типа модели
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


/// Конвертируем объект контекста в более используемую в приложении модель
- (HURSSFeedInfo*)convertToSimpleRSSInfoModel{
    
    HURSSFeedInfo *convertedFeedInfo = [HURSSFeedInfo new];
    
    convertedFeedInfo.title = self.title;
    convertedFeedInfo.link = self.link;
    convertedFeedInfo.summary = self.summary;
    convertedFeedInfo.url = [NSURL URLWithString:self.url];
    
    return convertedFeedInfo;
}


@end
