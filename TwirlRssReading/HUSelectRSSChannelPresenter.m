//
//  HUSelectRSSChannelPresenter.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSelectRSSChannelPresenter.h"
#import "HUSelectRSSChannelView.h"


@interface HUSelectRSSChannelPresenter ()

@end

@implementation HUSelectRSSChannelPresenter

- (void)loadView{
    
    HUSelectRSSChannelView *rootChannelsView = [HUSelectRSSChannelView createChannelView];
    
    [rootChannelsView configEnterChannelLabel];
    [rootChannelsView configChannelTextField];
    [rootChannelsView configSelectSuggestedLabel];
    [rootChannelsView configShowChannelButton];
    [rootChannelsView configGetFeedsButton];
    
    self.view = rootChannelsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    
}


@end
