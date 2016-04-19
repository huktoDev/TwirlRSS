//
//  HURSSChannelStore.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HURSSChannel;

@interface HURSSChannelStore : NSObject

+ (instancetype)sharedStore;

+ (NSArray <HURSSChannel*>*)getPreservedChannels;
+ (NSArray <NSString*>*)getPreservedChannelsNames;

- (BOOL)saveNewChannel:(HURSSChannel*)newChannel;
- (NSArray <HURSSChannel*>*)loadStoredChannels;



@end
