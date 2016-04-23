//
//  HURSSChannelStore.h
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HURSSChannel;

/**
    @protocol HURSSChannelStoreProtocol
    @author HuktoDev
    @updated 23.04.2016
    @abstract Протокол для хранилища каналов
    @discussion
    Интерфейс, который обязан определять каждый экземпляр хранилища. 
    Содежит в себе 3 основых метода (CRUD-интерфейс), причем для добавления и модификации используется только 1 метод
 
    @see
    HURSSChannelStore \n
 */
@protocol HURSSChannelStoreProtocol <NSObject>


@required

#pragma mark - LOAD FROM STORE
// Загрузка из хранилища всех каналов
- (NSArray <HURSSChannel*>*)loadStoredChannels;


#pragma mark - SAVE TO STORE
// Сохранение канала в хранилище
- (BOOL)saveNewChannel:(HURSSChannel*)newChannel;

#pragma mark - DELETE FROM STORE
// Удаление канала из хранилища
- (BOOL)deleteChannel:(HURSSChannel*)deletingChannel;


@optional

#pragma mark - CHECK Exist Channel
// Проверка наличия канала

- (BOOL)containsChannelWithName:(NSString*)checkChannelName;


#pragma mark - CHANNELs Names
- (NSArray <NSString*>*)loadStoredChannelsName;


@end


/**
    @class HURSSChannelStore
    @author HuktoDev
    @updated 23.04.2016
    @abstract Класс, основная реализация хранилища каналов
    @discussion
    Имплементация интерфейса HURSSChannelStoreProtocol.
    Выполняет весь спектр задач по работе с локальным хранилищем каналов.
 
    @note Реализует 2 способа хранения :
    <ol type="a">
        <li> Хранение в локальном хранилище NSUserDefaults
        (HU_RSS_USE_LOCAL_PREFERENCES == 1) </li>
        <li> Хранение в файле в Documents
        (HU_RSS_USE_FILE_SERIALIZATION == 1) </li>
    </ol>
 
    @see
    HURSSChannelStoreProtocol \n
 */
@interface HURSSChannelStore : NSObject <HURSSChannelStoreProtocol>

+ (instancetype)sharedStore;



@end




