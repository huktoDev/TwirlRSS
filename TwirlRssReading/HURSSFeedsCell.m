//
//  HURSSFeedsCell.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedsCell.h"

@implementation HURSSFeedsCell{
    BOOL _isBaseConfigured;
    
    MASConstraint *_feedsSummaryHeightConstraint;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (void)baseConfigurationIfNeeded{
    
    if(! _isBaseConfigured){
        
        self.backgroundColor = [UIColor clearColor];
        
        
        UIView *backView = [UIView new];
        backView.backgroundColor = [[HURSSTwirlStyle sharedStyle] channelTextFieldBackColor];
        
        UIColor *borderBackViewColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4f];
        CALayer *backViewLayer = backView.layer;
        [backViewLayer setBorderWidth:2.f];
        [backViewLayer setBorderColor:borderBackViewColor.CGColor];
        [backViewLayer setCornerRadius:26.f];
        
        [self.contentView addSubview:backView];
        
        [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).with.offset(20.f);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-20.f);
            make.top.equalTo(self.contentView.mas_top).with.offset(10.f);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10.f);
        }];
        
        UIView *separatorView = [UIView new];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        
        [self.contentView  addSubview:separatorView];
        
        [separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(backView.mas_leading);
            make.trailing.equalTo(backView.mas_trailing);
            make.top.equalTo(backView.mas_top).with.offset(40.f);
            make.height.mas_equalTo(2.f);
        }];
        
        
        UILabel *feedTitleLabel = [UILabel new];
        feedTitleLabel.font = [[HURSSTwirlStyle sharedStyle] channelTextFieldFont];
        feedTitleLabel.textColor = [UIColor darkGrayColor];
        //[feedTitleLabel setFrame:CGRectMake(20.f, 20.f, 200.f, 40.f)];
        
        [backView addSubview:feedTitleLabel];
        self.feedTitleLabel = feedTitleLabel;
        
        [feedTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(backView.mas_width).with.offset(-40.f);
            make.centerX.equalTo(backView.mas_centerX);
            make.height.mas_equalTo(24.f);
            make.top.equalTo(backView.mas_top).with.offset(12.f);
        }];
        
        feedTitleLabel.backgroundColor = [UIColor clearColor];
        

        
        
        
        UILabel *feedDescriptionLabel = [UILabel new];
        //[feedDescriptionLabel setFrame:CGRectMake(20.f, 60.f, 200.f, 120.f)];
        feedDescriptionLabel.backgroundColor = [UIColor clearColor];
        feedDescriptionLabel.numberOfLines = 0;
        
        
        [backView addSubview:feedDescriptionLabel];
        self.feedDescriptionLabel = feedDescriptionLabel;
        
        
        [feedDescriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.feedTitleLabel.mas_width);
            make.top.equalTo(self.feedTitleLabel.mas_bottom);
            make.centerX.equalTo(self.feedTitleLabel.mas_centerX);
            
            MASConstraint *heightConstraint = make.height.mas_equalTo(400.f);
            _feedsSummaryHeightConstraint = heightConstraint;
        }];
        
        
        _isBaseConfigured = YES;
    }
}


- (void)configWithFeedItem:(HURSSFeedItem*)feedItem{
    
    [self baseConfigurationIfNeeded];
    
    [self.feedTitleLabel setText:feedItem.title];
    
    
    [self.feedDescriptionLabel setAttributedText:feedItem.attributedSummary];
    [_feedsSummaryHeightConstraint setOffset:feedItem.summaryContentHeight];
    [self layoutIfNeeded];
    
    
    
    //[self.feedDescriptionLabel setAttributedText:feedAttribString];
    
    //self.backgroundColor = [UIColor grayColor];
    
    //[self.textLabel setText:feedItem.title];
    //[self.detailTextLabel setText:feedItem.summary];
}


@end





