//
//  HURSSManagedChannel.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 25.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "HURSSChannel.h"
#import "HURSSFeedInfo.h"
#import "HURSSFeedItem.h"

#import "HURSSManagedFeedInfo.h"
#import "HURSSManagedFeedItem.h"

@class HURSSManagedFeedInfo;
@class HURSSManagedFeedItem;

/**
    @class HURSSManagedChannel
    @author HuktoDev
    @updated 25.04.2016
    @abstract Модель RSS-канала для контекста  CoreData
    @discussion Центральная модель контекста CoreData. С ней связываются модели метаданных новостей, и сами объекты новостей. Содержит композиционно полученную из RSS-канала информацию.
 
    @note Ссылка здесь сохраняется в NSString, так как CoreData не  поддерживает напрямую сохранение NSURL объектов (разве что реализовывать специальный протокол для Transformable)
 
    Базовая модель HURSSChannel не содержит в себе новости, поэтому не имеется полноценных методов конвертации.
 
    Основной метод - создания канала (Кроме создания объекта канала - связывает с ним объекты новостей, конвертирует ВСЕ объекты, и добавляет их все на контекст)
 
    @see
    HURSSChannel \n
    HURSSCoreDataFeedsStore \n
 */
@interface HURSSManagedChannel : NSManagedObject


#pragma mark - CONTEXT Info
// Вспомогательная информация для CoreData Context-а

+ (NSManagedObjectContext*)usedManagedContext;
+ (NSString*)entityName;


#pragma mark - CREATE & Convert
// Конвертация

+ (instancetype)createChannelFrom:(HURSSChannel*)feedChannel andFillWithInfo:(HURSSFeedInfo*)feedInfo andFillWithFeeds:(NSArray<HURSSFeedItem*>*)feedItems;

- (HURSSChannel*)convertToSimpleRSSChannelModel;


#pragma mark - MODEL Properties
// Свойства модели

@property (copy, nonatomic) NSString *alias;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSNumber *type;

// Информация о новостях, полученных с канала
@property (strong, nonatomic) HURSSManagedFeedInfo *feedInfo;
@property (strong, nonatomic) NSOrderedSet <HURSSManagedFeedItem*> *feeds;


@end

