//
//  HURSSChannelViewConfigurator.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 21.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HUSelectRSSChannelView.h"
#import "HURSSChannelViewStyler.h"
#import "HURSSChannelViewConstraintsFactory.h"

#import "CZPicker.h"
#import "URBNAlert.h"

@protocol HURSSChannelViewConfiguratorInterface <NSObject>

@required

- (void)configBackground;

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
- (HURSSChannelButton*)createChannelRemoveButton;

- (void)configPresentLocationAliasTextField;
- (void)configCreatedLocationAliasTextField;
- (void)configDestroyedLocationAliasTextField;

- (void)configPresentLocationChannelAddButton;
- (void)configCreatedLocationChannelAddButton;
- (void)configDestroyedLocationChannelAddButton;

- (void)configPresentLocationChannelRemoveButton;
- (void)configCreatedLocationChannelRemoveButton;
- (void)configDestoyedLocationChannelRemoveButton;

- (void)configBaseLocationSuggestedLabel;
- (void)configSecondLocationSuggestedLabel;
- (void)configThirdLocationSuggestedLabel;
- (void)configFourLocationSuggestedLabel;

- (void)configPresentLocationFeedsButton;

- (void)configGetFeedsDisable;
- (void)configGetFeedsEnable;

- (void)configKeyboardWithInsets:(UIEdgeInsets)contentInset;

- (URBNAlertViewController*)createChannelAlertWithPostAction:(HURSSChannelActionType)channelActionType WithChannelName:(NSString*)channelName andWithURL:(NSURL*)channelURL;
    
@end


@interface HURSSChannelViewConfigurator : NSObject <HURSSChannelViewConfiguratorInterface>

+ (instancetype)createConfiguratorForRootView:(HUSelectRSSChannelView*)channelRootView withStyler:(id<HURSSChannelViewStylizationInterface>)viewStyler withConstraintsFactory:(id<HURSSChannelViewPositionRulesInterface>)viewRules;

- (void)configBackground;

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
- (HURSSChannelButton*)createChannelRemoveButton;


- (void)configPresentLocationAliasTextField;
- (void)configCreatedLocationAliasTextField;
- (void)configDestroyedLocationAliasTextField;
    
- (void)configPresentLocationChannelAddButton;
- (void)configCreatedLocationChannelAddButton;
- (void)configDestroyedLocationChannelAddButton;

- (void)configPresentLocationChannelRemoveButton;
- (void)configCreatedLocationChannelRemoveButton;
- (void)configDestoyedLocationChannelRemoveButton;

- (void)configBaseLocationSuggestedLabel;
- (void)configSecondLocationSuggestedLabel;
- (void)configThirdLocationSuggestedLabel;

- (void)configPresentLocationFeedsButton;

- (void)configGetFeedsDisable;
- (void)configGetFeedsEnable;

- (void)configKeyboardWithInsets:(UIEdgeInsets)contentInset;

- (URBNAlertViewController*)createChannelAlertWithPostAction:(HURSSChannelActionType)channelActionType WithChannelName:(NSString*)channelName andWithURL:(NSURL*)channelURL;

@end

