//
//  HURSSFeedsReciever.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 24.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedsReciever.h"
#import "HURSSFeedsCache.h"

#import "NSAttributedString+ResizeAttachments.h"

@implementation HURSSFeedsReciever{
    
    // Канал новостей, получаемых в текущий момент
    HURSSChannel *_recievingFeedsChannel;
    
    // Полученные новости
    MWFeedInfo *_recievedHeaderFeedInfo;
    NSMutableArray <MWFeedItem*> *_recievedFeedsItems;
    
    // Используемые сервисы
    MWFeedParser *_innerFeedParser;
    HURSSFeedsCache *_feedsCache;
}

@synthesize feedsDelegate=_feedsDelegate;


#pragma mark - Constructor 

+ (instancetype)sharedReciever{
    
    static HURSSFeedsReciever *_sharedReciever;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedReciever = [HURSSFeedsReciever new];
    });
    return _sharedReciever;
}

- (instancetype)init{
    if(self = [super init]){
        [self injectDependencies];
    }
    return self;
}


#pragma mark - Dependencies

/// Инжектировать зависимости
- (void)injectDependencies{
    
    _feedsCache = [HURSSFeedsCache sharedCache];
}

#pragma mark - HURSSFeedsRemoteRecievingProtocol (LOAD FROM NETWORK)

/**
    @abstract Загрузить новости для канала из сети
    @discussion
    Основной метод удаленный загрузки новостей. Запускает асинхронную загрузку и парсинг новостей. 
    Результат парсинга возвратит делегату одним из методов Success/Failure
 
    @param feedsChannel      Канал, для которого следует получить новости
 */
- (void)loadFeedsForChannel:(HURSSChannel*)feedsChannel{
    
    // Запомнить текущий канал
    _recievingFeedsChannel = feedsChannel;
    
    // Создать RSS-ресивер и парсер
    NSURL *feedsURL = feedsChannel.channelURL;
    _innerFeedParser = [[MWFeedParser alloc] initWithFeedURL:feedsURL];
    
    // Получить результаты парсинга
    _innerFeedParser.delegate = self;
    
    //TODO: Mute Warning (не знаю, что за фигня с этим, так и не обнаружил причины)
    // Выполнить асинхронный запрос и парсинг
    [_innerFeedParser setConnectionType:ConnectionTypeAsynchronously];
    
    // Запустить парсинг
    [_innerFeedParser parse];
}


/// Отменет загрузку новостей
- (void)cancelLoading{
    
    // TODO: Не прерывает пост-обработку, по-хорошему надо прерывать!
    [_innerFeedParser stopParsing];
}


#pragma mark - MWFeedParserDelegate IMP

/// Данные из сети получены, стартует парсинг
- (void)feedParserDidStart:(MWFeedParser *)parser{
    
    _recievedFeedsItems = [NSMutableArray new];
}

/// Удалось распарсить объект MWFeedInfo (метаданные новостного канала)
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    
    _recievedHeaderFeedInfo = info;
}

/// Удалось распарсить новая  новость MWFeedItem (добавить в структуру данных)
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    
    [_recievedFeedsItems addObject:item];
}

/**
    @abstract Парсинг новостей окончен успешно
    @discussion
    По основному пути обработки :
    - Конвертирует полученные модели в подходящие
    - Подготавливает контент моделей. (в частности - HTML)
    - Передает результат делегату
 
    @note Если используется симуляция HU_RSS_NEED_FEEDS_FAIL == 1 - всегда перескакивает в Failure
 
    @param parser       Объект парсера (который выполнял задачу)
 */
