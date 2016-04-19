//
//  HUSelectRSSChannelPresenter.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUSelectRSSChannelView.h"

@class HUSelectRSSChannelView;
@class HURSSChannelTextField, HURSSChannelButton;

@interface HUSelectRSSChannelPresenter : UIViewController <HURSSChannelSelectionDelegate>

@property (strong, nonatomic) HUSelectRSSChannelView *selectChannelView;

@property (strong, nonatomic) UILabel *enterChannelLabel;
@property (strong, nonatomic) UILabel *selectSuggestedLabel;

@property (strong, nonatomic) HURSSChannelTextField *channelTextField;
@property (strong, nonatomic) HURSSChannelButton *showChannelButton;
@property (strong, nonatomic) HURSSChannelButton *feedsButton;

@end
