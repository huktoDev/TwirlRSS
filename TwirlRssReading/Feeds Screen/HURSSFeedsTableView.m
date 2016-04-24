//
//  HURSSFeedsTableView.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedsTableView.h"
#import "HURSSFeedsCell.h"

@implementation HURSSFeedsTableView

- (instancetype)init{
    if(self = [super init]){
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[HURSSFeedsCell class] forCellReuseIdentifier:@"feedsCell"];
    }
    return self;
}

- (void)configBackgroundView{
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [[HURSSTwirlStyle sharedStyle] selectChannelScreenColor];
    
    self.backgroundView = backgroundView;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewedFeeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *feedsCellIdentifier = @"feedsCell";
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:feedsCellIdentifier forIndexPath:indexPath];
    
    BOOL isFeedCell = [tableCell isKindOfClass:[HURSSFeedsCell class]];
    NSAssert(isFeedCell, @"Cell FeedsTable is not a cell HURSSFeedsCell");
    
    HURSSFeedItem *currentFeedItem = self.viewedFeeds[indexPath.row];
    HURSSFeedsCell *feedCell = (HURSSFeedsCell*)tableCell;
    
    [feedCell prepareWithFeedItem:currentFeedItem];
    
    return feedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HURSSFeedItem *currentFeedItem = self.viewedFeeds[indexPath.row];
    return currentFeedItem.summaryContentHeight + currentFeedItem.titleContentHeight + 100.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Получить текущую новость
    // извлечь URL
    // открыть в браузере
    HURSSFeedItem *currentFeed = self.viewedFeeds[indexPath.row];
    HURSSFeedsCell *currentFeedCell = (HURSSFeedsCell*)[self cellForRowAtIndexPath:indexPath];
    
    if(self.selectionDelegate && [self.selectionDelegate conformsToProtocol:@protocol(HURSSFeedsSelectionDelegate)] && [self.selectionDelegate respondsToSelector:@selector(didSelectFeedCell:withLinkedFeedItem:)]){
        
        [self.selectionDelegate didSelectFeedCell:currentFeedCell withLinkedFeedItem:currentFeed];
    }
}


@end