- (void)feedParserDidFinish:(MWFeedParser *)parser{
    
    // Если требуется симуляция (чтобы протестить Failure - нужно всегда возвращать ошибку)
#if HU_RSS_NEED_FEEDS_FAIL == 1

    // Выбрать рандомный тип ошибки (код), и приндительно запустить Failure-метод
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
    
    // Если симуляция не нужна!
    // Если делегат имеется, и реализует метод удачного возврата информации из ресивера
    if(self.feedsDelegate && [self.feedsDelegate conformsToProtocol:@protocol(HURSSFeedsRecieverDelegate)] && [self.feedsDelegate respondsToSelector:@selector(didSuccessRecievedFeeds:withFeedInfo:forChannel:)]){
        
        // Конвертирует MW-модели в HURSS-модели (модели-врапперы)
        NSMutableArray <HURSSFeedItem*> *convertedBufferFeeds = [NSMutableArray new];
        for (MWFeedItem *currentItem in _recievedFeedsItems) {
            
            HURSSFeedItem *convertedItem = [HURSSFeedItem feedItemConvertedFrom:currentItem];
            [convertedBufferFeeds addObject:convertedItem];
        }
        NSArray <HURSSFeedItem*> *convertedFeeds = [NSArray arrayWithArray:convertedBufferFeeds];
        HURSSFeedInfo *convertedFeedInfo = [HURSSFeedInfo feedInfoConvertedFrom:_recievedHeaderFeedInfo];
        
        // Для каждой модели - подготавливает контент
        [self prepareHTMLContentForFeeds:convertedFeeds forFeedInfo:convertedFeedInfo forChannel:_recievingFeedsChannel WithCompletion:^(NSArray<HURSSFeedItem *> *preparedFeeds, HURSSFeedInfo *preparedFeedInfo, HURSSChannel *usedRSSChannel) {
            
            // Сохранить полученную информацию в кэш (базу данных) (для возможности оффлайн-просмотра)
            [_feedsCache setCachedFeeds:preparedFeeds withFeedInfo:preparedFeedInfo forChannel:_recievingFeedsChannel];
            
            // Передает подготовленные модели делегату
            [self.feedsDelegate didSuccessRecievedFeeds:preparedFeeds withFeedInfo:preparedFeedInfo forChannel:usedRSSChannel];
        }];
    }
    
#endif
}


/**
    @abstract Когда не удалось получить новости, или распарсить
    @discussion
    Получает объект ошибки, и в зависимости от кода ошибки - формирует соответствующее описание на требуемом языке, и передает результат делегату сервиса
 
    @param parser     Объект парсера (который выполнял задачу)
    @param error       Экземпляр ошибки, который возник в парсере, либо передан    симулированно
 */
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    
    // Получить описание ошибки
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
    
    // Передает делегату неудачу
    if(self.feedsDelegate && [self.feedsDelegate conformsToProtocol:@protocol(HURSSFeedsRecieverDelegate)] && [self.feedsDelegate respondsToSelector:@selector(didFailureRecievingFeedsWithErrorDescription:forChannel:)]){
        
        [self.feedsDelegate didFailureRecievingFeedsWithErrorDescription:feedsErrorDescription forChannel:_recievingFeedsChannel];
    }
}


#pragma mark - PostProcessing

/**
    @abstract Подготавливает контент моделей к отображению
    @discussion
    Запускает подготовку новостей HURSSFeedItem (дело в том, что при наличии контента - имелись проблемы с тормозами при наличии аттачментов (картинки либо очень долго рендерились (большие), либо долго ресайзились), и было решено подготавливать контент зараннее, чтобы достичь наилучшего быстродействия в таблице).
 
    <h4> Выполняет следующие задачи : </h4>
    <ol type="a">
        <li> Находит все картинки неподходящего размера и уменьшает их </li>
        <li> Рассчитывает и запоминает высоту контента (и формирует NSAttributedString) </li>
        <li> Рассчитывает и запоминает высоту тайтла </li>
        <li> Из объекта даты создания - формирует форматированную строку даты  </li>
    </ol>
 
    @note Использует группу диспетчеризации, чтобы поймать общий колбэк (асинхронный семафор)
    @note Выполняет все расчеты асинхронно, в параллельной очереди
 
    @param rawFeeds        Сырой массив моделей новостей, который следует обработать
    @param rawFeedInfo       Сырой объект метаданных новостного канала
    @param usedChannel       Канал, из которого были извлечены обрабатываемые новости
 
    @param preparationCompletion      Коллбэк окончания подготовки контента (передает готовые объекты)
 */
- (void)prepareHTMLContentForFeeds:(NSArray<HURSSFeedItem*>*)rawFeeds forFeedInfo:(HURSSFeedInfo*)rawFeedInfo forChannel:(HURSSChannel*)usedChannel WithCompletion:(void(^)(NSArray<HURSSFeedItem*>*, HURSSFeedInfo*, HURSSChannel*))preparationCompletion{
    
    dispatch_group_t parsingDispatchGroup = dispatch_group_create();
    dispatch_group_enter(parsingDispatchGroup);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (HURSSFeedItem *currentItem in rawFeeds) {
            
            // Запустить у каждой 
            dispatch_group_enter(parsingDispatchGroup);
            
            [self prepareHTMLWithContentWidth:240.f ForItem:currentItem WithCompletion:^(NSAttributedString *recievedString, CGFloat heightContent) {
                
                dispatch_group_leave(parsingDispatchGroup);
            }];
        }
        dispatch_group_leave(parsingDispatchGroup);
    });
    
    // Создать коллбэк окончания операций
    dispatch_group_notify(parsingDispatchGroup, dispatch_get_main_queue(), ^{
        
        if(preparationCompletion){
            preparationCompletion(rawFeeds, rawFeedInfo, usedChannel);
        }
    });
}

