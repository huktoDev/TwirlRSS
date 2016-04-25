//
//  HURSSPreservedChannelSet.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
    @protocol HURSSReservedChannelSetProtocol
    @author HuktoDev
    @updated 22.04.2016
    @abstract Протокол, обязательный для классов, предоставляющие предпоределенные наборы каналов
    @discussion
    Самое главное - определять получение зарезервированных каналов
    Кроме всего, имеется дополнительный метод для получения названий каналов
 */
@protocol HURSSReservedChannelSetProtocol <NSObject>

@required
- (NSArray <HURSSChannel*>*)getReservedChannels;
@optional
- (NSArray <NSString*>*)getReservedChannelsNames;


@end

/**
    @class HURSSReservedChannelSet
    @author HuktoDev
    @updated 22.04.2016
    @abstract Класс для набора предопределенных каналов.
    @discussion
    Используется для формирования различных наборов предопределенных каналов (тех, которые показываются пользователю при первом входе в приложение (получаемые из HURSSChannelStore)).
    Имеется методы для получения каналов по-умолчанию, определенных на клиентской стороне
 
 
    @note С помощью этого класса - можно по идее загружать кастомные наборы каналов (из специально присланного конфиг-файла), набор каналов можно присылать в зависимости от предпочтений пользователя.
 
    @see
    HURSSChannelStore \n
 */
@interface HURSSReservedChannelSet : NSObject <HURSSReservedChannelSetProtocol>


#pragma mark - CUSTOM Channels
// Набор различных, уже готовых каналов

+ (HURSSChannel*)lentaRuRSSChannel;
+ (HURSSChannel*)cnewsRSSChannel;
+ (HURSSChannel*)hiTechRSSChannel;
+ (HURSSChannel*)habrahabrRSSChannel;


#pragma mark - DEFAULT SET
// Набор каналов по-умолчанию

+ (instancetype)defaultChannelsSet;
- (instancetype)initWithChannels:(NSArray<HURSSChannel*>*)channels;


#pragma mark - ADD Channel
// Добавить канал в набор

- (void)addNewReservedChannel:(HURSSChannel*)newChannel;

- (NSArray <HURSSChannel*>*)getReservedChannels;
- (NSArray <NSString*>*)getReservedChannelsNames;

@end
