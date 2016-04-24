//
//  HURSSChannelViewStyler.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol HURSSChannelViewStylizationInterface <NSObject>

- (UIColor*)firstUseColor;
- (UIColor*)secondUseColor;
- (UIColor*)secondUseLightColor;

- (UIColor*)selectChannelScreenColor;

- (UIColor*)channelTextFieldBackColor;
- (UIColor*)channelTextFieldTextColor;
- (UIFont*)channelTextFieldFont;
- (CGFloat)channelUIElementHeight;

- (UIColor*)channelButtonBackColor;
- (UIColor*)channelButtonHighlightedBackColor;
- (UIColor*)channelButtonTextColor;
- (UIFont*)channelButtonTextFont;

@end


@interface HURSSChannelViewStyler : NSObject <HURSSChannelViewStylizationInterface>

@end
