//
//  HURSSFeedsCell.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HURSSFeedsCell : UITableViewCell


@property (strong, nonatomic) UILabel *feedTitleLabel;
@property (strong, nonatomic) UILabel *feedDescriptionLabel;

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *separatorView;

@property (strong, nonatomic) UILabel *feedAuthorLabel;
@property (strong, nonatomic) UILabel *feedDateLabel;


- (void)prepareWithFeedItem:(HURSSFeedItem*)feedItem;

@end
