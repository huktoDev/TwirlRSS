//
//  HURSSChannelStore.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HURSSChannel;


#define HU_RSS_NEED_CLEAR_STORED_CHANNELS 1

#define HU_RSS_USE_LOCAL_PREFERENCES 1
#define HU_RSS_USE_FILE_SERIALIZATION 0


@interface HURSSChannelStore : NSObject

+ (instancetype)sharedStore;

- (BOOL)saveNewChannel:(HURSSChannel*)newChannel;
- (BOOL)deleteChannel:(HURSSChannel*)deletingChannel;

- (NSArray <HURSSChannel*>*)loadStoredChannels;
- (NSArray <NSString*>*)loadStoredChannelsName;

- (BOOL)containsChannelWithName:(NSString*)checkChannelName;



@end
