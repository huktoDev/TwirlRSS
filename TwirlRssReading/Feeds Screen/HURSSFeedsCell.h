//
//  HURSSFeedsCell.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    @class HURSSFeedsCell
    @author HuktoDev
    @updated 24.04.2016
    @abstract Класс-ячейка таблицы для Feeds-экрана
    @discussion
    Подкласс UITableViewCell для HURSSFeedsTableView. Умеет конфигурировать сабвьюшки и задавать свой внешний вид, Меняет контент в зависимости от полученной модели.
    Содержит в себе информацию конкретной RSS-новости
 
    Содержит в себе следующий контент и сабвьюшки :
    <ol type="a">
        <li> Тайтл (заголовок новости) </li>
        <li> Основной контент (содержание новости) </li>
        <li> Лейбл с никнеймом автора (если есть автор) </li>
        <li> Лейбл с датой записи </li>
        <li> Фоновая вьюшка </li>
        <li> Сепаратор между частями записи </li>
    </ol>
 
    @note Имеет метод, позволяющий получать источник данных (модель новости HURSSFeedItem)
 
    @see 
    HURSSFeedItem \n
    HURSSFeedsTableView \n
 */
@interface HURSSFeedsCell : UITableViewCell

#pragma mark - CELL SubViews
// Сабвьюшки ячейки

@property (strong, nonatomic) UILabel *feedTitleLabel;
@property (strong, nonatomic) UILabel *feedDescriptionLabel;

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *separatorView;

@property (strong, nonatomic) UILabel *feedAuthorLabel;
@property (strong, nonatomic) UILabel *feedDateLabel;


#pragma mark - PREPARE WITH MODEL
// Метод подготовки ячейки

- (void)prepareWithFeedItem:(HURSSFeedItem*)feedItem;



@end


