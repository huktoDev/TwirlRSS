//
//  HURSSChannelStore.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelStore.h"
#import "HURSSChannel.h"
#import "HURSSReservedChannelSet.h"




static NSString *HU_RSS_STORED_CHANNELS_FILENAME = @"StoredChannels.json";

NSString *const HU_RSS_STORED_CHANNELS_DEFAULTS_KEY = @"kStoredChannels";


@implementation HURSSChannelStore{
    
    NSArray <HURSSChannel*>     *_loadedChannels;
    NSArray <NSString*>         *_loadedChannelsNames;
}


#pragma mark - Initialization

+ (instancetype)sharedStore{
    
    static HURSSChannelStore *_sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [HURSSChannelStore new];
    });
    return _sharedStore;
}

- (instancetype)init{
    if(self = [super init]){
        
        // Если требуется - сбросить сохраненные каналы
#if HU_RSS_NEED_CLEAR_STORED_CHANNELS == 1
        [self resetChannels];
#endif
        // Если имеются зарезервированные каналы - они в начале сохраняются в локальное хранилище (чтобы потом их можно было удобно извлекать)
        [self attemptFillStoredChannels];
        [self  loadStoredChannels];
    }
    return self;
}


#pragma mark - FILL RESERVED

/**
    @abstract Сохранить зарезервированные каналы
    @discussion
    Если в локальном хранилище еще не имеется файл с сохраненными каналами ( при первом запуске, или после сброса ) - сохраняет в локальное хранилище массив  с зарезервированными каналами (по-умолчанию)
    @return Выполнилось сохранение (YES), если не сохранилось, или сохранение не требуется - NO
 */
- (BOOL)attemptFillStoredChannels{
    
    NSArray<HURSSChannel*> *storedChannels = [self internalLoadStoredChannelsFromLocalStore];
    
    BOOL isChannelsSuccessLoaded = (storedChannels && storedChannels.count > 0);
    if(! isChannelsSuccessLoaded){
        // Получить зарезервированные каналы
        HURSSReservedChannelSet *channelsSet = [HURSSReservedChannelSet defaultChannelsSet];
        NSArray<HURSSChannel*> *reservedChannels = [channelsSet getReservedChannels];
        
        // Сохранить зарезервированные каналы (при первой попытке инициализации)
        BOOL isReservedChannelsSaved = [self internalSaveStoredChannelsToLocalStore:reservedChannels];
        return isReservedChannelsSaved;
    }
    return NO;
}

/// Сохранить новый канал (как в кэш хранилища, так и в само хранилище)
- (BOOL)saveNewChannel:(HURSSChannel*)newChannel{
    
    NSMutableArray <HURSSChannel*> *bufferChannels = [_loadedChannels mutableCopy];
    NSUInteger indexSimilarChannel = [self indexOfChannelWithName:newChannel.channelAlias];
    if(indexSimilarChannel != -1){
        [bufferChannels replaceObjectAtIndex:indexSimilarChannel withObject:newChannel];
    }else{
        [bufferChannels addObject:newChannel];
    }
    
    _loadedChannels = [NSArray arrayWithArray:bufferChannels];
    BOOL isSuccessSaved = [self internalSaveStoredChannelsToLocalStore:_loadedChannels];
    return isSuccessSaved;
}


- (BOOL)deleteChannel:(HURSSChannel*)deletingChannel{
    
    BOOL containgDeletingChannel = [self containsChannelWithName:deletingChannel.channelAlias];
    if(containgDeletingChannel){
        
        NSUInteger indexDeletingChannel = [self indexOfChannelWithName:deletingChannel.channelAlias];
        NSMutableArray <HURSSChannel*> *bufferChannels = [_loadedChannels mutableCopy];
        [bufferChannels removeObjectAtIndex:indexDeletingChannel];
        _loadedChannels = [NSArray arrayWithArray:bufferChannels];
        
        BOOL isSuccessSaved = [self internalSaveStoredChannelsToLocalStore:_loadedChannels];
        return isSuccessSaved;
    }
    return NO;
}

/**
    @abstract Загрузить список каналов из локального хранилища
    @discussion
    <h4> Выполняет 2 задачи : </h4>
    <ol type="a">
        <li> Загружаются сохраненные каналы </li>
        <li> Размещаются в кэше (в объекте) сохраненные каналы </li>
    </ol>
 
    @note  Если не удалось загрузить - возвращает зарезервированные каналы
 
    @return Массив моделей загруженных каналов
 */
- (NSArray <HURSSChannel*>*)loadStoredChannels{
    
    NSArray <HURSSChannel*> *storedChannels = [self internalLoadStoredChannelsFromLocalStore];
    if(storedChannels){
        
        // Если каналы удалось загрузить
        _loadedChannels = storedChannels;
        return storedChannels;
    }else{
        
        // Если каналы не удалось загрузить - вернуть каналы по-умолчанию
        HURSSReservedChannelSet *channelsSet = [HURSSReservedChannelSet defaultChannelsSet];
        NSArray<HURSSChannel*> *reservedChannels = [channelsSet getReservedChannels];
        _loadedChannels = reservedChannels;
        return reservedChannels;
    }
}

/**
    @abstract Получить массив названий каналов
    @discussion
    Получает массив названий каналов, для текущего закэшированного списка каналов (извлекает псевдонимы каналов channelAlias)
 
    @note Зараннее требуется загрузить массив каналов из хранилища
    @return Массив названий каналов
 */
