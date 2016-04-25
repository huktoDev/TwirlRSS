//
//  HURSSFeedsCache.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HURSSFeedsReciever.h"

/**
    @class HURSSFeedsCache
    @author HuktoDev
    @updated 25.04.2016
    @abstract Класс, осуществляюющий работу с кэшем новостей. 
    @discussion
    Единственный класс, который имеет напрямую доступ к сервису, работающему с БД.
    Реализует интерфейс HURSSFeedsLocalRecievingProtocol.
 
    @note По идее, долен загружать либо наиболее вероятные каналы в кэш (недавно использовавшиеся), либо при загрузке канала (если приложение работает ) (на текущий момент не реализовано)
 
    @see
    HURSSFeedsLocalRecievingProtocol \n
    HURSSCoreDataFeedsStore \n
 */
@interface HURSSFeedsCache : NSObject <HURSSFeedsLocalRecievingProtocol>


#pragma mark - Constructor
+ (instancetype)sharedCache;


#pragma mark - SAVE TO CACHE
// Метод, сохраняющий новости в кэш, и в БД

- (void)setCachedFeeds:(NSArray<HURSSFeedItem*>*)feedItems withFeedInfo:(HURSSFeedInfo*)feedInfo forChannel:(HURSSChannel*)channel;


#pragma mark - HURSSFeedsLocalRecievingProtocol
// Получение новостей из кэша и базы данных

- (BOOL)haveCachedFeedsForChannel:(HURSSChannel*)feedsChannel;
- (void)getCachedFeedsForChannel:(HURSSChannel*)feedsChannel withCallback:(HURSSFeedsCacheRecievingBlock)cachedInfoCallback;
- (void)cancelCachedFeedsRecieving;


@end



