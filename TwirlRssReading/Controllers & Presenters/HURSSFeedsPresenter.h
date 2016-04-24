//
//  HURSSFeedsPresenter.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HURSSFeedsTransferProtocol <NSObject>

@property (strong, nonatomic) NSArray <HURSSFeedItem*> *feeds;
@property (strong, nonatomic) HURSSFeedInfo *feedInfo;

@end


@interface HURSSFeedsPresenter : UIViewController <HURSSFeedsTransferProtocol>

@end
