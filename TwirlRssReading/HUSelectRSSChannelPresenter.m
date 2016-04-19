//
//  HUSelectRSSChannelPresenter.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSelectRSSChannelPresenter.h"
#import "HUSelectRSSChannelView.h"
#import "HURSSChannelTextField.h"
#import "HURSSChannelButton.h"

#import "HURSSTwirlStyle.h"

#import "HURSSChannel.h"
#import "HURSSChannelStore.h"

#import "CZPicker.h"
#import "URBNAlert.h"

//TODO: Исправить ошибки с NSNumber (там transform.scale убрать)

@interface HUSelectRSSChannelPresenter () 

@end

@implementation HUSelectRSSChannelPresenter{
    
    NSArray <HURSSChannel*> *_preservedChannels;
    NSArray <NSString*> *_preservedChannelNames;
}


#pragma mark - UIView LifeCycle

- (void)loadView{
    
    HUSelectRSSChannelView *rootChannelsView = [HUSelectRSSChannelView createChannelView];
    
    self.enterChannelLabel = [rootChannelsView configEnterChannelLabel];
    self.channelTextField = [rootChannelsView configChannelTextField];
    self.selectSuggestedLabel = [rootChannelsView configSelectSuggestedLabel];
    self.showChannelButton = [rootChannelsView configShowChannelButton];
    self.feedsButton = [rootChannelsView configGetFeedsButton];
    
    self.selectChannelView = rootChannelsView;
    self.view = rootChannelsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.selectChannelView setShowChannelHandler:@selector(obtainChannelsButtonPressed:) withTarget:self];
    [self.selectChannelView setGetFeedsHandler:@selector(recieveFeedsButtonPressed:) withTarget:self];
}


#pragma mark - Button Handlers

- (void)obtainChannelsButtonPressed:(UIButton*)channelsButton{
    
    _preservedChannels = [HURSSChannelStore getPreservedChannels];
    _preservedChannelNames = [HURSSChannelStore getPreservedChannelsNames];
    
    [self.selectChannelView showChannelWithNames:_preservedChannelNames withSelectionDelegate:self];
}

- (void)recieveFeedsButtonPressed:(UIButton*)feedsButton{
    printf("");
}


#pragma mark - HURSSChannelSelectionDelegate IMP

- (void)didSelectedChannelWithIndex:(NSUInteger)indexChannel{
    
    HURSSChannel *selectedChannel = _preservedChannels[indexChannel];
    NSURL *selectedChannelURL = selectedChannel.channelURL;
    [self.selectChannelView showChannelURLLink:selectedChannelURL];
    
    NSString *channelName = selectedChannel.channelAlias;
    
    [self.selectChannelView showObtainingFeedsAlertForChannelName:channelName];
    [self.selectChannelView setObtainingFeedsAlertHandler:@selector(recieveFeedsButtonPressed:) withTarget:self];
}





@end


