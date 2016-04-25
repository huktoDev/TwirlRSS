//
//  HURSSChannelStore.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelStore.h"

/**
    @constant HU_RSS_STORED_CHANNELS_FILENAME
        Название файла, в котором будет храниться информация о каналах
 */
static NSString *HU_RSS_STORED_CHANNELS_FILENAME = @"StoredChannels.json";

/**
    @constant HU_RSS_STORED_CHANNELS_DEFAULTS_KEY
        Ключ для сохранения каналов в NSUserDefaults
 */
NSString *const HU_RSS_STORED_CHANNELS_DEFAULTS_KEY = @"kStoredChannels";


@implementation HURSSChannelStore{
    
    // Закэшированные каналы, и их названия
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
        // Если имеются зарезервированные каналы - они в начале сохраняются в локальное хранилище (чтобы потом их можно было удобно извлекать), и сразу кэшируются
        [self attemptFillStoredChannels];
        [self loadStoredChannels];
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


#pragma mark - LOAD FROM STORE

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

#pragma mark - SAVE TO STORE

/**
    @abstract Сохранить новый канал
    @discussion
    Если имеется канал в хранилище - изменяет его, иначе - добавляет в конец. Передает управления внутреннему методу сохранения.
    Кроме всего, модифицирует кэш
 
    @param newChannel     Модель добавляемого канала
    @return Если удалось сохранить канал - YES, иначе - NO
 */
- (BOOL)saveNewChannel:(HURSSChannel*)newChannel{
    
    // Создает мутабельный массив-буфер из кэша
    NSMutableArray <HURSSChannel*> *bufferChannels = [_loadedChannels mutableCopy];
    
    // Выполняет изменения с буфером (находит индекс данного канала, и заменяет, либо просто добавляет в конец)
    NSUInteger indexSimilarChannel = [self indexOfChannelWithName:newChannel.channelAlias];
    if(indexSimilarChannel != -1){
        [bufferChannels replaceObjectAtIndex:indexSimilarChannel withObject:newChannel];
    }else{
        [bufferChannels addObject:newChannel];
    }
    
    // Выполнить сохранение
    _loadedChannels = [NSArray arrayWithArray:bufferChannels];
    BOOL isSuccessSaved = [self internalSaveStoredChannelsToLocalStore:_loadedChannels];
    return isSuccessSaved;
}


#pragma mark - DELETE FROM STORE

/**
    @abstract Удаляет имеющийся канал
    @discussion
    Проверяет, есть ли схожий канал в хранилище. (с таким же названием)
    Если есть канал - удаляет его из хранилища. (Перезаписывает требуемый файл с каналами)
 
    @param deletingChannel     Модель удаляемого канала
    @return Если удалось удалить канал - YES, иначе - NO
 */
- (BOOL)deleteChannel:(HURSSChannel*)deletingChannel{
    
    // Провереяет, есть ли канал?
    BOOL containgDeletingChannel = [self containsChannelWithName:deletingChannel.channelAlias];
    if(containgDeletingChannel){
        
        // Находит индекс канала, и удаляет
        NSUInteger indexDeletingChannel = [self indexOfChannelWithName:deletingChannel.channelAlias];
        NSMutableArray <HURSSChannel*> *bufferChannels = [_loadedChannels mutableCopy];
        [bufferChannels removeObjectAtIndex:indexDeletingChannel];
        _loadedChannels = [NSArray arrayWithArray:bufferChannels];
        
        // Выполняет синхронизацию с хранилищем
        BOOL isSuccessSaved = [self internalSaveStoredChannelsToLocalStore:_loadedChannels];
        return isSuccessSaved;
    }
    return NO;
}


#pragma mark - CHANNELs Names

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


#pragma mark - CHECK Exist Channel

/// Проверяет, содержится ли канал с таким названием в кэше хранилища
- (BOOL)containsChannelWithName:(NSString*)checkChannelName{
    
    for (HURSSChannel *currentChannel in _loadedChannels) {
        
        BOOL isEqualChannelAlias = [checkChannelName isEqualToString:currentChannel.channelAlias];
        if(isEqualChannelAlias){
            return YES;
        }
    }
    return NO;
}

/// Находит индекс канала с таким названием (-1 - если не находит)
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


#pragma mark - INTERNAL Save & Load

/// Получение пути к файлу (по которому будут сохраняться каналы)
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

/**
    @abstract Внутренний метод загрузки каналов из хранилища
    @discussion
    Загрузка каналов из хранилища с различными проверками загруженных данных.
    @note Но вся логика загрузки содержится в процедуре loadChannels
 
    @throw channelsLoadException
        В случае, если данные не загрузились, но файл существует (для HU_RSS_USE_FILE_SERIALIZATION == 1)
    @throw channelsArrayException
        В случае, если не удалось воссоздать массив
 
    @throw channelsDataException
        В случае, если загруженные данные - не объекты каналов
 
    @return Возвращает загруженный массив каналов (или пустой массив, если не удалось)
 */
- (NSArray <HURSSChannel*>*)internalLoadStoredChannelsFromLocalStore{
    
    // Загрузить данные подходящим способом
    id unarchivedChannelsData = [self loadChannels];
    NSArray<HURSSChannel*> *storedChannels = (NSArray<HURSSChannel*>*)unarchivedChannelsData;
    
    BOOL isLoadedData = (unarchivedChannelsData != nil);
    
#if HU_RSS_USE_FILE_SERIALIZATION == 1
    
    // Если файл существует, но загрузить не удалось - сгенерить исключение
    NSString *storedChannelsFilePath = [self storedChannelsFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isChannelsFileExist = [fileManager fileExistsAtPath:storedChannelsFilePath];
    if(! isLoadedData && isChannelsFileExist){
        @throw [NSException exceptionWithName:@"channelsLoadException" reason:@"Unfortunately! Channels list don't restored from File" userInfo:nil];
    }
#endif
    // Если просто загрузить не удалось - вернуть пустой массив
    if(! isLoadedData){
        return [NSArray new];
    }
    
    // Проверка полученного массив каналов на валидность
    BOOL isChannelsArray = ([unarchivedChannelsData isKindOfClass:[NSArray class]]);
    if(! isChannelsArray){
        @throw [NSException exceptionWithName:@"channelsArrayException" reason:@"Loaded Data From File is not a NSArray" userInfo:nil];
    }
    
    BOOL isCorrectChannels = (storedChannels.count > 0 && [[storedChannels firstObject] isKindOfClass:[HURSSChannel class]]) || storedChannels.count == 0;
    if(! isCorrectChannels){
        @throw [NSException exceptionWithName:@"channelsDataException" reason:@"Loaded Data From File is not objects RSSChannels" userInfo:nil];
    }
    
    return  storedChannels;
}

/// Внутренний метод-враппер для saveChannels:
- (BOOL)internalSaveStoredChannelsToLocalStore:(NSArray<HURSSChannel*>*)channelsToStore{
    
    BOOL isSavedData = [self saveChannels:channelsToStore];
    return isSavedData;
}


#pragma mark - WORK With LOCAL Stores

/**
    @abstract Метод, где выполняется загрузка каналов
    @discussion
    Реализуются 2 способа загрузки :
    <ul>
        <li> Загрузка из NSUserDefaults
            (HU_RSS_USE_LOCAL_PREFERENCES == 1) </li>
        <li> Загрузка из файла
            (HU_RSS_USE_FILE_SERIALIZATION == 1) </li>
    </ul>
 */
- (id)loadChannels{
    
#if HU_RSS_USE_LOCAL_PREFERENCES == 1
    // Загрузка из NSUserDefaults, после чего десериализуются полученные данные
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *channelsArchivedData = (NSData*)[userDefaults objectForKey:HU_RSS_STORED_CHANNELS_DEFAULTS_KEY];
    if(! channelsArchivedData){
        return nil;
    }
    id channelsData = [NSKeyedUnarchiver unarchiveObjectWithData:channelsArchivedData];
    return channelsData;
    
#elif HU_RSS_USE_FILE_SERIALIZATION == 1
    // Просто загруить данные из файла, и десериализовать их
    NSString *storedChannelsFilePath = [self storedChannelsFilePath];
    id unarchivedChannelsData = [NSKeyedUnarchiver unarchiveObjectWithFile:storedChannelsFilePath];
    return unarchivedChannelsData;
#else
    #error Need to determine on of constants : HU_RSS_USE_LOCAL_PREFERENCES or HU_RSS_USE_FILE_SERIALIZATION
#endif
}

/**
    @abstract Метод, где выполняется сохранение каналов
    @discussion
    Реализуются 2 способа сохранения :
    <ul>
        <li> Сохранение в NSUserDefaults
            (HU_RSS_USE_LOCAL_PREFERENCES == 1) </li>
        <li> Сохранение в файл
            (HU_RSS_USE_FILE_SERIALIZATION == 1) </li>
    </ul>
 */
- (BOOL)saveChannels:(id)channels{
    
    // Если каналы не переданы - не делает ничего
    if(! channels){
        return NO;
    }
    
#if HU_RSS_USE_LOCAL_PREFERENCES == 1
    // Сохранение в NSUserDefaults, сериализуются данные и синхронизируются
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *channelsArchivedData = [NSKeyedArchiver archivedDataWithRootObject:channels];
    [userDefaults setObject:channelsArchivedData forKey:HU_RSS_STORED_CHANNELS_DEFAULTS_KEY];
    BOOL isSuccessSynchronize = [userDefaults synchronize];
    return isSuccessSynchronize;
    
#elif HU_RSS_USE_FILE_SERIALIZATION == 1
    // Сохранение в файл, данные перед сохранением сериализуются
    NSString *storedChannelsFilePath = [self storedChannelsFilePath];
    BOOL isSavedData = [NSKeyedArchiver archiveRootObject:channels toFile:storedChannelsFilePath];
    return isSavedData;
#else
    #error Need to determine on of constants : HU_RSS_USE_LOCAL_PREFERENCES or HU_RSS_USE_FILE_SERIALIZATION
#endif
}

/// Очистить список каналов (удалить  данные из используемого хранилища)
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