- (NSArray <NSString*>*)loadStoredChannelsName{
    
    NSMutableArray<NSString*> *channelNames = [NSMutableArray new];
    for (HURSSChannel *currentChannel in _loadedChannels) {
        [channelNames addObject:currentChannel.channelAlias];
    }
    _loadedChannelsNames = [NSArray arrayWithArray:channelNames];
    return _loadedChannelsNames;
}

- (BOOL)containsChannelWithName:(NSString*)checkChannelName{
    
    for (HURSSChannel *currentChannel in _loadedChannels) {
        
        BOOL isEqualChannelAlias = [checkChannelName isEqualToString:currentChannel.channelAlias];
        if(isEqualChannelAlias){
            return YES;
        }
    }
    return NO;
}

- (NSInteger)indexOfChannelWithName:(NSString*)searchChannelName{
    
    for (NSUInteger indexChannel = 0; indexChannel < _loadedChannels.count; indexChannel ++) {
        
        HURSSChannel *currentChannel = _loadedChannels[indexChannel];
        BOOL isEqualChannelAlias = [searchChannelName isEqualToString:currentChannel.channelAlias];
        if(isEqualChannelAlias){
            return indexChannel;
        }
    }
    return -1;
}

- (NSString*)storedChannelsFilePath{
    
    static NSString *_storedChannelsFilePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex: 0];
        _storedChannelsFilePath = [documentDirectory stringByAppendingPathComponent:HU_RSS_STORED_CHANNELS_FILENAME];
    });
    return _storedChannelsFilePath;
}

- (NSArray <HURSSChannel*>*)internalLoadStoredChannelsFromLocalStore{
    
    NSString *storedChannelsFilePath = [self storedChannelsFilePath];
    
    id unarchivedChannelsData = [self loadChannels];
    NSArray<HURSSChannel*> *storedChannels = (NSArray<HURSSChannel*>*)unarchivedChannelsData;
    
    BOOL isLoadedData = (unarchivedChannelsData != nil);
    
#if HU_RSS_USE_FILE_SERIALIZATION == 1
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isChannelsFileExist = [fileManager fileExistsAtPath:storedChannelsFilePath];
    if(! isLoadedData && isChannelsFileExist){
        @throw [NSException exceptionWithName:@"channelsLoadException" reason:@"Unfortunately! Channels list don't restored from File" userInfo:nil];
    }
#endif
    if(! isLoadedData){
        return [NSArray new];
    }
    
    BOOL isChannelsArray = ([unarchivedChannelsData isKindOfClass:[NSArray class]]);
    if(! isChannelsArray){
        @throw [NSException exceptionWithName:@"channelsArrayException" reason:@"Loaded Data From File is not a NSArray" userInfo:nil];
    }
    
    BOOL isCorrectChannels = (storedChannels.count > 0 && [[storedChannels firstObject] isKindOfClass:[HURSSChannel class]]);
    if(! isCorrectChannels){
        @throw [NSException exceptionWithName:@"channelsDataException" reason:@"Loaded Data From File is not objects RSSChannels" userInfo:nil];
    }
    
    return  storedChannels;
}

- (BOOL)internalSaveStoredChannelsToLocalStore:(NSArray<HURSSChannel*>*)channelsToStore{
    
    BOOL isSavedData = [self saveChannels:channelsToStore];
    return isSavedData;
}

- (id)loadChannels{
#if HU_RSS_USE_LOCAL_PREFERENCES == 1
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *channelsArchivedData = (NSData*)[userDefaults objectForKey:HU_RSS_STORED_CHANNELS_DEFAULTS_KEY];
    if(! channelsArchivedData){
        return nil;
    }
    id channelsData = [NSKeyedUnarchiver unarchiveObjectWithData:channelsArchivedData];
    return channelsData;
    
#elif HU_RSS_USE_FILE_SERIALIZATION == 1
    
    NSString *storedChannelsFilePath = [self storedChannelsFilePath];
    id unarchivedChannelsData = [NSKeyedUnarchiver unarchiveObjectWithFile:storedChannelsFilePath];
    return unarchivedChannelsData;
#else
    #error Need to determine on of constants : HU_RSS_USE_LOCAL_PREFERENCES or HU_RSS_USE_FILE_SERIALIZATION
#endif
}

- (BOOL)saveChannels:(id)channels{
    
    if(! channels){
        return NO;
    }
    
#if HU_RSS_USE_LOCAL_PREFERENCES == 1
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *channelsArchivedData = [NSKeyedArchiver archivedDataWithRootObject:channels];
    [userDefaults setObject:channelsArchivedData forKey:HU_RSS_STORED_CHANNELS_DEFAULTS_KEY];
    BOOL isSuccessSynchronize = [userDefaults synchronize];
    return isSuccessSynchronize;
    
#elif HU_RSS_USE_FILE_SERIALIZATION == 1
    
    NSString *storedChannelsFilePath = [self storedChannelsFilePath];
    BOOL isSavedData = [NSKeyedArchiver archiveRootObject:channels toFile:storedChannelsFilePath];
    return isSavedData;
#else
    #error Need to determine on of constants : HU_RSS_USE_LOCAL_PREFERENCES or HU_RSS_USE_FILE_SERIALIZATION
#endif
}

- (void)resetChannels{
    
#if HU_RSS_USE_LOCAL_PREFERENCES == 1
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:HU_RSS_STORED_CHANNELS_DEFAULTS_KEY];
    [userDefaults synchronize];
    
#elif HU_RSS_USE_FILE_SERIALIZATION == 1
    
    NSString *storedChannelsFilePath = [self storedChannelsFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:storedChannelsFilePath error:nil];
    
#else
#error Need to determine on of constants : HU_RSS_USE_LOCAL_PREFERENCES or HU_RSS_USE_FILE_SERIALIZATION
#endif
}








@end



