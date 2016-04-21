//
//  HURSSChannel.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 19.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSChannel.h"

@implementation HURSSChannel

+ (instancetype)channelWithAlias:(NSString*)channelAlias withURL:(NSURL*)channelURL withType:(HURSSChannelRecievingType)channelType{
    
    HURSSChannel *newChannel = [HURSSChannel new];
    newChannel.channelAlias = channelAlias;
    newChannel.channelURL = channelURL;
    newChannel.channelType = channelType;
    
    return newChannel;
}

+ (BOOL)isValidChannelURL:(NSURL*)candidateUrl{
    
    // Извлечение строки, в которой будет вестись поиск
    NSString *checkingChannelString = candidateUrl.absoluteString;
    
    // Получение регулярного выражения для RSS-канала
    NSRegularExpression *channelRSSRegExp = [[self class] channelRegularExpression];
    
    // Поиск по регулярке
    NSRange checkingStringRange = NSMakeRange(0, checkingChannelString.length);
    NSRange resultSearchRange = [channelRSSRegExp rangeOfFirstMatchInString:checkingChannelString options:0 range:checkingStringRange];
    
    // Проверка на валидность рейнджа, и возврат результата
    BOOL isValidRSSUrl = (resultSearchRange.location == 0);
    return isValidRSSUrl;
}

+ (NSRegularExpression*)channelRegularExpression{
    
    static NSRegularExpression *channelRSSRegExp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // Создание RegExp-объекта
        NSString *channelRegExpString = @"[A-Za-z]{3,6}://.{2,}\\..{2,}";
        NSError *channelRegExpError = nil;
        channelRSSRegExp = [NSRegularExpression regularExpressionWithPattern:channelRegExpString options:0 error:&channelRegExpError];
        
        // Если ошибки создания регулярного выражения для RSS-канала
        if(channelRegExpError){
            
            NSString *regExpErrorDescription = [NSString stringWithFormat:@"INVALID Channel RSS URL Reg Exp : %@", [channelRegExpError localizedDescription]];
            @throw [NSException exceptionWithName:@"channelRegExpException" reason:regExpErrorDescription userInfo:nil];
        }
    });
    return channelRSSRegExp;
}

@end
