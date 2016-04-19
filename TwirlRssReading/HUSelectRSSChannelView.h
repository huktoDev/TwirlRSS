//
//  HUSelectRSSChannelView.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HURSSChannelTextField.h"
#import "HURSSChannelButton.h"

@interface HUSelectRSSChannelView : UIView

@property (strong, nonatomic) UILabel *enterChannelLabel;
@property (strong, nonatomic) UILabel *selectSuggestedLabel;

@property (strong, nonatomic) HURSSChannelTextField *channelTextField;
@property (strong, nonatomic) HURSSChannelButton *showChannelButton;
@property (strong, nonatomic) HURSSChannelButton *feedsButton;

+ (instancetype)createChannelView;

- (void)configEnterChannelLabel;
- (void)configChannelTextField;
- (void)configSelectSuggestedLabel;
- (void)configShowChannelButton;
- (void)configGetFeedsButton;


@end
