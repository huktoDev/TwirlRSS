//
//  HURSSFeedsTableView.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedsTableView.h"
#import "HURSSFeedsCell.h"

/**
    @constant HU_RSS_IDENTIFIER_FEED_CELL
        Идентификатор для новостной ячейки
 */
NSString* const HU_RSS_IDENTIFIER_FEED_CELL = @"feedsCell";

@implementation HURSSFeedsTableView


#pragma mark - Creation & Configuration

- (instancetype)init{
    if(self = [super init]){
        // При создании - перенаправляет делегат и дата сорс на себя
        self.delegate = self;
        self.dataSource = self;
        
        // Регистрирует новостную ячейку с заданным ID  (чтобы использовать этот класс ячеек для ячейки с данным ID)
        [self registerClass:[HURSSFeedsCell class] forCellReuseIdentifier:HU_RSS_IDENTIFIER_FEED_CELL];
    }
    return self;
}

/// Настроить фон TableView, чтобы не просвечивало
- (void)configBackgroundView{
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [[HURSSTwirlStyle sharedStyle] selectChannelScreenColor];
    self.backgroundView = backgroundView;
    
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDataSource (CREATE Cells)

/// Количество ячеек в таблице
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewedFeeds.count;
}

/// Метод подготовки ячейки
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Создать ячейку
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:HU_RSS_IDENTIFIER_FEED_CELL forIndexPath:indexPath];
    
    // Подходящая ли создалась ячейка?
    BOOL isFeedCell = [tableCell isKindOfClass:[HURSSFeedsCell class]];
    NSAssert(isFeedCell, @"Cell FeedsTable is not a cell HURSSFeedsCell");
    
    // Получить текущий канал и ячейку
    HURSSFeedItem *currentFeedItem = self.viewedFeeds[indexPath.row];
    HURSSFeedsCell *feedCell = (HURSSFeedsCell*)tableCell;
    
    // Связать новость с ячейкой
    [feedCell prepareWithFeedItem:currentFeedItem];
    
    return feedCell;
}


#pragma mark - UITableViewDelegate (CONTENT SIZE)

/// Метод вычисления высоты ячейки
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HURSSFeedItem *currentFeedItem = self.viewedFeeds[indexPath.row];
    return currentFeedItem.summaryContentHeight + currentFeedItem.titleContentHeight + 100.f;
}


#pragma mark - UITableViewDelegate (SELECTION)

/// Метод UITableViewDelegate, вызывается, когда пользователь делает TouchOutInside от ячейки (ячейка селектится)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Получить текущую ячейку и связанную с ней новость
    HURSSFeedItem *currentFeed = self.viewedFeeds[indexPath.row];
    HURSSFeedsCell *currentFeedCell = (HURSSFeedsCell*)[self cellForRowAtIndexPath:indexPath];
    
    // Если имеется делегат - передать ему информацию
    if(self.selectionDelegate && [self.selectionDelegate conformsToProtocol:@protocol(HURSSFeedsSelectionDelegate)] && [self.selectionDelegate respondsToSelector:@selector(didSelectFeedCell:withLinkedFeedItem:)]){
        
        [self.selectionDelegate didSelectFeedCell:currentFeedCell withLinkedFeedItem:currentFeed];
    }
}


@end
