//
//  HURSSFeedsPresenter.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedsPresenter.h"
#import "HURSSFeedsTableView.h"
#import "HURSSFeedsCell.h"

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
    
    self.feedsTableView.backgroundColor = [[HURSSTwirlStyle sharedStyle] selectChannelScreenColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"RECIEVED %d FEEDS", self.feeds.count);
    
    [self.feedsTableView registerClass:[HURSSFeedsCell class] forCellReuseIdentifier:@"feedsCell"];
    
    
    self.feedsTableView.delegate = self;
    self.feedsTableView.dataSource = self;
    
}

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
    
    [feedCell configWithFeedItem:currentFeedItem];
    
    return feedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    HURSSFeedItem *currentFeedItem = _feeds[indexPath.row];
    return currentFeedItem.summaryContentHeight + 100.f;
}


@end



