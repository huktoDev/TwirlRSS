//
//  HURSSPreservedChannelSet.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSReservedChannelSet.h"
#import "HURSSChannel.h"

@implementation HURSSReservedChannelSet{
    
    // Предопределенные каналы
    NSArray <HURSSChannel*> *_reservedChannels;
    NSArray <NSString*> *_reservedChannelNames;
}


#pragma mark - CUSTOM Channels

/// RSS-канал для lenta.ru
+ (HURSSChannel*)lentaRuRSSChannel{
    
    NSURL *lentaRuRSSUrl = [NSURL URLWithString:@"http://lenta.ru/rss"];
    HURSSChannel *lentaRuRSSChannel = [HURSSChannel channelWithAlias:@"Lenta.ru" withURL:lentaRuRSSUrl withType:HURSSChannelReserved];
    return lentaRuRSSChannel;
}

/// RSS-канал для cnews (RBC)
+ (HURSSChannel*)cnewsRSSChannel{
    
    NSURL *cnewsRSSUrl = [NSURL URLWithString:@"http://static.feed.rbc.ru/rbc/internal/rss.rbc.ru/cnews.ru/mainnews.rss"];
    HURSSChannel *cnewsRSSChannel = [HURSSChannel channelWithAlias:@"CNews" withURL:cnewsRSSUrl withType:HURSSChannelReserved];
    return cnewsRSSChannel;
}

/// RSS-канал для hiTect  (от Яндекса)
+ (HURSSChannel*)hiTechRSSChannel{
    
    NSURL *hiTechRSSUrl = [NSURL URLWithString:@"http://news.yandex.ru/computers.rss"];
    HURSSChannel *hiTechRSSChannel = [HURSSChannel channelWithAlias:@"Hi-Tech от Yandex" withURL:hiTechRSSUrl withType:HURSSChannelReserved];
    return hiTechRSSChannel;
}

/// RSS-канал хабра (профильный хаб мобильной разработки)
+ (HURSSChannel*)habrahabrRSSChannel{
    
    NSURL *habrahabrRSSUrl = [NSURL URLWithString:@"https://habrahabr.ru/rss/hub/mobile_dev/"];
    HURSSChannel *habrahabrRSSChannel = [HURSSChannel channelWithAlias:@"Habrahabr Mobile Dev" withURL:habrahabrRSSUrl withType:HURSSChannelReserved];
    return habrahabrRSSChannel;
}

#pragma mark - DEFAULT SET

/**
    @abstract Получить набор RSS-каналов по-умолчанию
    @discussion
    Основной набор RSS-каналов (содержит 4 канала) :
    <ol type="1">
        <li> Канал Lenta.ru </li>
        <li> Канал Cnews (rbc.ru) </li>
        <li> Канал HiTect (yandex.ru) </li>
        <li> Канал хабра (новости мобильной разработки) (habrahabr.ru) </li>
    </ol>
    @return Готовый набор каналов по-умолчанию
 */
+ (instancetype)defaultChannelsSet{
    
    static HURSSReservedChannelSet *_defaulChannelSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaulChannelSet = [HURSSReservedChannelSet new];
        
        HURSSChannel *lentaRuRSSChannel = [[self class] lentaRuRSSChannel];
        HURSSChannel *cnewsRSSChannel = [[self class] cnewsRSSChannel];
        HURSSChannel *hiTechRSSChannel = [[self class] hiTechRSSChannel];
        HURSSChannel *habrahabrRSSChannel = [[self class] habrahabrRSSChannel];
        
        [_defaulChannelSet addNewReservedChannel:lentaRuRSSChannel];
        [_defaulChannelSet addNewReservedChannel:cnewsRSSChannel];
        [_defaulChannelSet addNewReservedChannel:hiTechRSSChannel];
        [_defaulChannelSet addNewReservedChannel:habrahabrRSSChannel];
        
    });
    return _defaulChannelSet;
}

/// Инициализация набором каналов
- (instancetype)initWithChannels:(NSArray<HURSSChannel*>*)channels{
    
    if(self = [super init]){
        _reservedChannels = channels;
    }
    return self;
}

#pragma mark - ADD Channel

/// Добавить новый канал в предопределенные (с отложенной инициализацией)
- (void)addNewReservedChannel:(HURSSChannel*)newChannel{
    
    if(! _reservedChannels){
        _reservedChannels = [NSArray new];
    }
    _reservedChannels = [_reservedChannels arrayByAddingObject:newChannel];
}


#pragma mark - GET Preserved

/// Геттер для предопределенных каналов
- (NSArray <HURSSChannel*>*)getReservedChannels{
    return _reservedChannels;
}

/**
    @abstract Получить массив названий каналов
    @discussion
    Формирует массив строк для предопределенных каналов. Для каждого экземпляра формирует массив только единожды
    @return Массив названий каналов
 */
- (NSArray <NSString*>*)getReservedChannelsNames{
    
    if(! _reservedChannelNames){
        
        NSMutableArray<NSString*> *channelNames = [NSMutableArray new];
        NSArray <HURSSChannel*> *preservedChannels = [self getReservedChannels];
        for (HURSSChannel *currentChannel in preservedChannels) {
            [channelNames addObject:currentChannel.channelAlias];
        }
        _reservedChannelNames = [NSArray arrayWithArray:channelNames];
    }
    
    return _reservedChannelNames;
}


@end
