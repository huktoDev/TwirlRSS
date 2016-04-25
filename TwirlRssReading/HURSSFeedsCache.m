//
//  HURSSFeedsCache.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedsCache.h"
#import "HURSSFeedsReciever.h"

@implementation HURSSFeedsCache{
    
    // Используемые сервис (сервис для БД)
    HURSSCoreDataFeedsStore *_feedsStore;
}


#pragma mark - Construction

+ (instancetype)sharedCache{
    
    static HURSSFeedsCache *_sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [HURSSFeedsCache new];
    });
    return _sharedCache;
}

- (instancetype)init{
    if(self = [super init]){
        [self injectDependencies];
    }
    return self;
}

#pragma mark - Dependencies

/// Инжектирует зависимости
- (void)injectDependencies{
    
    _feedsStore = [HURSSCoreDataFeedsStore feedsStore];
}


#pragma mark - SAVE TO CACHE

/**
    @abstract Метод для сохранения информации в кэш
    @discussion
    Позволяет сохранять информацию в кэш, по идее здесь нужно выполнять еще и сохранение в кэш сервиса, но пишет только в базу
 
    @param feedItems      Массив новостей, связанных с каналом
    @param feedInfo         Метаинформация о канале
    @param channel         Модель канала, для которого сохраняются новости
 */
- (void)setCachedFeeds:(NSArray<HURSSFeedItem*>*)feedItems withFeedInfo:(HURSSFeedInfo*)feedInfo forChannel:(HURSSChannel*)channel{
    
    BOOL isSuccessCached = [_feedsStore saveRSSChannelInfo:channel withFeedInfo:feedInfo withFeeds:feedItems];
    if(! isSuccessCached){
        NSLog(@"Cachiing  ERROR !!!");
    }
}


#pragma mark - GET FROM CACHE

/**
    @abstract Имеется ли сохраненные прежде новости для данного канала в кэше
    @discussion
    Обычно метод используется для проверки, есть ли закэшированные новости. Например, используется для того, чтобы узнать, нужно ли показать  кнопку "загруженные ранее новости"
    
    @note Далеко не оптимально выполняет поиск в базе (сначала извлекает всю информацию, и по ней проходится, но нужды в оптимизации пока нет)
 
    @param feedsChannel       Канал, для которого в базе ищутся новости
    @return Если найдены новостидля канала - возвращает YES
 */
- (BOOL)haveCachedFeedsForChannel:(HURSSChannel*)feedsChannel{
    
    __block BOOL isCachedInfoFound = NO;
    [self getCachedFeedsForChannel:feedsChannel withCallback:^(HURSSChannel *channel, HURSSFeedInfo *feedInfo, NSArray<HURSSFeedItem *> *feedItems) {
        
        if(feedInfo && feedItems){
            isCachedInfoFound = YES;
        }
    }];
    return isCachedInfoFound;
}

/**
    @abstract Получить закэшированные новости для канала
    @discussion
    Возвращает новости для канала, используя специальный callBack с 3м параметрами : канал, новости канала, метаданные канала
 
    @note Далеко не оптимально выполняет поиск в базе (сначала извлекает всю информацию, и по ней проходится, но нужды в оптимизации пока нет)
    @note Если для канала не удалось найти новости - возвращает nil-ы в 2х последних параметраз коллбэка
 
    @note Используется строгая компарация моделей каналов (и псевдоним канала, и URL, хотя по идее можно  было бы сделать проверку только на URL)
    @note Используется предикат для поиска соответствующего канала
 
    @param feedsChannel       Канал, для которого извлекаются новости
    @param cachedInfoCallback       Обработчик, который получает успешно извлеченные из кэша новости
 */
- (void)getCachedFeedsForChannel:(HURSSChannel*)feedsChannel withCallback:(HURSSFeedsCacheRecievingBlock)cachedInfoCallback{
    
    // Предикат для поиска канала (сравнивает исходный канал с перечисляемым)
    NSPredicate *channelFilterPredicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        HURSSChannel *checkingChannel = (HURSSChannel*)evaluatedObject;
        
        // Если и псевдоним канала, и URL канала одинаковы
        BOOL isEqualChannelAlias = [feedsChannel.channelAlias isEqualToString:checkingChannel.channelAlias];
        BOOL isEqualChannelURLs = [feedsChannel.channelURL.absoluteString isEqualToString:checkingChannel.channelURL.absoluteString];
        
        BOOL isEqualChannels = isEqualChannelAlias && isEqualChannelURLs;
        
        return isEqualChannels;
    }];
    
    // Загружает все сохраненные каналы, и ищет среди них
    __block BOOL isCachedInfoFounded = NO;
    [_feedsStore loadRSSChannelsWithCallback:^(HURSSChannel *loadedChannel, HURSSFeedInfo *loadedFeedInfo, NSArray<HURSSFeedItem *> *loadedFeedItems, BOOL *needStop) {
        
        // Применяет предикат к текущему каналу
        BOOL isEqualChannels = [channelFilterPredicate evaluateWithObject:loadedChannel];
        
        // Если канал найден - возвращает данные через коллбэк
        if(isEqualChannels){
            if(cachedInfoCallback){
                cachedInfoCallback(loadedChannel, loadedFeedInfo, loadedFeedItems);
            }
            *needStop = YES;
            isCachedInfoFounded = YES;
        }
    }];
    
    // Если не удалось найти закэшированные данные
    if(! isCachedInfoFounded){
        if(cachedInfoCallback){
            cachedInfoCallback(feedsChannel, nil, nil);
        }
    }
}

/// По идее, здесь нужно отменять запросы к БД
- (void)cancelCachedFeedsRecieving{
    
}


@end
