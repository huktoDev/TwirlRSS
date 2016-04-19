//
//  HURSSChannelStore.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelStore.h"
#import "HURSSChannel.h"

@implementation HURSSChannelStore

+ (instancetype)sharedStore{
    
    static HURSSChannelStore *_sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [HURSSChannelStore new];
    });
    return _sharedStore;
}

// Сущность HURSSPreservedChannelSet

+ (NSArray <HURSSChannel*>*)getPreservedChannels{
    
    static NSArray <HURSSChannel*> *preservedChannels = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *lentaRuRSSUrl = [NSURL URLWithString:@"http://lenta.ru/rss"];
        HURSSChannel *lentaRuRSSChannel = [HURSSChannel channelWithAlias:@"Lenta.ru" withURL:lentaRuRSSUrl withType:HURSSChannelReserved];
        
        NSURL *cnewsRSSUrl = [NSURL URLWithString:@"http://static.feed.rbc.ru/rbc/internal/rss.rbc.ru/cnews.ru/mainnews.rss"];
        HURSSChannel *cnewsRSSChannel = [HURSSChannel channelWithAlias:@"CNews" withURL:cnewsRSSUrl withType:HURSSChannelReserved];
        
        NSURL *hiTechRSSUrl = [NSURL URLWithString:@"http://news.yandex.ru/computers.rss"];
        HURSSChannel *hiTechRSSChannel = [HURSSChannel channelWithAlias:@"Hi-Tech от Yandex" withURL:hiTechRSSUrl withType:HURSSChannelReserved];
        
        NSURL *habrahabrRSSUrl = [NSURL URLWithString:@"https://habrahabr.ru/rss/hub/mobile_dev/"];
        HURSSChannel *habrahabrRSSChannel = [HURSSChannel channelWithAlias:@"Habrahabr Mobile Dev" withURL:habrahabrRSSUrl withType:HURSSChannelReserved];
        
        
        preservedChannels = @[lentaRuRSSChannel,
                              cnewsRSSChannel,
                              hiTechRSSChannel,
                              habrahabrRSSChannel];
    });
    
    return preservedChannels;
}

+ (NSArray <NSString*>*)getPreservedChannelsNames{
    
    NSMutableArray<NSString*> *channelNames = [NSMutableArray new];
    NSArray <HURSSChannel*> *preservedChannels = [[self class] getPreservedChannels];
    for (HURSSChannel *currentChannel in preservedChannels) {
        [channelNames addObject:currentChannel.channelAlias];
    }
    return [NSArray arrayWithArray:channelNames];
}

- (BOOL)saveNewChannel:(HURSSChannel*)newChannel{
    
    return NO;
}

- (NSArray <HURSSChannel*>*)loadStoredChannels{
    
    return nil;
}

@end
