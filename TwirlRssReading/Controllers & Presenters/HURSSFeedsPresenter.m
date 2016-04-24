//
//  HURSSFeedsPresenter.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedsPresenter.h"


@implementation HURSSFeedsPresenter{
    
    // Модуль приложения для обработки ссылок
    UIApplication *_application;
}


#pragma mark - HURSSFeedsTransferProtocol IMP

@synthesize feeds = _feeds;
@synthesize feedInfo = _feedInfo;


#pragma mark - ViewController LifeCycle

- (void)loadView{
    
    // Программное создание вьюшек
    HURSSFeedsTableView *newFeedsTableView = [HURSSFeedsTableView new];
    
    self.feedsTableView = newFeedsTableView;
    self.view = newFeedsTableView;
    
    [self.feedsTableView configBackgroundView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Инжектировать зависимости
    [self injectDependencies];
    
    // Что-то вроде ViewModel-я без вью-модели (передаются сырые, не адаптированные модели, как дата сорс)
    [self.feedsTableView setViewedFeeds:_feeds];
    [self.feedsTableView setViewedInfo:_feedInfo];
    
    // Указывает презентер, как объект, ловящий события выбора новости табличного представления
    self.feedsTableView.selectionDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Показать навигационную панель на этом  экране
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark -Dependencies

/// Инжектировать объект приложения (для обработки ссылок)
- (void)injectDependencies{
    
    _application = [UIApplication sharedApplication];
}


#pragma mark - HURSSFeedsSelectionDelegate IMP

/**
    @abstract Метод-обработчик момента, когда пользователь нажимает (выбирает) на новость
    @discussion
    Когда пользователь нажимает на новость - ему нужно открывать эту новость в браузере!
    Если у новости невалидная ссылка - показывать алерт.
 
    HURSSFeedsTableView хранит в себе selectionDelegate. И делегату при возникновении события - передает соответствующую информацию в этом методе
 
    @param feedCell       Выбранная новостная ячейка
    @param feedItem        Связанная с ячейкой новость
 */
- (void)didSelectFeedCell:(HURSSFeedsCell*)feedCell withLinkedFeedItem:(HURSSFeedItem*)feedItem{
    
    // Получает ссылку на новость
    NSURL *feedURL = [NSURL URLWithString:feedItem.link];
    
    // Может ли отккрыть ссылку (валидная ли ссылка?)
    BOOL canOpenFeedLink = [_application canOpenURL:feedURL];
    if(canOpenFeedLink){
        [_application openURL:feedURL];
    }else{
        // Показать алерт
    }
}


@end



