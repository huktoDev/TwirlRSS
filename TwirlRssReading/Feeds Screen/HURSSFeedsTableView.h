//
//  HURSSFeedsTableView.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HURSSFeedsCell.h"

@protocol HURSSFeedsSelectionDelegate <NSObject>

- (void)didSelectFeedCell:(HURSSFeedsCell*)feedCell withLinkedFeedItem:(HURSSFeedItem*)feedItem;

@end


@interface HURSSFeedsTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) HURSSFeedInfo *viewedInfo;
@property (strong, nonatomic) NSArray <HURSSFeedItem*> *viewedFeeds;

@property (weak, nonatomic) id <HURSSFeedsSelectionDelegate> selectionDelegate;

- (void)configBackgroundView;

@end
