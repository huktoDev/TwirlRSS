//
//  HUBaseHelper.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

//TODO: Разделить на несколько протоколов (базовые стили, стили Splash, стили SelectChannel)

@protocol HURSSStyleProtocol <NSObject>

- (UIColor*)splashScreenColor;
- (CGSize)splashLogoSize;
- (UIImage*)splashLogoImage;

- (UIColor*)firstUseColor;
- (UIColor*)secondUseColor;

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


@interface HURSSTwirlStyle : NSObject <HURSSStyleProtocol>

+ (instancetype)sharedStyle;

@end
