//
//  HURSSChannel.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannel.h"

@implementation HURSSChannel

+ (instancetype)channelWithAlias:(NSString*)channelAlias withURL:(NSURL*)channelURL withType:(HURSSChannelRecievingType)channelType{
    
    HURSSChannel *newChannel = [HURSSChannel new];
    newChannel.channelAlias = channelAlias;
    newChannel.channelURL = channelURL;
    newChannel.channelType = channelType;
    
    return newChannel;
}

@end
