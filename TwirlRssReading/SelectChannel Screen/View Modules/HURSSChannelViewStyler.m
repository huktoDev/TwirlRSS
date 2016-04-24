//
//  HURSSChannelViewStyler.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 22.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannelViewStyler.h"

@implementation HURSSChannelViewStyler

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
