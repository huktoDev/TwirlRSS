//
//  HURSSCoreDataStore.m
//  CoreDataTestProject2
//
//  Created by Alexandr Babenko on 08.02.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSCoreDataFeedsStore.h"


NSString* const HU_RSS_FEED_DB_FILENAME = @"FeedsRSSTest2.sqlite";


#define MODEL_MANUAL_CREATING 0

@implementation HURSSCoreDataFeedsStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)feedsStore{
    
    static HURSSCoreDataFeedsStore *_sharedFeedsStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFeedsStore = [HURSSCoreDataFeedsStore new];
        [_sharedFeedsStore configurationDefaultStore];
    });
    
    return _sharedFeedsStore;
}

- (void)configurationDefaultStore{
    
    _managedObjectModel = [self createManagedObjectModel];
    _persistentStoreCoordinator = [self createStoreCoordinator];
    _managedObjectContext = [self createManagedObjectContext];
}

- (NSManagedObjectModel *)createManagedObjectModel {

    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
#if MODEL_MANUAL_CREATING == 1
    
    NSEntityDescription *personEntity  = [self personEntity];
    NSEntityDescription *bookEntity = [self bookEntity];
    
    NSRelationshipDescription *bookRelationship = [NSRelationshipDescription  new];
    bookRelationship.name = @"owner";
    bookRelationship.destinationEntity = bookEntity;
    bookRelationship.deleteRule = NSNullifyDeleteRule;
    bookRelationship.maxCount = 1;
    bookRelationship.minCount = 1;
    
    NSRelationshipDescription *personRelationship = [NSRelationshipDescription  new];
    personRelationship.name = @"book";
    personRelationship.destinationEntity = bookEntity;
    personRelationship.deleteRule = NSNullifyDeleteRule;
    personRelationship.maxCount = 1;
    personRelationship.minCount = 1;
    
    bookEntity.properties = [bookEntity.properties arrayByAddingObject:bookRelationship];
    personEntity.properties = [personEntity.properties arrayByAddingObject:personRelationship];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel new];
    managedObjectModel.entities = @[personEntity, bookEntity];
    
#else
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FeedsDataModel" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
#endif
    
    return managedObjectModel;
}

/// Создание координатора хранилищ (Извлекает файл базы данных, и добавляет хранилище в координатор)
- (NSPersistentStoreCoordinator *)createStoreCoordinator {
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:HU_RSS_FEED_DB_FILENAME];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

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

/*
- (NSEntityDescription*)personEntity{
    
    static NSEntityDescription *personEntity = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSAttributeDescription *firstNameProperty = [NSAttributeDescription new];
        firstNameProperty.name = @"firstName";
        firstNameProperty.optional = NO;
        firstNameProperty.transient = NO;
        firstNameProperty.attributeType = NSStringAttributeType;
        
        NSAttributeDescription *secondNameProperty = [NSAttributeDescription new];
        secondNameProperty.name = @"secondName";
        secondNameProperty.optional = NO;
        secondNameProperty.transient = NO;
        secondNameProperty.attributeType = NSStringAttributeType;
        
        NSAttributeDescription *ageProperty = [NSAttributeDescription new];
        ageProperty.name = @"age";
        ageProperty.optional = YES;
        ageProperty.transient = NO;
        ageProperty.attributeType = NSInteger16AttributeType;
        
        NSAttributeDescription *phoneProperty = [NSAttributeDescription new];
        phoneProperty.name = @"phone";
        phoneProperty.optional = NO;
        phoneProperty.transient = NO;
        phoneProperty.attributeType = NSTransformableAttributeType;
        phoneProperty.attributeValueClassName = @"NSString";
        phoneProperty.defaultValue = @"+7";
        
        personEntity = [NSEntityDescription new];
        
        personEntity.name = @"Person";
        personEntity.managedObjectClassName = @"Person";
        personEntity.abstract = NO;
        
        NSArray <NSAttributeDescription*> *personPropertiesArray = @[firstNameProperty, secondNameProperty, ageProperty, phoneProperty];
        personEntity.properties = personPropertiesArray;
    });
    
    return personEntity;
}

- (NSEntityDescription*)bookEntity{
    
    static NSEntityDescription *bookEntity = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSAttributeDescription *nameProperty = [NSAttributeDescription new];
        nameProperty.name = @"name";
        nameProperty.optional = NO;
        nameProperty.transient = NO;
        nameProperty.attributeType = NSStringAttributeType;
        nameProperty.attributeValueClassName = @"NSString";
        nameProperty.defaultValue = @"TestName";
        
        NSAttributeDescription *authorPropety = [NSAttributeDescription new];
        authorPropety.name = @"author";
        authorPropety.optional = NO;
        authorPropety.transient = NO;
        authorPropety.attributeType = NSStringAttributeType;
        authorPropety.attributeValueClassName = @"NSString";
        
        NSAttributeDescription *countPagesPropety = [NSAttributeDescription new];
        countPagesPropety.name = @"countPages";
        countPagesPropety.optional = NO;
        countPagesPropety.transient = NO;
        countPagesPropety.attributeType = NSInteger32AttributeType;
        
        bookEntity = [NSEntityDescription new];
        
        bookEntity.name = @"Book";
        bookEntity.managedObjectClassName = @"Book";
        bookEntity.abstract = NO;
        
        NSArray <NSAttributeDescription*> *bookPropertiesArray = @[nameProperty, authorPropety, countPagesPropety];
        bookEntity.properties = bookPropertiesArray;
    });
    
    return bookEntity;
}
 */

