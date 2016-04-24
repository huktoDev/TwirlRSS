//
//  HURSSFeedsTableView.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HURSSFeedsCell.h"

/**
    @protocol HURSSFeedsSelectionDelegate
    @author HuktoDev
    @updated 24.04.2016
    @abstract Интерфейс делегата для возврата события селекта HURSSFeedsTableView
    @discussion
    Представляет собой удобный интерфейс для возвращения вьюшки информации о выбранной пользователем новости. Каждая вьюшка экрана может по-своему определять, когда именно вызывать этот метод делегата.
    В данном случае - ловит событие UITableViewDelegate, и перенаправляет
 */
@protocol HURSSFeedsSelectionDelegate <NSObject>

- (void)didSelectFeedCell:(HURSSFeedsCell*)feedCell withLinkedFeedItem:(HURSSFeedItem*)feedItem;

@end


/**
    @class HURSSFeedsTableView
    @author HuktoDev
    @updated 24.04.2016
    @abstract Реализация корневой вьюшки Feeds-экрана
    @discussion
    Когда приложение успешно получает новости - оно передаетих Feeds-экрану, и на нем пытается их отобразить с помощью этой вьюшки.
    Вьюшка сама реализует свои протоколы TableView. В случае чего - создавать интерфейсы-адаптеры, перенаправляющие данные презентеру
 
    Корневая вьюшка является подклассом UITableView, так как наилучший способ отображать новости - таблично. 
    Вьюшка использует ячейки HURSSFeedsCell, которые заполняет моделями новостей.
 
    Вьюшка сама знает, как показывать данные сущностей дата-слоя (ей в качестве источника данных передаются сами модельки)
 
    @note Имеется делегат HURSSFeedsSelectionDelegate для возврата события селекта конкретной ячейки (выбора)
 
    @see
    HURSSFeedsSelectionDelegate \n
    HURSSFeedsCell \n
 */
@interface HURSSFeedsTableView : UITableView <UITableViewDataSource, UITableViewDelegate>


#pragma mark - Data Sources
// Переданные данные

@property (strong, nonatomic) HURSSFeedInfo *viewedInfo;
@property (strong, nonatomic) NSArray <HURSSFeedItem*> *viewedFeeds;


#pragma mark - SELECT Feed
// Делегат выбора ячейки

@property (weak, nonatomic) id <HURSSFeedsSelectionDelegate> selectionDelegate;


#pragma mark - CONFIG Method
// Настройка TableView

- (void)configBackgroundView;


@end




