//
//  HURSSFeedsReciever.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 24.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HURSSCoreDataFeedsStore.h"

#import "HURSSFeedInfo.h"
#import "HURSSFeedItem.h"
#import "HURSSChannel.h"


@class HURSSFeedsCache;


/**
    @typedef HURSSFeedItemBlock
        Блок для оабработчика окончания метода  prepareHTML для конкретного айтема
 */
typedef void(^HURSSFeedItemBlock)(NSAttributedString *recievedString, CGFloat heightContent);

/**
    @typedef HURSSFeedsCacheRecievingBlock
        Блок-коллбэк для найденных новостей из кэша
 */
typedef void(^HURSSFeedsCacheRecievingBlock)(HURSSChannel* feedsChannel, HURSSFeedInfo* cachedFeedInfo, NSArray<HURSSFeedItem*> *cahcedFeeds);


/**
    @protocol HURSSFeedsRecieverDelegate
    @author HuktoDev
    @updated 24.04.2016
    @abstract Интерфейс делегата сервиса HURSSFeedsReciever
    @discussion
    Благодаря этому интерфейсу - объект, который его реализует, и становится делегатом сервиса - может получать через методы интерфейса- информацию от сервиса
 
    @note  Имеет 2 метода :
    <ol type="a">
        <li> Новости удалось получить (возвращает их) </li>
        <li> Новости не удалось получить (возвращает описание ошибки) </li>
    </ol>
    
    @see
    HURSSFeedsReciever \n
 */
@protocol HURSSFeedsRecieverDelegate <NSObject>

- (void)didSuccessRecievedFeeds:(NSArray<HURSSFeedItem*>*)recievedFeeds withFeedInfo:(HURSSFeedInfo*)recievedFeedInfo forChannel:(HURSSChannel*)feedsChannel;
- (void)didFailureRecievingFeedsWithErrorDescription:(NSString*)errorDescription forChannel:(HURSSChannel*)feedsChannel;


@end


/**
    @protocol HURSSFeedsLocalRecievingProtocol
    @author HuktoDev
    @updated 25.04.2016
    @abstract  Протокол для получения новостей из локально хранилища
    @discussion
    Используется для определения интерфейса, например, сервиса дата провайдера, извлекающего данные из БД (в данном случае - Sqlite через Core Data)
 
    Имеет 3 метода :
    <ol type="a">
        <li> Имеются ли закэшированные (сохраненные) новости для этого канала? </li>
        <li> Основной метод получения новостей для заданного канала </li>
        <li> Отмена получения (опционально) </li>
    </ol>
 */
@protocol HURSSFeedsLocalRecievingProtocol <NSObject>

@required
- (BOOL)haveCachedFeedsForChannel:(HURSSChannel*)feedsChannel;
- (void)getCachedFeedsForChannel:(HURSSChannel*)feedsChannel withCallback:(void (^)(HURSSChannel*, HURSSFeedInfo*, NSArray<HURSSFeedItem*>*))cachedInfoCallback;

@optional
- (void)cancelCachedFeedsRecieving;


@end


/**
    @protocol HURSSFeedsRemoteRecievingProtocol
    @author HuktoDev
    @updated 25.04.2016
    @abstract Протокол для получения новостей из удаленного источника
    @discussion
    Используется для определения интерфейса дата провайдера, загружающего данные с удаленного  сайта, например
    Имеет метод загрузки, и отмены загрузки.
 
    @note Имеется опциональное свойство для передачи дополнительных параметров для обработки
 */
@protocol HURSSFeedsRemoteRecievingProtocol <NSObject>

@required

- (void)loadFeedsForChannel:(HURSSChannel*)feedsChannel;
- (void)cancelLoading;

@optional

@property (strong, nonatomic) NSDictionary <NSString*, id> *feedParseProperties;

@end


/**
    @protocol HURSSFeedsRecievingProtocol
    @author HuktoDev
    @updated 25.04.2016
    @abstract Совмещенный интерфейс, унаследованный от 2х протоколов передачи
    @discussion
    Позволяет объекту, его реализующему определять методы, как для локального получения информации, так и для удаленного. Используется фасадом-ресивером
    Определяет делегата для получения информации
 */
@protocol HURSSFeedsRecievingProtocol <HURSSFeedsLocalRecievingProtocol, HURSSFeedsRemoteRecievingProtocol>

/// Делегат для возврата результатов поиска
@property (weak, nonatomic) id <HURSSFeedsRecieverDelegate> feedsDelegate;

@end




/**
    @class HURSSFeedsReciever
    @author  HuktoDev
    @updated 25.04.2016
    @abstract Общий класс-ресивер для всех источников новостей в приложении
    @discussion
    Собственно, является фасадом для нескольких объектов, и сам определяет, когда, какую и откуда информацию предоставить пользователю.
 
    <h4> Объединяет следующий функционал : </h4>
    <ol type="a">
        <li> MWFeedParser - опенсорсного RSS-парсера (загружает RSS из  сети, и парсит в модели) </li>
        <li> HURSSFeedsCache - содержит в себе новостной кэш приложения, и если нет - грузит новости из базы данных </li>
        <li> Различная постобработка  данных, полученных моделей </li>
    </ol>
 
    @see
    <a href="https://github.com/mwaterfall/MWFeedParser"> MWFeedParser на GitHub </a>
    HURSSFeedsCache \n
    HURSSCoreDataFeedsStore \n
    HURSSFeedsRecievingProtocol \n
 */
@interface HURSSFeedsReciever : NSObject <MWFeedParserDelegate, HURSSFeedsRecievingProtocol>

#pragma mark - Constructor
+ (instancetype)sharedReciever;


#pragma mark - HURSSFeedsRemoteRecievingProtocol
// Часть интерфейса для получения новостей удаленно

- (void)loadFeedsForChannel:(HURSSChannel*)feedsChannel;
- (void)cancelLoading;


#pragma mark - HURSSFeedsLocalRecievingProtocol
// Часть интерфейса для получения новостей локально

- (BOOL)haveCachedFeedsForChannel:(HURSSChannel*)feedsChannel;
- (void)getCachedFeedsForChannel:(HURSSFeedsCacheRecievingBlock)cachedInfoCallback;
- (void)cancelCachedFeedsRecieving;


@end


