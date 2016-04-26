//
//  HUSelectRSSChannelPresenter.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
    @protocol HURSSChannelSelectRecievedFeedsProtocol
    @author HuktoDev
    @updated 25.04.2016
    @abstract Протокол для получения RSS-новостной информации.
    @discussion
    Этот протокол реализует HUSelectRSSChannelPresenter для передачи данных следующему экрану, для отображения
 */
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
 
    @note Используется ряд методик защитного программирования (в частности - блокирование промежуточных состояний, и отключение мультитача)
    Блокировки выполняются в следующих местах :
    <ul>
        <li> Когда пользователь нажимает "Смотреть" - ему ненадолго дизейблится интерфейс, пока не отобразится список  канало  (0.6 секунд) </li>
        <li> Когда пользователь нажимает "Добавить/Изменить"  - 0.6 секунд (пока покажется алерт) </li>
        <li> Когда пользователь нажимает "Удалить"  - 0.6 секунд (пока покажется алерт) </li>
        <li> Когда пользователь нажимает "Получить" - дизейблится до того, пока индикатор ожидания не уберется </li>
        <li> Когда пользователь нажимает "Смотреть сохраненные ранее" - дизейблится до того, пока индикатор ожидания не уберется (до старта перехода) </li>
        <li> Когда изменяется текст (и может изменится состояние) - блочит интерфейс на время анимирования (1 сек) </li>
    </ul>
    Для всех UI элементов интерфейса выполняется отключение мультитача (как и для вновь созданных кнопок и текстовых полей)
 
 
    @see
    HURSSChannelSelectionDelegate \n
    MWFeedParserDelegate \n
    HUSelectRSSChannelView \n
 */
@interface HUSelectRSSChannelPresenter : UIViewController <HURSSChannelSelectionDelegate, MWFeedParserDelegate, HURSSChannelSelectRecievedFeedsProtocol, HURSSFeedsRecieverDelegate, HURSSChannelTextChangedDelegate>

/// Корневая вьюшка экрана
@property (strong, nonatomic) HUSelectRSSChannelView *selectChannelView;



@end



