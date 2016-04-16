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

@end
