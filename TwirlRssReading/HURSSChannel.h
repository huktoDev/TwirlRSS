//
//  HURSSChannel.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

//TODO: реализовать протоколы NSCoding / NSCopying

typedef NS_ENUM(NSUInteger, HURSSChannelRecievingType) {
    HURSSChannelReserved,
    HURSSChannelUserCreated
};

@interface HURSSChannel : NSObject <NSCopying, NSCoding>

@property (copy, nonatomic) NSString *channelAlias;
@property (copy, nonatomic) NSURL *channelURL;
@property (assign, nonatomic) HURSSChannelRecievingType channelType;


+ (instancetype)channelWithAlias:(NSString*)channelAlias withURL:(NSURL*)channelURL withType:(HURSSChannelRecievingType)channelType;
+ (BOOL)isValidChannelURL:(NSURL*)candidateUrl;

@end
