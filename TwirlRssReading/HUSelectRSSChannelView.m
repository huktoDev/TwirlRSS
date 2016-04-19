//
//  HUSelectRSSChannelView.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSelectRSSChannelView.h"

#import "HURSSTwirlStyle.h"
#import "Masonry.h"


@implementation HUSelectRSSChannelView{
    
    id<HURSSStyleProtocol> _presentStyle;
}

- (instancetype)init{
    if(self = [super init]){
        
        _presentStyle = [HURSSTwirlStyle sharedStyle];
        
        UIColor *selectChannelBackColor = [_presentStyle selectChannelScreenColor];
        [self setBackgroundColor:selectChannelBackColor];
    }
    return self;
}

+ (instancetype)createChannelView{
    
    HUSelectRSSChannelView *channelView = [HUSelectRSSChannelView new];
    return channelView;
}


#pragma mark - Config UI Elements

/// Конфигурирует верхний лейбл ("введите URL")
- (void)configEnterChannelLabel{
    
    UILabel *enterChannelLabel = [UILabel new];
    enterChannelLabel.numberOfLines = 2;
    enterChannelLabel.font = [UIFont systemFontOfSize:24.f];
    enterChannelLabel.text = @"Введите URL вашего\nканала :";
    enterChannelLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:enterChannelLabel];
    
    [enterChannelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.leading.equalTo(self.mas_leading).with.offset(20.f);
        make.top.equalTo(self.mas_top).with.offset(60.f);
        make.height.mas_equalTo(60.f);
        
    }];
    
    self.enterChannelLabel = enterChannelLabel;
}

/// Конфигурирует текст филд для ввода  канала
- (void)configChannelTextField{
    
    const CGFloat textFieldSize = [_presentStyle channelUIElementHeight];
    
    HURSSChannelTextField *channelTextField = [HURSSChannelTextField new];
    
    // Плейсхолдер текста
    channelTextField.placeholder = @"http://";
    
    [self addSubview:channelTextField];
    
    [channelTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.enterChannelLabel.mas_bottom).with.offset(20.f);
        make.width.equalTo(self.enterChannelLabel.mas_width);
        make.height.mas_equalTo(textFieldSize);
    }];
    
    self.channelTextField = channelTextField;
}

/// Конфигурирует лейбл "Выберите из предложенных"
- (void)configSelectSuggestedLabel{
    
    UILabel *selectSuggestedLabel = [UILabel new];
    selectSuggestedLabel.numberOfLines = 3;
    selectSuggestedLabel.font = [UIFont systemFontOfSize:24.f];
    selectSuggestedLabel.text = @"или\nвыберите из\nпредложенных :";
    selectSuggestedLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:selectSuggestedLabel];
    
    [selectSuggestedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self.enterChannelLabel.mas_width);
        make.top.equalTo(self.channelTextField.mas_bottom).with.offset(20.f);
        make.height.mas_equalTo(90.f);
    }];
    
    self.selectSuggestedLabel = selectSuggestedLabel;
}

/// Конфигурирует кнопку "СМОТРЕТЬ" (выбор  предпочитаемых каналов)
- (void)configShowChannelButton{
    
    const CGFloat channelButtonSize = [_presentStyle channelUIElementHeight];
    
    HURSSChannelButton *showChannelButton = [HURSSChannelButton new];
    [showChannelButton setTitle:@"СМОТРЕТЬ" forState:UIControlStateNormal];
    
    [self addSubview:showChannelButton];
    
    [showChannelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.selectSuggestedLabel.mas_bottom).with.offset(20.f);
        make.width.equalTo(self.channelTextField.mas_width);
        make.height.mas_equalTo(channelButtonSize);
    }];
    
    self.showChannelButton = showChannelButton;
}

/// Конфигурирует кнопку "ПОЛУЧИТЬ" (получить новости выбранного канала)
- (void)configGetFeedsButton{
    
    const CGFloat feedsButtonSize = [_presentStyle channelUIElementHeight];
    
    HURSSChannelButton *feedsButton = [HURSSChannelButton new];
    [feedsButton setTitle:@"ПОЛУЧИТЬ" forState:UIControlStateNormal];
    
    [self addSubview:feedsButton];
    
    [feedsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20.f);
        make.width.equalTo(self.showChannelButton.mas_width);
        make.height.mas_equalTo(feedsButtonSize);
    }];
    
    self.feedsButton = feedsButton;
}


@end

