//
//  HURSSCoreDataStore.m
//  CoreDataTestProject2
//
//  Created by Alexandr Babenko on 08.02.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSCoreDataFeedsStore.h"

/**
    @constant HU_RSS_FEED_DB_FILENAME
        Название файла для базы данных
    @constant HU_RSS_FEED_DATA_MODEL_NAME
        Название файла с моделью базы
 */

NSString* const HU_RSS_FEED_DB_FILENAME = @"FeedsRSSTest8.sqlite";
NSString* const HU_RSS_FEED_DATA_MODEL_NAME = @"FeedsDataModel";

/**
    @def HU_RSS_MODEL_MANUAL_CREATING
        Используется ли программное создание моделей, или создание моделей из файла?
 */
#define HU_RSS_MODEL_MANUAL_CREATING 0


@implementation HURSSCoreDataFeedsStore


#pragma mark - SYNTEZTION Proprties ENV

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - Construction

+ (instancetype)feedsStore{
    
    static HURSSCoreDataFeedsStore *_sharedFeedsStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFeedsStore = [HURSSCoreDataFeedsStore new];
        [_sharedFeedsStore configurationDefaultStore];
    });
    
    return _sharedFeedsStore;
}


#pragma mark - DEFAULT Config

- (void)configurationDefaultStore{
    
    _managedObjectModel = [self createManagedObjectModel];
    _persistentStoreCoordinator = [self createStoreCoordinator];
    _managedObjectContext = [self createManagedObjectContext];
}


#pragma mark - CREATION Core Data ENVIRONMENT

/// Метод создания CoreData модели БД, выступает так-же в качестве акцессора
- (NSManagedObjectModel *)createManagedObjectModel {

    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
#if HU_RSS_MODEL_MANUAL_CREATING == 1
    // Здесь модель БД можно строить программно (не успел)
#else
    // Извлекает модель из специального файла
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:HU_RSS_FEED_DATA_MODEL_NAME withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
#endif
    
    return managedObjectModel;
}

/// Создание координатора хранилищ (Извлекает файл базы данных, и добавляет хранилище в координатор) (скопирован функционал из стандартного Apple CoreData каркаса)
- (NSPersistentStoreCoordinator *)createStoreCoordinator {
    
    // Инициализирует хранилище моделью
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    // Формирует путь к хранилищу
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:HU_RSS_FEED_DB_FILENAME];
    
    // Пытается создать хранилище, если требуется, либо загрузить
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        // Если возникла ошибка - прервать приложение
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

/// Создание контекста для моделей из базы данных
- (NSManagedObjectContext *)createManagedObjectContext {
    
    // Если хранилище не удалось получить
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (! coordinator) {
        return nil;
    }
    
    // Устанавливает хранилище в контекст, из которого будут тягаться данные
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return managedObjectContext;
}

/// Путь к папке Documents приложения
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Work With FeedInfo

/**
    @abstract Сохраняет метаданные нового канала в базу
    @discussion
    Изначально использовалось для теста. Сейчас не используется
    @param savingFeedInfo     Сохраняемая информация о метаданных канала
    @return Удалось ли сохранить новость?
 */
- (BOOL)saveFeedInfo:(HURSSFeedInfo*)savingFeedInfo{
    
    // Конвертировать в Managed Model
    // HURSSFeedInfo -> HURSSManagedFeedInfo
    [HURSSManagedFeedInfo createFeedInfoFrom:savingFeedInfo];
    
    // Выполнить транзакцию на сохранение в базу
    NSError *savingError = nil;
    BOOL isSuccessSaved = [self.managedObjectContext save:&savingError];
    
    // Удалось ли сохранить?
    if(isSuccessSaved && !savingError){
        return YES;
    }else{
        NSLog(@"UNSUCCESS Saving HURSSManagedFeedInfo object with Error %@", savingError);
        return NO;
    }
}

/**
    @abstract Загружает метаданные всех каналов
    @discussion
    Изначально использовался только для теста. Да и сейчас не используется, но оставил на случай крайней надобности.
    @return Массив метаданных заголовков каналов
 */
- (NSArray <HURSSFeedInfo*> *)loadFeedInfo{
    
    // Создать запрос на выборку объектов HURSSManagedFeedInfo
    NSFetchRequest *feedInfoFetchRequest = [[NSFetchRequest alloc] init];
    NSString *feedInfoEntityName = [HURSSManagedFeedInfo entityName];
    
    // Получить и установить сущность HURSSManagedFeedInfo в выборку
    NSEntityDescription *feedInfoEntity = [NSEntityDescription entityForName:feedInfoEntityName inManagedObjectContext:self.managedObjectContext];
    [feedInfoFetchRequest setEntity:feedInfoEntity];
    
    // Делает транзакцию к базе, и проверяет на наличие ошибок
    NSError *fetchingError = nil;
    NSArray <HURSSManagedFeedInfo*> *restoredFeedInfoArray = [self.managedObjectContext executeFetchRequest:feedInfoFetchRequest error:&fetchingError];
    
    if(fetchingError){
        NSLog(@"FETCHING HURSSManagedFeedInfo objects with Error %@", fetchingError);
        return nil;
    }
    
    // Конвертирует объекты HURSSManagedFeedInfo -> HURSSFeedInfo
    NSMutableArray <HURSSFeedInfo*> *convertedFeedInfoArray = [NSMutableArray new];
    for (HURSSManagedFeedInfo *managedFeedInfo in restoredFeedInfoArray) {
        
        HURSSFeedInfo *simpleFeedInfo = [managedFeedInfo convertToSimpleRSSInfoModel];
        [convertedFeedInfoArray addObject:simpleFeedInfo];
    }
    
    return [[NSArray alloc] initWithArray:convertedFeedInfoArray];
}



