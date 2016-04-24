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


