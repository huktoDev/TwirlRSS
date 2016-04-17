//
//  HUBaseHelper.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol HURSSStyleProtocol <NSObject>

- (UIColor*)splashScreenColor;
- (CGSize)splashLogoSize;
- (UIImage*)splashLogoImage;

@end


@interface HURSSTwirlStyle : NSObject <HURSSStyleProtocol>

+ (instancetype)sharedStyle;

@end