/**
    @abstract Подготовить контент новости к отображению в ячейке
    @discussion
    Выполняет, собственно, 4 задачи :
    <ol type="a">
        <li> Формирование аттрибутированной строки (чтобы даже  HTML-разметку воспринимало) </li>
        <li> Ресайзит все вложенные изображения (перерисовывая) </li>
        <li> Вычисляется высота контента </li>
        <li> Вычисляется высота тайтла </li>
        <li> Создается форматированная строка даты </li>
    </ol>
 
    @warning При таком подходе ресайза изображений (без создания новых экземпляров аттачментов) - при загрузке из базы данных NSAttributedString вновь применяет старые версии аттачментов (требется вновь ресайзить)
 
    @param summaryContentWidth      Ширина контента (от нее зависит сильно вычисленные размеры контента, и ресайз изображений)
    @param rawFeeditem         экземпляр HURSSFeedItem, который будет обрабатываться
    @param completionBlock      Блок окончания обработки (передает готовую информацию)
 */
- (void)prepareHTMLWithContentWidth:(const CGFloat)summaryContentWidth ForItem:(HURSSFeedItem*)rawFeeditem WithCompletion:(HURSSFeedItemBlock)completionBlock{
    
    if(rawFeeditem.attributedSummary){
        completionBlock(rawFeeditem.attributedSummary, rawFeeditem.summaryContentHeight);
        return;
    }
    
    // Формирует аттрибутированную строку (сначала в данные превращает, а потом подсовывает NSAttributedString, как HTML-документ)
    NSData *summaryData = [rawFeeditem.summary dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *attribStringOptions = @{
        NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)};
    
    NSError *feedAttribStringError = nil;
    NSAttributedString *feedAttribString =[[NSAttributedString alloc] initWithData:summaryData options:attribStringOptions documentAttributes:nil error:&feedAttribStringError];
    
    
    // Перечисляет все NSTextAttachment (аттрибуты с NSAttachmentAttributeName) (картинки), и каждую картинку ресайзит
    [feedAttribString resizeAllAttachmentImagesWithMaxWidth:summaryContentWidth];
    
    // Вычисляется высота контента для summary
    NSStringDrawingOptions drawingOptions = (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGRect feedSummaryStringRect = [feedAttribString boundingRectWithSize:CGSizeMake(summaryContentWidth, 10000.f) options:drawingOptions context:nil];
    CGFloat feedSummaryStringHeight = feedSummaryStringRect.size.height;
    
    // Вычисляется высота тайтла
    CGRect feedTitleStringRect = [rawFeeditem.title boundingRectWithSize:CGSizeMake(summaryContentWidth, 10000.f) options:drawingOptions attributes:@{NSFontAttributeName : [[HURSSTwirlStyle sharedStyle] channelTextFieldFont]} context:nil];
    CGFloat feedTitleStringHeight = feedTitleStringRect.size.height;
    
    // Форматирует строку даты создания
    NSDateFormatter *feedDateFormatter = [NSDateFormatter new];
    [feedDateFormatter setDateFormat:@"dd MMMM yyyy, hh:mm a"];
    NSString *formattedFeedDate = [feedDateFormatter stringFromDate:rawFeeditem.date];
    
    // Устанавливает вычисленные параметры
    rawFeeditem.attributedSummary = feedAttribString;
    rawFeeditem.summaryContentHeight = feedSummaryStringHeight;
    rawFeeditem.titleContentHeight = feedTitleStringHeight;
    rawFeeditem.formattedCreationDate = formattedFeedDate;
    
    // Оповещает об окончании
    if(completionBlock){
        completionBlock(feedAttribString, feedSummaryStringHeight);
    }
}


#pragma mark - HURSSFeedsLocalRecievingProtocol (LOAD FROM CACHE DB)

/// Проверяет, имеется ли закэшированные новости для данного канала в кэше (или в базе данных)
- (BOOL)haveCachedFeedsForChannel:(HURSSChannel*)feedsChannel{
    
    return [_feedsCache haveCachedFeedsForChannel:feedsChannel];
}

/// Получает закэшированные  новости для канала (либо хранящиеся в базе данных)
- (void)getCachedFeedsForChannel:(HURSSChannel*)feedsChannel withCallback:(HURSSFeedsCacheRecievingBlock)cachedInfoCallback{
    
    [_feedsCache getCachedFeedsForChannel:feedsChannel withCallback:cachedInfoCallback];
}

/// По идее, должен отменять загрузку новостей из базы данных
- (void)cancelCachedFeedsRecieving{
    [_feedsCache cancelCachedFeedsRecieving];
}



@end
