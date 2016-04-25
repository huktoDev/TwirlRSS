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


#define HU_RGB_COLOR(redComp,greenComp,blueComp) [UIColor colorWithRed:(redComp/255.f) green:(greenComp/255.f) blue:(blueComp/255.f) alpha:1.f]


#define HU_RSS_FEEDS_TABLE_VIEW_MARGIN 8.f
#define HU_RSS_FEEDS_CELL_CONTENT_MARGIN 8.f


@protocol HURSSStyleProtocol <NSObject>

- (UIColor*)splashScreenColor;
- (CGSize)splashLogoSize;
- (UIImage*)splashLogoImage;

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


@interface HURSSTwirlStyle : NSObject <HURSSStyleProtocol>

+ (instancetype)sharedStyle;

@end
