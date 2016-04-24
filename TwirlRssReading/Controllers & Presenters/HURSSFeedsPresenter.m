//
//  HURSSFeedsPresenter.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedsPresenter.h"


@interface HURSSFeedsPresenter () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) HURSSFeedsTableView *feedsTableView;

@end

@implementation HURSSFeedsPresenter

@synthesize feeds = _feeds;
@synthesize feedInfo = _feedInfo;

- (void)loadView{
    
    HURSSFeedsTableView *newFeedsTableView = [HURSSFeedsTableView new];
    
    self.feedsTableView = newFeedsTableView;
    self.view = newFeedsTableView;
    
    [self.feedsTableView configBackgroundView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.feedsTableView setViewedFeeds:_feeds];
    [self.feedsTableView setViewedInfo:_feedInfo];
    
    self.feedsTableView.selectionDelegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)didSelectFeedCell:(HURSSFeedsCell*)feedCell withLinkedFeedItem:(HURSSFeedItem*)feedItem{
    
    NSURL *feedURL = [NSURL URLWithString:feedItem.link];
    
    if([[UIApplication sharedApplication] canOpenURL:feedURL]){
        [[UIApplication sharedApplication] openURL:feedURL];
    }
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *feedsCellIdentifier = @"feedsCell";
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:feedsCellIdentifier forIndexPath:indexPath];
    
    BOOL isFeedCell = [tableCell isKindOfClass:[HURSSFeedsCell class]];
    NSAssert(isFeedCell, @"Cell FeedsTable is not a cell HURSSFeedsCell");
    
    HURSSFeedItem *currentFeedItem = self.feeds[indexPath.row];
    HURSSFeedsCell *feedCell = (HURSSFeedsCell*)tableCell;
    
    [feedCell prepareWithFeedItem:currentFeedItem];
    
    return feedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    HURSSFeedItem *currentFeedItem = _feeds[indexPath.row];
    return currentFeedItem.summaryContentHeight + currentFeedItem.titleContentHeight + 100.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Получить текущую новость
    // извлечь URL
    // открыть в браузере
    
    HURSSFeedItem *currentFeed = _feeds[indexPath.row];
    NSURL *feedURL = [NSURL URLWithString:currentFeed.link];
    
    if([[UIApplication sharedApplication] canOpenURL:feedURL]){
        [[UIApplication sharedApplication] openURL:feedURL];
    }
    
    
}
 */

@end



