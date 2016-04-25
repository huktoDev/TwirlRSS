//
//  HURSSCoreDataFeedsStore.h
//  CoreDataTestProject2
//
//  Created by Alexandr Babenko on 08.02.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;


#import "HURSSManagedChannel.h"
#import "HURSSManagedFeedInfo.h"
#import "HURSSManagedFeedItem.h"

@interface HURSSCoreDataFeedsStore : NSObject


#pragma mark - CoreData Properties
// Свойства CoreData

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


#pragma mark - Construction
+ (instancetype)feedsStore;


#pragma mark - DEFAULT Config
// Конфигурирование сервиса

- (void)configurationDefaultStore;


#pragma mark - CREATION Core Data ENVIRONMENT
// Создание окружения дял Core Data

- (NSPersistentStoreCoordinator*)createStoreCoordinator;
- (NSManagedObjectModel*)createManagedObjectModel;
- (NSManagedObjectContext*)createManagedObjectContext;


#pragma mark - Work With FeedInfo
// Работа с метаданными RSS-каналов

- (BOOL)saveFeedInfo:(HURSSFeedInfo*)savingFeedInfo;
- (NSArray <HURSSFeedInfo*> *)loadFeedInfo;


#pragma mark - LOAD & SAVE Feeds
// Загрузка и сохранение новостей из базы

- (BOOL)saveRSSChannelInfo:(HURSSChannel*)channel withFeedInfo:(HURSSFeedInfo*)feedInfo withFeeds:(NSArray<HURSSFeedItem*>*)feeds;

- (void)loadRSSChannelsWithCallback:(void (^)(HURSSChannel*, HURSSFeedInfo*, NSArray<HURSSFeedItem*>*, BOOL*))loadingChannelBlock;


@end


