//
//  HUSelectRSSChannelPresenter.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSelectRSSChannelPresenter.h"
#import "HUSelectRSSChannelView.h"
#import "HURSSChannelTextField.h"
#import "HURSSChannelButton.h"

#import "HURSSTwirlStyle.h"

#import "HURSSChannel.h"
#import "HURSSChannelStore.h"

#import "CZPicker.h"
#import "URBNAlert.h"

//TODO: Исправить ошибки с NSNumber (там transform.scale убрать)

@interface HUSelectRSSChannelPresenter () 

@end

@implementation HUSelectRSSChannelPresenter{
    
    NSArray <HURSSChannel*> *_reservedChannels;
    NSArray <NSString*> *_reservedChannelNames;
}


#pragma mark - UIView LifeCycle

- (void)loadView{
    
    HUSelectRSSChannelView *rootChannelsView = [HUSelectRSSChannelView createChannelView];
    [rootChannelsView configurationAllStartedViews];
    
    
    self.selectChannelView = rootChannelsView;
    self.view = rootChannelsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.selectChannelView setShowChannelHandler:@selector(obtainChannelsButtonPressed:) withTarget:self];
    [self.selectChannelView setGetFeedsHandler:@selector(recieveFeedsButtonPressed:) withTarget:self];
    [self.selectChannelView setAddChannelHandler:@selector(addChannelButtonPressed:) withTarget:self];
    [self.selectChannelView setDeleteChannelHandler:@selector(deleteChannelButtonPressed:) withTarget:self];
    
    [self.selectChannelView updateUIWhenEnteredChannelURLValidate:NO];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(channelTextChangedNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)channelTextChangedNotification:(NSNotification*)channelTextNotification{
    
    HURSSChannelTextField *channelTextField = (HURSSChannelTextField*)channelTextNotification.object;
    HURSSChannelTextFieldType channelFieldType = [self.selectChannelView getChannelTextFieldType:channelTextField];
    
    if(channelFieldType == HURSSChannelEnterURLFieldType){
        
        NSString *channelTextURLString = channelTextField.text;
        NSURL *enteredChannelURL = [NSURL URLWithString:channelTextURLString];
        
        BOOL isValidRSSChannel = enteredChannelURL && [HURSSChannel isValidChannelURL:enteredChannelURL];
        [self.selectChannelView updateUIWhenEnteredChannelURLValidate:isValidRSSChannel];
        
    }else if(channelFieldType == HURSSChannelAliasFieldType){
        
        HURSSChannelStore *channelStore = [HURSSChannelStore sharedStore];
        NSString *channelTextAliasString = channelTextField.text;
        BOOL isNameEnoughLength = channelTextAliasString && (channelTextAliasString.length >= 4);
        BOOL isChannelFounded = [channelStore containsChannelWithName:channelTextAliasString];
        
        HURSSChannelState currentChannelState = HURSSChannelStateImpossible;
        if(isNameEnoughLength){
            if(isChannelFounded){
                currentChannelState = HURSSChannelStatePossibleModifyDel;
            }else{
                currentChannelState = HURSSChannelStatePossibleAdd;
            }
        }
        
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
    HURSSChannelStore *channelsStore = [HURSSChannelStore sharedStore];
    _reservedChannels = [channelsStore loadStoredChannels];
    _reservedChannelNames = [channelsStore loadStoredChannelsName];
    
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
    HURSSChannelStore *channelsStore = [HURSSChannelStore sharedStore];
    BOOL isSuccessSaved = [channelsStore saveNewChannel:newChannel];
    
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
    HURSSChannelStore *channelsStore = [HURSSChannelStore sharedStore];
    BOOL isSuccessDeleted = [channelsStore deleteChannel:currentChannel];
    
    // Если удалось удалить - убрать клавиатуру, обновить состояние UI и показать диалог
    if(isSuccessDeleted){
        [self.selectChannelView hideKeyboard];
        [self.selectChannelView updateUIWhenChannelChangeState:HURSSChannelStatePossibleAdd];
        [self.selectChannelView showAlertPostAction:HURSSChannelActionDelete ForChannelName:currentChannel.channelAlias withURL:currentChannel.channelURL];
    }
}

- (void)recieveFeedsButtonPressed:(UIButton*)feedsButton{
    
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


