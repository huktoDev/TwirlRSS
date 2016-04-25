//
//  HURSSChannel.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
    @enum HURSSChannelRecievingType
    @abstract Тип канала
 
    @constant HURSSChannelReserved
        Канал был зарезервирован программно
    @constant HURSSChannelUserCreated
        Канал был создан пользователем
 */
typedef NS_ENUM(NSUInteger, HURSSChannelRecievingType) {
    HURSSChannelReserved,
    HURSSChannelUserCreated
};

/**
    @class HURSSChannel
    @author HuktoDev
    @updated 23.04.2016
    @abstract Класс-модель для RSS-канала
    @discussion
    Содержит в себе всю требуемую информацию для RSS-канала :
    <ol type="1">
        <li> Псевдоним названия канала </li>
        <li> URL канала </li>
        <li> Тип канала (предопределенный, или созданный пользователем) </li>
    </ol>
 
    @note Реализует интерфейс для сериализации, и копирования объекта
    @note Имеет статический метод для валидации URLа для RSS-канала
 */
@interface HURSSChannel : NSObject <NSCopying, NSCoding>

#pragma mark - CHANNEL Properties
// Свойства RSS-канала
@property (copy, nonatomic) NSString *channelAlias;
@property (copy, nonatomic) NSURL *channelURL;
@property (assign, nonatomic) HURSSChannelRecievingType channelType;


#pragma mark - CHANNEL Constructor
+ (instancetype)channelWithAlias:(NSString*)channelAlias withURL:(NSURL*)channelURL withType:(HURSSChannelRecievingType)channelType;


#pragma mark - CHANNEL Valiadtion
// Валидация URLа канала
+ (BOOL)isValidChannelURL:(NSURL*)candidateUrl;



@end

