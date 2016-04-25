//
//  HURSSManagedFeedItem.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
    @class HURSSManagedFeedItem
    @author HuktoDev
    @updated 25.04.2016
    @abstract Модель RSS-новости для контекста  CoreData
    @discussion
    Используется только в HURSSCoreDataFeedsStore, для работы в контексте CoreData. Имеет методы для конвертации в модель, и обратно. При создании модели - модель сразу создается на нужном контексте (сама знает, где себя создавать)
 
    @note Ссылка здесь сохраняется в NSString, так как CoreData не  поддерживает напрямую сохранение NSURL объектов (разве что реализовывать специальный протокол для Transformable)
 
    @note attribSummary сохраняется в виде бинарных данных, т.к. NSAttributedString поддерживает NSSecureCoding, возможности которого используются в методах конвертации
 
    Имеются 2 типа конвертации - прямая и обратная :
    HURSSFeedItem -> HURSSManagedFeedItem
    HURSSManagedFeedItem -> HURSSFeedItem
 
    @see
    HURSSFeedItem \n
    HURSSCoreDataFeedsStore \n
 */
@interface HURSSManagedFeedItem : NSManagedObject

#pragma mark - CONTEXT Info
// Вспомогательная информация для CoreData Context-а

+ (NSManagedObjectContext*)usedManagedContext;
+ (NSString*)entityName;


#pragma mark - Convertations
// Конвертация

+ (instancetype)createFeedItemFrom:(HURSSFeedItem*)feedItem;
- (HURSSFeedItem*)convertToSimpleRSSItemModel;


#pragma mark - MODEL Properties
// Свойства модели

@property (copy, nonatomic) NSString    *identifier;
@property (copy, nonatomic) NSString    *title;
@property (copy, nonatomic) NSString    *link;

@property (copy, nonatomic) NSString    *author;
@property (copy, nonatomic) NSDate      *creationDate;
@property (copy, nonatomic) NSDate      *updatedDate;

@property (copy, nonatomic) NSString    *summary;
@property (copy, nonatomic) NSString    *content;


@property (strong, nonatomic) NSData    *attribSummary;
@property (copy, nonatomic) NSString    *formattedDate;
@property (copy, nonatomic) NSNumber    *titleHeight;
@property (copy, nonatomic) NSNumber    *summaryHeight;



@end

