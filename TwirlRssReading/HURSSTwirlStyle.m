//
//  HUBaseHelper.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSTwirlStyle.h"

#define HU_RGB_COLOR(redComp,greenComp,blueComp) [UIColor colorWithRed:(redComp/255.f) green:(greenComp/255.f) blue:(blueComp/255.f) alpha:1.f]

@implementation HURSSTwirlStyle

+ (instancetype)sharedStyle{
    
    static HURSSTwirlStyle * sharedStyle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStyle = [HURSSTwirlStyle new];
    });
    return  sharedStyle;
}


- (UIColor*)splashScreenColor{
    return HU_RGB_COLOR(192.f, 194.f, 211.f);
}

- (CGSize)splashLogoSize{
    return CGSizeMake(168.f, 40.f);
}

- (UIImage*)splashLogoImage{
    return [UIImage imageNamed:@"improveDigitalLogo.png"];
}

- (UIColor*)firstUseColor{
    return HU_RGB_COLOR(42.f, 36.f, 107.f);
}

- (UIColor*)secondUseColor{
    return HU_RGB_COLOR(118.f, 189.f, 68.f);
}

- (UIColor*)secondUseLightColor{
    return HU_RGB_COLOR(177.f , 255.f, 102.f);
}

- (UIColor*)selectChannelScreenColor{
    return [[self firstUseColor] colorWithAlphaComponent:0.6f];
}

- (UIColor*)channelTextFieldBackColor{
    return [[self secondUseColor] colorWithAlphaComponent:0.5f];
}
- (UIColor*)channelTextFieldTextColor{
    return [[UIColor brownColor]colorWithAlphaComponent:0.8f];
}
- (UIFont*)channelTextFieldFont{
    return [UIFont boldSystemFontOfSize:18.f];
}
- (CGFloat)channelUIElementHeight{
    return 52.f;
}

- (UIColor*)channelButtonBackColor{
    return [[self secondUseColor] colorWithAlphaComponent:0.75f];
}

- (UIColor*)channelButtonHighlightedBackColor{
    return [[self secondUseColor] colorWithAlphaComponent:0.4f];
}

- (UIColor*)channelButtonTextColor{
    return [[UIColor brownColor] colorWithAlphaComponent:0.6f];
}

- (UIFont*)channelButtonTextFont{
    return [UIFont boldSystemFontOfSize:24.f];
}

@end