#pragma mark - LOAD & SAVE Feeds

/**
    @abstract Сохраняет информацию канала в базу
    @discussion
    Вся связанная информация с каналом (объект канала HURSSManagedChannel ее композиционно содержит ) - массив новостей, и метаданные канала.
    Изначально передаваемые эти объекты отсутствуют на контексте.
    С помощью метода createChannelFrom все объекты конвертируются, вставляются в контекст, и устанавливаются свойствами HURSSManagedChannel.
 
    После чего выполняется сохранение контекста!
 
    @param channel      Объект канала, для которого надо сохранить информацию
    @param feedInfo      Метаданные канала, полученные при загрузке RSS-новостей
    @param feeds         Массив новостей канала
 
    @return Удалось сохранить объекты в базу, или нет?
 */
- (BOOL)saveRSSChannelInfo:(HURSSChannel*)channel withFeedInfo:(HURSSFeedInfo*)feedInfo withFeeds:(NSArray<HURSSFeedItem*>*)feeds{
    
    // TODO: По идее, надо искать еще схожий канал в базе, и удалять сначала, чтобы не плодить сущности, и не использовать устаревшую информацию
    
    // !!!: Кроме того, нужно время от времени чистить старые новости
    
    // Добавляет все объекты на контекст, и формирует корневую сущность HURSSManagedChannel
    [HURSSManagedChannel createChannelFrom:channel andFillWithInfo:feedInfo andFillWithFeeds:feeds];
    
    // Выполняет сохранение
    NSError *savingError = nil;
    BOOL isSuccessSaved = [self.managedObjectContext save:&savingError];
    
    // Если удалось сохранить
    if(isSuccessSaved && !savingError){
        return YES;
    }else{
        NSLog(@"UNSUCCESS Saving HURSSManagedChannel object with Error %@", savingError);
        return NO;
    }
}

/**
    @abstract Выполняет загрузку новостей для заданного канала из базы
    @discussion
    Загружает весь массив каналов, и выполняет по ним энумерацию, возвращает в блоке информацию для каждого из загруженных каналов
 
    Последовательность выполнения:
    <ol type="1">
        <li> Создат запрос на выборку каналов </li>
        <li> Выполнить запрос  на выборку </li>
        <li> Для каждого канала - конвертнуть модели в исходные </li>
        <li> После конвертации каждой модели - возвращает в коллбэк </li>
    </ol>
 
    @warning Возможно, готовые AttributedString хранить в базе слегка нереентабельно!
 
    @param loadingChannelBlock       Блок, возвращающий  информацию для каждого из загруженных каналов
 */
- (void)loadRSSChannelsWithCallback:(void (^)(HURSSChannel*, HURSSFeedInfo*, NSArray<HURSSFeedItem*>*, BOOL*))loadingChannelBlock{
    
    // Сделать запрос на выборку для получения каналов
    NSFetchRequest *feedChannelFetchRequest = [[NSFetchRequest alloc] init];
    NSString *feedChannelEntityName = [HURSSManagedChannel entityName];
    
    // Получить описание сущность канала
    NSEntityDescription *feedChannelEntity = [NSEntityDescription entityForName:feedChannelEntityName inManagedObjectContext:self.managedObjectContext];
    [feedChannelFetchRequest setEntity:feedChannelEntity];
    
    // Извлечь массив каналов
    NSError *fetchingError = nil;
    NSArray <HURSSManagedChannel*> *restoredFeedChannelArray = [self.managedObjectContext executeFetchRequest:feedChannelFetchRequest error:&fetchingError];
    
    // Удалось ли извлечь
    if(fetchingError){
        NSLog(@"FETCHING HURSSManagedChannel objects with Error %@", fetchingError);
        return;
    }
    
    // Если извлечь удалось - перечисляет каждый канал, конвертирует сущность, и передает в блок
    for (HURSSManagedChannel *managedChannel in restoredFeedChannelArray) {
        
        // Конвертировать канал, и метаданные канала
        // HURSSManagedChannel -> HURSSChannel
        // HURSSNManagedFeedInfo -> HURSSFeedInfo
        HURSSChannel *convertedChannel = [managedChannel convertToSimpleRSSChannelModel];
        HURSSFeedInfo *convertedFeedInfo = [managedChannel.feedInfo convertToSimpleRSSInfoModel];
        
        // Конвертировать новости
        // HURSSManagedFeedItem -> HURSSFeedItem
        NSMutableArray <HURSSFeedItem*> *convertedFeedItems = [[NSMutableArray alloc] initWithCapacity:managedChannel.feeds.count];
        for (HURSSManagedFeedItem *managedFeedItem in managedChannel.feeds) {
            
            HURSSFeedItem *convertedFeedItem = [managedFeedItem convertToSimpleRSSItemModel];
            [convertedFeedItems addObject:convertedFeedItem];
        }
        NSArray <HURSSFeedItem*> *nonMutableFeedItems = [[NSArray alloc] initWithArray:convertedFeedItems];
        
        // Передать готовые модели в блоке (если needBreak извне указали в YES - прервать энумерацию)
        if(loadingChannelBlock){
            
            BOOL needBreak = NO;
            loadingChannelBlock(convertedChannel, convertedFeedInfo, nonMutableFeedItems, &needBreak);
            if(needBreak){
                break;
            }
        }
    }
}



@end
