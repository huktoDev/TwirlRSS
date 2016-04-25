//
//  HURSSFeedItem.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 24.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <MWFeedParser/MWFeedParser.h>

/**
    @class HURSSFeedItem
    @author HuktoDev
    @updated 24.04.2016
    @abstract Модель полученной RSS-новости
    @discussion
    Это то, ради чего вся шляпа =)
    Эту хреновину нужно отображать в ячейках
    
    Содержит в себе всю информацию для RSS-новости, в т.ч., информацию, требуемую для быстрого отображения контента новости.
 
    @note Является враппером над моделью MWFeedItem, имеет метод конвертации
    @note Кроме свойств стандартной моделии - имеет 4 дополнительных, специальных свойства для адаптации
 
    <b> Содержит базовые параметры : </b>
    <ul>
        <li> identifier - Идентификатор канала (чаще всего - ссылка на сайт) </li>
        <li> title - Заголовок новости (название) </li>
        <li> link - HTTP-ссылка на новость на сайте </li>
        <li> date - Дата создания новости </li>
        <li> updated - Дата редактирования новости </li>
        <li> summary - Основной новостной контент новости (обычный Plain или HTML-текст) </li>
        <li> content - Более детализированный новостной контент </li>
        <li> author - Автор новости (творец) </li>
        <li> enclosures - Приложение к новости (файл) (по идее) </li>
    </ul>
 
    @note Кроме всего - содержит вспомогательные параметры :
    <ul>
        <li> attributedSummary - Подготовленная аттрибутированная строка контента </li>
        <li> formattedCreationDate - Форматированная  строка даты создания </li>
        <li> titleContentHeight - Высота тайтла </li>
        <li> summaryContentHeight - Высота контента </li>
    </ul>
 */
@interface HURSSFeedItem : MWFeedItem

#pragma mark - SPECIAL Item Properties
// Специальные свойства (вычисляются)

@property (strong, nonatomic) NSAttributedString *attributedSummary;
@property (strong, nonatomic) NSString *formattedCreationDate;

@property (assign, nonatomic) CGFloat titleContentHeight;
@property (assign, nonatomic) CGFloat summaryContentHeight;

#pragma mark - Convertation
+ (instancetype)feedItemConvertedFrom:(MWFeedItem*)feedItem;


@end

