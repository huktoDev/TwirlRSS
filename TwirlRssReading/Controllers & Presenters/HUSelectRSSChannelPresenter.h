//
//  HUSelectRSSChannelPresenter.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HURSSFeedsReciever.h"

@class HUSelectRSSChannelView;
@class HURSSChannelTextField, HURSSChannelButton;


@protocol HURSSChannelSelectRecievedFeedsProtocol <NSObject>

- (NSArray<HURSSFeedItem*>*)getRecievedFeeds;
- (HURSSFeedInfo*)getFeedInfo;

@end


/**
    @class HUSelectRSSChannelPresenter
    @author HuktoDev
    @updated 23.04.2016
    @abstract Презентер для SelectChannel-экрана (модуль VIPER)
    @discussion
    Содежит всю управляющую бизнес-логику экрана. Инициирует задачи сервисам, и обрабатывает соответствующие события вьюшки
 
    <hr>
    <h4> Используемые сервисы : </h4>
    <ol type="1">
        <li> MWFeedParser - сервис загрузки и парсинга RSS-новостей </li>
        <li> HURSSChannelStore - сервис хранилища каналов </li>
    </ol>
 
    <hr>
    <h4> Экран выполняет задачи : </h4>
    <ol type="a">
        <li> Просмотр новостей для канала с введенным URL-ом (кнопка "ПОЛУЧИТЬ") </li>
        <li> Просмотр каналов и выбор канала из загруженного списка каналов (кнопка "СМОТРЕТЬ") </li>
        <li>  Добавление или изменение имеющегося канала (кнопка "ДОБАВИТЬ/ИЗМЕНИТЬ") </li>
        <li> Удаление имеющегося канала (кнопка "УДАЛИТЬ") </li>
        <li> Диалог, предлагающий пользователю получить новости в выбранном экране </li>
        <li> Получение новостей, индикация прогресса получения, и алерты в случае неудачи </li>
    </ol>
    <hr>
 
    @note Вьюшка имеет динамично меняющийся интерфейс (в зависимости от действий пользователя)
 
    @note  Вьюшка осуществляет только 1 переход - к Feeds-экрану с помощью роутера  
 
    @note Вьюшка HUSelectRSSChannelView являет собой не цельный класс вьюшку. Это скорее вью-пакет (содежит в себе 6 разных модулей). Кроме этого, текст-филд и баттон экрана имеют собственные подклассы
 
    @see
    HURSSChannelSelectionDelegate \n
    MWFeedParserDelegate \n
    HUSelectRSSChannelView \n
 */
@interface HUSelectRSSChannelPresenter : UIViewController <HURSSChannelSelectionDelegate, MWFeedParserDelegate, HURSSChannelSelectRecievedFeedsProtocol, HURSSFeedsRecieverDelegate, HURSSChannelTextChangedDelegate>

/// Корневая вьюшка экрана
@property (strong, nonatomic) HUSelectRSSChannelView *selectChannelView;



@end