/*
- (Person*)genratePerson{
    
    NSEntityDescription *personEntity = [self personEntity];
    Person *newPerson = (Person*)[NSEntityDescription insertNewObjectForEntityForName:personEntity.name inManagedObjectContext:self.managedObjectContext];
    
    return newPerson;
}

- (Book*)generateBook{
    
    NSEntityDescription *bookEntity = [self bookEntity];
    Book *newBook = (Book*)[NSEntityDescription insertNewObjectForEntityForName:bookEntity.name inManagedObjectContext:self.managedObjectContext];
    
    return newBook;
}
 */

- (BOOL)saveFeedInfo:(HURSSFeedInfo*)savingFeedInfo{
    
    // конвертировать в Managed Model, и сохранить контекст
    
    [HURSSManagedFeedInfo createFeedInfoFrom:savingFeedInfo];
    
    NSError *savingError = nil;
    BOOL isSuccessSaved = [self.managedObjectContext save:&savingError];
    
    if(isSuccessSaved && !savingError){
        return YES;
    }else{
        NSLog(@"UNSUCCESS Saving HURSSManagedFeedInfo object with Error %@", savingError);
        return NO;
    }
}

- (NSArray <HURSSFeedInfo*> *)loadFeedInfo{
    
    NSFetchRequest *feedInfoFetchRequest = [[NSFetchRequest alloc] init];
    NSString *feedInfoEntityName = [HURSSManagedFeedInfo entityName];
    
    NSEntityDescription *feedInfoEntity = [NSEntityDescription entityForName:feedInfoEntityName inManagedObjectContext:self.managedObjectContext];
    [feedInfoFetchRequest setEntity:feedInfoEntity];
    
    NSError *fetchingError = nil;
    NSArray <HURSSManagedFeedInfo*> *restoredFeedInfoArray = [self.managedObjectContext executeFetchRequest:feedInfoFetchRequest error:&fetchingError];
    
    if(fetchingError){
        NSLog(@"FETCHING HURSSManagedFeedInfo objects with Error %@", fetchingError);
        return nil;
    }
    
    NSMutableArray <HURSSFeedInfo*> *convertedFeedInfoArray = [NSMutableArray new];
    for (HURSSManagedFeedInfo *managedFeedInfo in restoredFeedInfoArray) {
        
        HURSSFeedInfo *simpleFeedInfo = [managedFeedInfo convertToSimpleRSSInfoModel];
        [convertedFeedInfoArray addObject:simpleFeedInfo];
    }
    
    return [[NSArray alloc] initWithArray:convertedFeedInfoArray];
}


- (void)loadContext{
    
}


- (BOOL)saveContext{
    return YES;
}





@end
