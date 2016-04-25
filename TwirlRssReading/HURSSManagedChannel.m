//
//  HURSSManagedChannel.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSManagedChannel.h"

@implementation HURSSManagedChannel

// Динамически переопределяемые методы доступа
@dynamic alias;
@dynamic url;
@dynamic type;
@dynamic feedInfo;
@dynamic feeds;


#pragma mark - CONTEXT Info

/// Испоьзуемый контекст CoreData
+ (NSManagedObjectContext*)usedManagedContext{
    return [HURSSCoreDataFeedsStore feedsStore].managedObjectContext;
}

/// Название сущности этого NSManagedObject в модели CoreData
+ (NSString*)entityName{
    return @"Channel";
}

#pragma mark - Convertations

/**
    @abstract Создание канала на контексте CoreData
    @discussion
    Основной метод связывания сущности канала с новостями. 
    Конвертирет и добавляет все сущности на контекст CoreData, указывает в HURSSManagedChannel новости в свойствах.
 
    @param feedChannel      Модель канала
    @param feedInfo           Моель метаданных новостного канала
    @param feedItems         Массив моделей новостей, полученных с канала
    
    @return Готовая модель контекста HURSSManagedChannel
 */
+ (instancetype)createChannelFrom:(HURSSChannel*)feedChannel andFillWithInfo:(HURSSFeedInfo*)feedInfo andFillWithFeeds:(NSArray<HURSSFeedItem*>*)feedItems{
    // Определяет контекст и сущность
    NSManagedObjectContext *usedContext = [[self class] usedManagedContext];
    NSString *entityName = [[self class] entityName];
    
    // Создает объект канала, и добавляет его на контекст
    HURSSManagedChannel *managedChannel = (HURSSManagedChannel*)[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:usedContext];
    
    // Добавить свойства канала
    managedChannel.alias = feedChannel.channelAlias;
    managedChannel.url = feedChannel.channelURL.absoluteString;
    managedChannel.type = @(feedChannel.channelType);
    
    // Создает и прикрепляет к каналу метаданные
    HURSSManagedFeedInfo *managedFeedInfo = [HURSSManagedFeedInfo createFeedInfoFrom:feedInfo];
    managedChannel.feedInfo = managedFeedInfo;
    
    // Создает и прикрепляет к каналу новости (NSOrderedSet)
    NSMutableArray <HURSSManagedFeedItem*> *managedFeedItems = [[NSMutableArray alloc] initWithCapacity:feedItems.count];
    for (HURSSFeedItem *feedItem in feedItems){
        
        HURSSManagedFeedItem *managedFeedItem = [HURSSManagedFeedItem createFeedItemFrom:feedItem];
        [managedFeedItems addObject:managedFeedItem];
    }
    
    managedChannel.feeds = [NSOrderedSet orderedSetWithArray:managedFeedItems];
    
    
    return managedChannel;
}

/// Конвертация в простую модель HURSSChannel (новости при этом теряются)
- (HURSSChannel*)convertToSimpleRSSChannelModel{
    
    HURSSChannel *convertedChannel = [HURSSChannel new];
    
    convertedChannel.channelAlias = self.alias;
    convertedChannel.channelURL = [NSURL URLWithString:self.url];
    convertedChannel.channelType = [self.type doubleValue];
    
    return convertedChannel;
}



@end


