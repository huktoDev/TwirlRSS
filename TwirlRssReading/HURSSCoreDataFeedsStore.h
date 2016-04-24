//
//  HURSSCoreDataFeedsStore.h
//  CoreDataTestProject2
//
//  Created by Alexandr Babenko on 08.02.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;


#import "HURSSManagedFeedInfo.h"

@interface HURSSCoreDataFeedsStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)feedsStore;

- (void)configurationDefaultStore;

- (NSPersistentStoreCoordinator*)createStoreCoordinator;
- (NSManagedObjectModel*)createManagedObjectModel;
- (NSManagedObjectContext*)createManagedObjectContext;

- (NSEntityDescription*)feedItemEntity;
- (NSEntityDescription*)feedInfoEntity;

- (HURSSFeedInfo*)generateEmptyFeedInfo;


- (BOOL)saveFeedInfo:(HURSSFeedInfo*)savingFeedInfo;

- (NSArray <HURSSFeedInfo*> *)loadFeedInfo;



@end
