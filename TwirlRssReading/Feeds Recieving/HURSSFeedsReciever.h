//
//  HURSSFeedsReciever.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 24.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HURSSFeedInfo.h"
#import "HURSSFeedItem.h"
#import "HURSSChannel.h"

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


@protocol HURSSFeedsLocalRecievingProtocol <NSObject>

- (BOOL)haveCachedFeedsForChannel:(HURSSChannel*)feedsChannel;
- (void)getCachedFeedsForChannel:(HURSSChannel*)feedsChannel;
- (void)cancelCachedFeedsRecieving;


@end


@protocol HURSSFeedsRemoteRecievingProtocol <NSObject>

@required

- (void)loadFeedsForChannel:(HURSSChannel*)feedsChannel;
- (void)cancelLoading;

@optional

@property (strong, nonatomic) NSDictionary <NSString*, id> *feedParseProperties;


@end


@protocol HURSSFeedsRecievingProtocol <HURSSFeedsLocalRecievingProtocol, HURSSFeedsRemoteRecievingProtocol>

@property (weak, nonatomic) id <HURSSFeedsRecieverDelegate> feedsDelegate;

@end





@interface HURSSFeedsReciever : NSObject <MWFeedParserDelegate, HURSSFeedsRecievingProtocol>


+ (instancetype)sharedReciever;



- (void)loadFeedsForChannel:(HURSSChannel*)feedsChannel;
- (void)loadAttachments;

- (void)cancelLoading;

@property (strong, nonatomic) NSArray <HURSSFeedItem*> *cachedFeeds;
@property (strong, nonatomic) HURSSFeedInfo *cachedFeedInfo;



@end


