//
//  HURSSFeedInfo.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 24.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <MWFeedParser/MWFeedParser.h>

/**
    @class HURSSFeedInfo
    @author HuktoDev
    @updated 24.04.2016
    @abstract Модель метаданных новостного RSS-канала
    @discussion
    Сюда помещается информация, содержащаяся в заголовке ответа RSS-канала.
    Содержит всякие параметры :
    <ul>
        <li> title - Заголовок (название канала) </li>
        <li> link - Ссылка на сайт с новостями </li>
        <li> summary - Описание канала </li>
        <li> url - URL RSS-канала  </li>
    </ul>
 
    @note Является зарезервированным враппером над моделью MWFeedInfo, имеет метод конвертации
 */
@interface HURSSFeedInfo : MWFeedInfo

+ (instancetype)feedInfoConvertedFrom:(MWFeedInfo*)feedInfo;

@end
