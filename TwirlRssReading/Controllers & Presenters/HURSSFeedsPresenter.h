//
//  HURSSFeedsPresenter.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HURSSFeedsTableView.h"
#import "HURSSFeedsCell.h"

/**
    @protocol HURSSFeedsTransferProtocol
    @author HuktoDev
    @updated 24.04.2016
    @abstract Протокол для получения Feeds-экраном RSS-новостей
    @discussion
    Определяет интерфейс для получения новостей, которые должен  имплементировать каждый презентер/контроллер Feeds-экрана.
 
    Ожидает получение 2х объектов :
    <ol type="a">
        <li> Метаданные о новостях (информация о новостном канале) HURSSFeedInfo </li>
        <li> Массив новостных объектов HURSSFeedItem </li>
    </ol>
    
    @note Главное не забывать синтезировать свойства ;)
 */
@protocol HURSSFeedsTransferProtocol <NSObject>

@required

@property (strong, nonatomic) HURSSFeedInfo *feedInfo;
@property (strong, nonatomic) NSArray <HURSSFeedItem*> *feeds;

@end


/**
    @class HURSSFeedsPresenter
    @author HuktoDev
    @updated 24.04.2016
    @abstract Презентер для Feeds-экрана (модуль VIPER)
    @discussion
    Содежит всю управляющую бизнес-логику экрана. Инициирует задачи сервисам, и обрабатывает соответствующие события вьюшки
 
    <hr>
    <h4> Используемые сервисы : </h4>
    <ol type="1">
        <li> UIApplication - принимает ссылки на обработку (для открытия в браузере) </li>
    </ol>
 
    <hr>
    <h4> Экран выполняет задачи : </h4>
    <ol type="a">
        <li> Отображает полученные новости  RSS-канала </li>
        <li> Когда пользователь нажимает на новость - ему открывает эту новость в браузере </li>
    </ol>
    <hr>
 
    @note  Вьюшка осуществляет только переход назад (к SelectChannel-экрану), и открытие ссылки в браузере (без использования роутера)
 
    @see
    HURSSFeedsTransferProtocol \n
    HURSSFeedsSelectionDelegate \n
    HURSSFeedsTableView \n
 */
@interface HURSSFeedsPresenter : UIViewController <HURSSFeedsTransferProtocol, HURSSFeedsSelectionDelegate>

/// Корневая вьюшка экрана
@property (strong, nonatomic) HURSSFeedsTableView *feedsTableView;

@end

