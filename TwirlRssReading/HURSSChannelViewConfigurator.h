//
//  HURSSChannelViewConfigurator.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 21.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HUSelectRSSChannelView.h"
#import "HURSSTwirlStyle.h"

#import "CZPicker.h"
#import "URBNAlert.h"

@protocol HURSSChannelViewConfiguratorInterface <NSObject>

@required
- (UIScrollView*)createContentScrollView;
- (UILabel*)createEnterChannelLabel;
- (HURSSChannelTextField*)createChannelTextField;
- (UILabel*)createSelectSuggestedLabel;
- (HURSSChannelButton*)createShowChannelButton;
- (HURSSChannelButton*)createGetFeedsButton;

- (CZPickerView*)createChannelsPickerView;
- (URBNAlertViewController*)createObtainingFeedsAlertWithChannelName:(NSString*)channelName;

- (HURSSChannelTextField*)createChannelAliasTextField;
- (HURSSChannelButton*)createChannelAddButton;

- (void)configPresentLocationAliasTextField;
- (void)configCreatedLocationAliasTextField;
- (void)configDestroyedLocationAliasTextField;

- (void)configPresentLocationChannelAddButton;
- (void)configCreatedLocationChannelAddButton;
- (void)configDestroyedLocationChannelAddButton;

- (void)configBaseLocationSuggestedLabel;
- (void)configSecondLocationSuggestedLabel;
- (void)configThirdLocationSuggestedLabel;

- (void)configPresentLocationFeedsButton;

@end


@interface HURSSChannelViewConfigurator : NSObject <HURSSChannelViewConfiguratorInterface>

+ (instancetype)createConfiguratorForRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSStyleProtocol>)viewStyler;

- (UIScrollView*)createContentScrollView;
- (UILabel*)createEnterChannelLabel;
- (HURSSChannelTextField*)createChannelTextField;
- (UILabel*)createSelectSuggestedLabel;
- (HURSSChannelButton*)createShowChannelButton;
- (HURSSChannelButton*)createGetFeedsButton;

- (CZPickerView*)createChannelsPickerView;
- (URBNAlertViewController*)createObtainingFeedsAlertWithChannelName:(NSString*)channelName;

- (HURSSChannelTextField*)createChannelAliasTextField;
- (HURSSChannelButton*)createChannelAddButton;


- (void)configPresentLocationAliasTextField;
- (void)configCreatedLocationAliasTextField;
- (void)configDestroyedLocationAliasTextField;
    
- (void)configPresentLocationChannelAddButton;
- (void)configCreatedLocationChannelAddButton;
- (void)configDestroyedLocationChannelAddButton;

- (void)configBaseLocationSuggestedLabel;
- (void)configSecondLocationSuggestedLabel;
- (void)configThirdLocationSuggestedLabel;

- (void)configPresentLocationFeedsButton;


@end

