//
//  HURSSManagedFeedItem.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSManagedFeedItem.h"

@implementation HURSSManagedFeedItem

// Динамически переопределяемые методы доступа
@dynamic identifier;
@dynamic title;
@dynamic link;
@dynamic author;
@dynamic creationDate;
@dynamic updatedDate;
@dynamic summary;
@dynamic content;

@dynamic attribSummary;
@dynamic formattedDate;
@dynamic titleHeight;
@dynamic summaryHeight;


#pragma mark - CONTEXT Info

/// Испоьзуемый контекст CoreData
+ (NSManagedObjectContext*)usedManagedContext{
    return [HURSSCoreDataFeedsStore feedsStore].managedObjectContext;
}

/// Название сущности этого NSManagedObject в модели CoreData
+ (NSString*)entityName{
    return @"FeedItem";
}


#pragma mark - Convertations

/// Создаем модель для работы в контексте из основного типа модели
+ (instancetype)createFeedItemFrom:(HURSSFeedItem*)feedItem{
    
    NSManagedObjectContext *usedContext = [[self class] usedManagedContext];
    NSString *entityName = [[self class] entityName];
    
    HURSSManagedFeedItem *managedFeedItem = (HURSSManagedFeedItem*)[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:usedContext];
    
    managedFeedItem.identifier = feedItem.identifier;
    managedFeedItem.title = feedItem.title;
    managedFeedItem.link = feedItem.link;
    managedFeedItem.author = feedItem.author;
    managedFeedItem.creationDate = feedItem.date;
    managedFeedItem.updatedDate = feedItem.updated;
    managedFeedItem.summary = feedItem.summary;
    managedFeedItem.content = feedItem.content;
    
    // Архивирует аттрибутированную  строку в объект NSData
    managedFeedItem.attribSummary = [NSKeyedArchiver archivedDataWithRootObject:feedItem.attributedSummary];
    managedFeedItem.formattedDate = feedItem.formattedCreationDate;
    managedFeedItem.titleHeight = @(feedItem.titleContentHeight);
    managedFeedItem.summaryHeight = @(feedItem.summaryContentHeight);
    
    return managedFeedItem;
    
}

/// Конвертируем объект контекста в более используемую в приложении модель
- (HURSSFeedItem*)convertToSimpleRSSItemModel{
    
    HURSSFeedItem *convertedFeedItem = [HURSSFeedItem new];
    
    convertedFeedItem.identifier = self.identifier;
    convertedFeedItem.title = self.title;
    convertedFeedItem.link = self.link;
    convertedFeedItem.author = self.author;
    convertedFeedItem.date = self.creationDate;
    convertedFeedItem.updated = self.updatedDate;
    convertedFeedItem.summary = self.summary;
    convertedFeedItem.content = self.content;
    
    // Разрхивирует бинарные данные в аттрибутированную  строку
    convertedFeedItem.attributedSummary = [NSKeyedUnarchiver  unarchiveObjectWithData:self.attribSummary];
    convertedFeedItem.formattedCreationDate = self.formattedDate;
    convertedFeedItem.titleContentHeight = [self.titleHeight doubleValue];
    convertedFeedItem.summaryContentHeight = [self.summaryHeight doubleValue];
    
    return convertedFeedItem;
}


@end

