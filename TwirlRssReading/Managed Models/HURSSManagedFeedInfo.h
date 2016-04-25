//
//  HURSSManagedFeedInfo.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
    @class HURSSManagedFeedInfo
    @author HuktoDev
    @updated 25.04.2016
    @abstract Модель метаданных канала для контекста  CoreData
    @discussion
    Используется только в HURSSCoreDataFeedsStore, для работы в контексте CoreData. Имеет методы для конвертации в модель, и обратно. При создании модели - модель сразу создается на нужном контексте (сама знает, где себя создавать)
    
    @note Ссылка здесь сохраняется в NSString, так как CoreData не  поддерживает напрямую сохранение NSURL объектов (разве что реализовывать специальный протокол для Transformable)
 
    Имеются 2 типа конвертации - прямая и обратная :
    HURSSFeedInfo -> HURSSManagedFeedInfo
    HURSSManagedFeedInfo -> HURSSFeedInfo
 
    @see
    HURSSFeedInfo \n
    HURSSCoreDataFeedsStore \n
 */
@interface HURSSManagedFeedInfo : NSManagedObject

#pragma mark - CONTEXT Info
// Вспомогательная информация для CoreData Context-а

+ (NSManagedObjectContext*)usedManagedContext;
+ (NSString*)entityName;


#pragma mark - Convertations
// Конвертация

+ (instancetype)createFeedInfoFrom:(HURSSFeedInfo*)feedInfo;
- (HURSSFeedInfo*)convertToSimpleRSSInfoModel;


#pragma mark - MODEL Properties
// Свойства модели

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *url;


@end


