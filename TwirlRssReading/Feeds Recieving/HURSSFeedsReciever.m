//
//  HURSSFeedsReciever.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 24.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedsReciever.h"

@implementation HURSSFeedsReciever{
    
    MWFeedParser *_innerFeedParser;
    
    HURSSChannel *_recievingFeedsChannel;
    
    MWFeedInfo *_recievedHeaderFeedInfo;
    NSMutableArray <MWFeedItem*> *_recievedFeedsItems;
}

@synthesize feedsDelegate=_feedsDelegate;

+ (instancetype)sharedReciever{
    
    static HURSSFeedsReciever *_sharedReciever;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedReciever = [HURSSFeedsReciever new];
    });
    return _sharedReciever;
}

- (void)loadFeedsForChannel:(HURSSChannel*)feedsChannel{
    
    _recievingFeedsChannel = feedsChannel;
    
    NSURL *feedsURL = feedsChannel.channelURL;
    _innerFeedParser = [[MWFeedParser alloc] initWithFeedURL:feedsURL];
    _innerFeedParser.delegate = self;
    _innerFeedParser.feedParseType = ParseTypeFull;
    _innerFeedParser.connectionType = ConnectionTypeSynchronously;
    
    // Запустить парсинг
    [_innerFeedParser parse];
}

- (void)cancelLoading{
    
    [_innerFeedParser stopParsing];
}

- (void)feedParserDidStart:(MWFeedParser *)parser{
    
    _recievedFeedsItems = [NSMutableArray new];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    
    _recievedHeaderFeedInfo = info;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    
    [_recievedFeedsItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser{
    
#if HU_RSS_NEED_FEEDS_FAIL == 1
    
    NSUInteger errorCode = 0;
    int randNumb = arc4random() % 2;
    if(randNumb == 0){
        errorCode = MWErrorCodeConnectionFailed;
    }else{
        errorCode = MWErrorCodeFeedParsingError;
    }
    NSError *testError = [NSError errorWithDomain:@"testDomain" code:errorCode userInfo:nil];
    [self feedParser:parser didFailWithError:testError];
    return;
#else
    
    if(self.feedsDelegate && [self.feedsDelegate conformsToProtocol:@protocol(HURSSFeedsRecieverDelegate)] && [self.feedsDelegate respondsToSelector:@selector(didSuccessRecievedFeeds:withFeedInfo:forChannel:)]){
        
        NSMutableArray <HURSSFeedItem*> *convertedBufferFeeds = [NSMutableArray new];
        for (MWFeedItem *currentItem in _recievedFeedsItems) {
            
            HURSSFeedItem *convertedItem = [HURSSFeedItem feedItemConvertedFrom:currentItem];
            [convertedBufferFeeds addObject:convertedItem];
        }
        NSArray <HURSSFeedItem*> *convertedFeeds = [NSArray arrayWithArray:convertedBufferFeeds];
        HURSSFeedInfo *convertedFeedInfo = [HURSSFeedInfo feedInfoConvertedFrom:_recievedHeaderFeedInfo];
        
        dispatch_group_t parsingDispatchGroup = dispatch_group_create();
        dispatch_group_enter(parsingDispatchGroup);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (HURSSFeedItem *currentItem in convertedFeeds) {
                
                dispatch_group_enter(parsingDispatchGroup);
                [currentItem parseSummaryHTMLWithContentWidth:240.f WithCompletion:^(NSAttributedString *recievedString, CGFloat heightContent) {
                    
                    dispatch_group_leave(parsingDispatchGroup);
                }];
            }
            dispatch_group_leave(parsingDispatchGroup);
        });
        
        dispatch_group_notify(parsingDispatchGroup, dispatch_get_main_queue(), ^{
            
            [self.feedsDelegate didSuccessRecievedFeeds:convertedFeeds withFeedInfo:convertedFeedInfo forChannel:_recievingFeedsChannel];
        });
    }
    
#endif
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    
    NSString *feedsErrorDescription = nil;
    NSUInteger feedsErrorCode = MWErrorCodeConnectionFailed;
    switch (feedsErrorCode) {
        case MWErrorCodeConnectionFailed:
            feedsErrorDescription = @"Соединение с сервером установить не удалось";
            break;
        case MWErrorCodeFeedParsingError:
        case MWErrorCodeFeedValidationError:
            feedsErrorDescription = @"С сервера была присланы неправильно форматированные данные";
            break;
        default:
            feedsErrorDescription = @"Неизвестная ошибка";
            break;
    }
    
    if(self.feedsDelegate && [self.feedsDelegate conformsToProtocol:@protocol(HURSSFeedsRecieverDelegate)] && [self.feedsDelegate respondsToSelector:@selector(didFailureRecievingFeedsWithErrorDescription:forChannel:)]){
        
        [self.feedsDelegate didFailureRecievingFeedsWithErrorDescription:feedsErrorDescription forChannel:_recievingFeedsChannel];
    }
    
}




@end
