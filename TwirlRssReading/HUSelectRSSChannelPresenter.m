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
    [rootChannelsView configurationAllStartedViews];
    
    
    self.selectChannelView = rootChannelsView;
    self.view = rootChannelsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.selectChannelView setShowChannelHandler:@selector(obtainChannelsButtonPressed:) withTarget:self];
    [self.selectChannelView setGetFeedsHandler:@selector(recieveFeedsButtonPressed:) withTarget:self];
    
    [self.selectChannelView updateUIWhenEnteredChannelURLValidate:NO];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(channelTextChangedNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)channelTextChangedNotification:(NSNotification*)channelTextNotification{
    
    HURSSChannelTextField *channelTextField = (HURSSChannelTextField*)channelTextNotification.object;
    HURSSChannelTextFieldType channelFieldType = [self.selectChannelView getChannelTextFieldType:channelTextField];
    
    if(channelFieldType == HURSSChannelEnterURLFieldType){
        
        NSString *channelTextURLString = channelTextField.text;
        NSURL *enteredChannelURL = [NSURL URLWithString:channelTextURLString];
        
        BOOL isValidRSSChannel = enteredChannelURL && [HURSSChannel isValidChannelURL:enteredChannelURL];
        [self.selectChannelView updateUIWhenEnteredChannelURLValidate:isValidRSSChannel];
        
    }else if(channelFieldType == HURSSChannelAliasFieldType){
        
        NSString *channelTextAliasString = channelTextField.text;
        BOOL isNameEnoughLength = channelTextAliasString && (channelTextAliasString.length >= 4);
        [self.selectChannelView updateUIWhenEnteredChannelAliasValidate:isNameEnoughLength];
        
        // updateUI
    }
}

#pragma mark - Button Handlers

- (void)obtainChannelsButtonPressed:(UIButton*)channelsButton{
    
    _preservedChannels = [HURSSChannelStore getPreservedChannels];
    _preservedChannelNames = [HURSSChannelStore getPreservedChannelsNames];
    
    [self.selectChannelView hideKeyboard];
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
    [self.selectChannelView showChannelAlias:selectedChannel.channelAlias];
    
    NSString *channelName = selectedChannel.channelAlias;
    
    [self.selectChannelView showObtainingFeedsAlertForChannelName:channelName];
    [self.selectChannelView setObtainingFeedsAlertHandler:@selector(recieveFeedsButtonPressed:) withTarget:self];
}



@end


