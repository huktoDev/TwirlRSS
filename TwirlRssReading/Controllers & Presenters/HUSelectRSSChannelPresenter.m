//
//  HUSelectRSSChannelPresenter.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSelectRSSChannelPresenter.h"



@implementation HUSelectRSSChannelPresenter{
    
    BOOL _isFeedsSuccessRecieved;
    
    HURSSFeedInfo *_recievedHeaderFeedInfo;
    NSArray <HURSSFeedItem*> *_recievedFeedsItems;
    
    // Презентер сам хранит каналы, и их названия (используется при выборе канала)
    NSArray <HURSSChannel*> *_reservedChannels;
    NSArray <NSString*> *_reservedChannelNames;
    
    // Канал, для которого сервис пытается выполнить получение новостей
    //HURSSChannel *_recievingFeedsChannel;
    
    // Используемые сервисы
    //MWFeedParser *_feedParser;
    id <HURSSChannelStoreProtocol> _channelStore;
    id <HURSSFeedsRecievingProtocol> _feedsReciever;
}


#pragma mark - UIView LifeCycle

/// Переопределяется метод загрузки вьюшки (здесь выполняется программное создание вьюшки, создание и конфигурирование сабвьюшек)
- (void)loadView{
    
    HUSelectRSSChannelView *rootChannelsView = [HUSelectRSSChannelView createChannelView];
    [rootChannelsView configurationAllStartedViews];
    
    self.selectChannelView = rootChannelsView;
    self.view = rootChannelsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Инжектировать зависимости
    [self injectDependencies];
    
    // Установить обработчики кнопок
    [self.selectChannelView setShowChannelHandler:@selector(obtainChannelsButtonPressed:) withTarget:self];
    [self.selectChannelView setGetFeedsHandler:@selector(recieveFeedsButtonPressed:) withTarget:self];
    [self.selectChannelView setAddChannelHandler:@selector(addChannelButtonPressed:) withTarget:self];
    [self.selectChannelView setDeleteChannelHandler:@selector(deleteChannelButtonPressed:) withTarget:self];
    
    // Обновить базовое состояние интерфейса (ничего не введено)
    [self.selectChannelView updateUIWhenEnteredChannelURLValidate:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(channelTextChangedNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    static BOOL isFirstAppear = YES;
    [self.navigationController setNavigationBarHidden:YES animated:(! isFirstAppear)];
    isFirstAppear = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


#pragma mark - Dependencies

 /// Инжектировать зависимости (хранилище каналов)
- (void)injectDependencies{
    
    _channelStore = [HURSSChannelStore sharedStore];
    _feedsReciever = [HURSSFeedsReciever sharedReciever];
}

- (void)channelTextChangedNotification:(NSNotification*)channelTextNotification{
    
    // Извлечь текстового поля и его тип
    HURSSChannelTextField *channelTextField = (HURSSChannelTextField*)channelTextNotification.object;
    HURSSChannelTextFieldType channelFieldType = [self.selectChannelView getChannelTextFieldType:channelTextField];
    
    if(channelFieldType == HURSSChannelEnterURLFieldType){
        
        // Если изменена информация в текстовом поле URL-а
        NSString *channelTextURLString = channelTextField.text;
        NSURL *enteredChannelURL = [NSURL URLWithString:channelTextURLString];
        
        // Валидировать URL, и обновить состояние интерфейса
        BOOL isValidRSSChannel = enteredChannelURL && [HURSSChannel isValidChannelURL:enteredChannelURL];
        [self.selectChannelView updateUIWhenEnteredChannelURLValidate:isValidRSSChannel];
        
    }else if(channelFieldType == HURSSChannelAliasFieldType){
        
        // Если изменена информация в текстовом поле для названия канала
        // Достаточно ли длинное название канала, и есть ли канал со схожим названием в хранилище
        NSString *channelTextAliasString = channelTextField.text;
        BOOL isNameEnoughLength = channelTextAliasString && (channelTextAliasString.length >= 4);
        BOOL isChannelFounded = [_channelStore containsChannelWithName:channelTextAliasString];
        
        // Вычислить текущее состояние канала
        HURSSChannelState currentChannelState = HURSSChannelStateImpossible;
        if(isNameEnoughLength){
            if(isChannelFounded){
                currentChannelState = HURSSChannelStatePossibleModifyDel;
            }else{
                currentChannelState = HURSSChannelStatePossibleAdd;
            }
        }
        // Обновить UI определенным состоянием
        [self.selectChannelView updateUIWhenChannelChangeState:currentChannelState];
    }
}

#pragma mark - Button Handlers

/**
    @abstract Получить список каналов
    @discussion
    При нажатии на кнопку смотреть - пользователю требуется отобразить диалог со списком каналов.
    Загружается массив каналов, и передается во вьюшку соответствующим образом (и презентер тоже запоминает ссылку на массив)
 
    @note Вьюшке SelectChannel-экрана устанавливается специальный делегат, который возвращает ответ диалога
    @param channelsButton      Кнопка, при нажатии на которую срабатывает этот метод
 */
- (void)obtainChannelsButtonPressed:(UIButton*)channelsButton{
    
    // Загрузить список каналов, и получить массив названий каналов
    _reservedChannels = [_channelStore loadStoredChannels];
    _reservedChannelNames = [_channelStore loadStoredChannelsName];
    
    // Скрыть клавиатуру (чтобы диалог нормально показать)
    [self.selectChannelView hideKeyboard];
    
    // Показать диалог с переданным массивом названий  каналов, и установить делегата, чтобы среагировать на выбранный канал
    [self.selectChannelView showChannelWithNames:_reservedChannelNames withSelectionDelegate:self];
}

/**
    @abstract Сохранить введенный канал (или изменить, если есть)
    @discussion
    Когда пользователь нажимает на  кнопку "сохранить" - требуется получить объект канала, и сохранить его в хранилище.
    
    @note Если удалось сохранить - показывает соответствующий диалог
    @note Перед тем, как показать диалог - скрывает клавиатуру
 
    @param addButton     Кнопка, при нажатии на которую срабатывает этот метод
 */
- (void)addChannelButtonPressed:(UIButton*)addButton{
    
    // Сформировать новый объект канала (по введенным данным)
    NSString *newChannelAlias = [self.selectChannelView getChannelAlias];
    NSURL *newChannelURL = [self.selectChannelView getChannelURLLink];
    HURSSChannelRecievingType channelType = HURSSChannelUserCreated;
    
    HURSSChannel *newChannel = [HURSSChannel channelWithAlias:newChannelAlias withURL:newChannelURL withType:channelType];
    
    // Попытаться сохранить новый канал в хранилище
    BOOL isSuccessSaved = [_channelStore saveNewChannel:newChannel];
    
    // Если удалось удалить - убрать клавиатуру, обновить состояние UI и показать диалог
    if(isSuccessSaved){
        [self.selectChannelView hideKeyboard];
        [self.selectChannelView updateUIWhenChannelChangeState:HURSSChannelStatePossibleModifyDel];
        [self.selectChannelView showAlertPostAction:HURSSChannelActionAdd ForChannelName:newChannel.channelAlias withURL:newChannel.channelURL];
    }
}

/**
    @abstract Удалить введенный канал (только, если есть такой)
    @discussion
    Когда пользователь нажимает на  кнопку "удалить" - требуется получить объект канала, и удалить его из хранилища
    
    @note Если удалось удалить - показывает соответствующий диалог
    @note Перед тем, как показать диалог - скрывает клавиатуру
 
    @param deleteButton     Кнопка, при нажатии на которую срабатывает этот метод
 */
- (void)deleteChannelButtonPressed:(UIButton*)deleteButton{
    
    // Сформировать канал, который над удалить
    NSString *currentChannelAlias = [self.selectChannelView getChannelAlias];
    NSURL *currentChannelURL = [self.selectChannelView getChannelURLLink];
    HURSSChannelRecievingType channelType = HURSSChannelUserCreated;
    
    HURSSChannel *currentChannel = [HURSSChannel channelWithAlias:currentChannelAlias withURL:currentChannelURL withType:channelType];
    
    // Попытаться удалить канал из хранилища
    BOOL isSuccessDeleted = [_channelStore deleteChannel:currentChannel];
    
    // Если удалось удалить - убрать клавиатуру, обновить состояние UI и показать диалог
    if(isSuccessDeleted){
        [self.selectChannelView hideKeyboard];
        [self.selectChannelView updateUIWhenChannelChangeState:HURSSChannelStatePossibleAdd];
        [self.selectChannelView showAlertPostAction:HURSSChannelActionDelete ForChannelName:currentChannel.channelAlias withURL:currentChannel.channelURL];
    }
}

- (void)recieveFeedsButtonPressed:(UIButton*)feedsButton{
    
    // Сформировать канал, для которого нужно получить новости, и установить текущий канал
    NSString *currentChannelAlias = [self.selectChannelView getChannelAlias];
    NSURL *currentChannelURL = [self.selectChannelView getChannelURLLink];
    HURSSChannelRecievingType channelType = HURSSChannelUserCreated;
    
    HURSSChannel *currentChannel = [HURSSChannel channelWithAlias:currentChannelAlias withURL:currentChannelURL withType:channelType];
    
    _feedsReciever.feedsDelegate = self;
    [_feedsReciever loadFeedsForChannel:currentChannel];
    
    // Повесить на интерфейс ожидание
    [self.selectChannelView startFeedsWaiting];
}


- (NSArray<HURSSFeedItem*>*)getRecievedFeeds{
    
    if(! _isFeedsSuccessRecieved){
        @throw [NSException exceptionWithName:@"getFeedsException" reason:@"Protocol HURSSChannelSelectRecievedFeedsProtocol Incorrect Implement. While Feeds don't recieved - Segue impossible" userInfo:nil];
    }
    return [NSArray arrayWithArray:_recievedFeedsItems];
}

- (HURSSFeedInfo*)getFeedInfo{
    
    if(! _isFeedsSuccessRecieved){
        @throw [NSException exceptionWithName:@"getFeedsException" reason:@"Protocol HURSSChannelSelectRecievedFeedsProtocol Incorrect Implement. While Feeds don't recieved - Segue impossible" userInfo:nil];
    }
    return _recievedHeaderFeedInfo;
}


- (void)didSuccessRecievedFeeds:(NSArray<HURSSFeedItem*>*)recievedFeeds withFeedInfo:(HURSSFeedInfo*)recievedFeedInfo forChannel:(HURSSChannel*)feedsChannel{
    
    NSLog(@"SUCCESS FEEDS , %lu feeds\nFeedInfo : %@\nChannel %@", (unsigned long)recievedFeeds.count, recievedFeedInfo, feedsChannel.channelAlias);
    
    _recievedFeedsItems = recievedFeeds;
    _recievedHeaderFeedInfo = recievedFeedInfo;
    
    _isFeedsSuccessRecieved = YES;
    [self.selectChannelView endFeedsWaitingWithCompletion:^{
        
        [[HURSSTwirlRouter sharedRouter] performTransitionSegue:HURSSTwirlChannelSelectedSegue forScreen:self];
    }];
}

- (void)didFailureRecievingFeedsWithErrorDescription:(NSString*)errorDescription forChannel:(HURSSChannel*)feedsChannel{
    
    NSLog(@"FAILURE FEEDS , ERROR : %@\nChannel : %@", errorDescription, feedsChannel.channelAlias);
    
    NSString *channelName = feedsChannel.channelAlias;
    [self.selectChannelView endFeedsWaitingWithCompletion:nil];
    [self.selectChannelView showFeedsFailRecivingAlertForChannelName:channelName withErrorDescription:errorDescription];
    [self.selectChannelView setFeedsRepeatAlertHandler:@selector(recieveFeedsButtonPressed:) withTarget:self];
}


#pragma mark - HURSSChannelSelectionDelegate IMP

/**
    @abstract Когда пользователь выбирает канал в списке
    @discussion
    Когда пользователь выбирает канал в списке - установить информацию этого канала во вьюшку, и предложить пользователю получить сразу новости
 
    @param indexChannel      Индекс выбранного канала (в массиве _preservedChannels)
 */
- (void)didSelectedChannelWithIndex:(NSUInteger)indexChannel{
    
    // Получить модель канала по индексу, установить информацию в UI
    HURSSChannel *selectedChannel = _reservedChannels[indexChannel];
    NSURL *selectedChannelURL = selectedChannel.channelURL;
    [self.selectChannelView showChannelURLLink:selectedChannelURL];
    [self.selectChannelView showChannelAlias:selectedChannel.channelAlias];
    
    // Показывает диалог, и устанавливает обработчик диалога
    NSString *channelName = selectedChannel.channelAlias;
    [self.selectChannelView showObtainingFeedsAlertForChannelName:channelName];
    [self.selectChannelView setObtainingFeedsAlertHandler:@selector(recieveFeedsButtonPressed:) withTarget:self];
}


@end


