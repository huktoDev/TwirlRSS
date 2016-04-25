//
//  ViewController.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSplashViewController.h"
#import "HURSSCoreDataFeedsStore.h"

@interface HUSplashViewController ()

/// Имейдж вью для логотипа
@property UIImageView *logoImageView;

@end


@implementation HUSplashViewController{
    
    // Используемые сервисы
    id<HURSSStyleProtocol> _presentStyle;
    id<HUBaseRouterProtocol> _userStoryRouter;
}

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Инъекция сервисов
    [self injectDependencies];
    /*
    
    HURSSCoreDataFeedsStore *feedsStore = [HURSSCoreDataFeedsStore feedsStore];
    
    NSArray <HURSSFeedInfo*> *storedFeedInfos = [feedsStore loadFeedInfo];
    
    HURSSFeedInfo *newFeedInfo = [HURSSFeedInfo new];
    
    newFeedInfo.title = @"FUCK";
    newFeedInfo.link = @"OVERFUCK";
    newFeedInfo.summary = @"SUMMARY FUCK";
    newFeedInfo.url = [NSURL URLWithString:@"http://fuck.ru"];
    
    [feedsStore saveFeedInfo:newFeedInfo];
    
    NSArray <HURSSFeedInfo*> *storedFeedInfos2 = [feedsStore loadFeedInfo];
    
    HURSSChannel *testChannel = [HURSSChannel new];
    
    testChannel.channelAlias = @"FuckAlias1";
    testChannel.channelURL = [NSURL URLWithString:@"http://fuck2.ru"];
    testChannel.channelType = HURSSChannelUserCreated;

    HURSSFeedItem *testItem = [HURSSFeedItem new];
    testItem.title = @"HEH";
    
    HURSSFeedItem *testItem2 = [HURSSFeedItem new];
    testItem2.title = @"HEH2";
    
    NSAttributedString *testString = [[NSAttributedString alloc] initWithString:@"TestATTRIB" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]}];
    testItem2.attributedSummary = testString;
    testItem2.summaryContentHeight = 500.f;
    
    [feedsStore saveRSSChannelInfo:testChannel withFeedInfo:newFeedInfo withFeeds:@[testItem, testItem2]];
    
    [feedsStore loadRSSChannelsWithCallback:^(HURSSChannel *loadedChannel, HURSSFeedInfo *loadedFeedInfo, NSArray<HURSSFeedItem *> *loadedFeedItems) {
        
        NSLog(@"123123");
    }];
*/
    
    
    
    // Установить бэкграунд
    UIColor *backColor = [_presentStyle splashScreenColor];
    [self.view setBackgroundColor:backColor];
    
    // Получить, сконфигурировать и добавить вьюшку логотипа
    UIImageView *logoImageView = [self createLogoView];
    self.logoImageView = logoImageView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // После того, как будет полностью показан Splash-экран - запустить к выполнению переход дальше
    [_userStoryRouter performTransitionSegue:HURSSTwirlBaseNavigationSegue forScreen:self];
}


#pragma mark - Dependencies

/**
    @abstract Инъекция требуемых объектов 
    @discussion
    Выполняет инъекцию :
    - Объекта, задающего стили
    - Роутер текущей юзер-стори
 */
- (void)injectDependencies{
    
    _presentStyle = [HURSSTwirlStyle sharedStyle];
    _userStoryRouter = [HURSSTwirlRouter sharedRouter];
}


#pragma mark - Config Views

/**
    @abstract Создает и конфигурирует вьюшку логотипа
    @discussion
    Ту картинку, которую вы скинули по имейлу вместе с тестовым - здесь использовал.
    Выполняется задание констрейнтов (по центру, и ровно по размеру пикчи), хотя и использовал UIViewContentModeCenter
    @return Готовая вьюшка логотипа
 */
- (UIImageView*)createLogoView{
    
    const CGSize logoImageDefinedSize = [_presentStyle splashLogoSize];
    UIImage *logoImage = [_presentStyle splashLogoImage];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    logoImageView.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:logoImageView];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(logoImageDefinedSize);
        make.center.equalTo(self.view);
    }];
    return logoImageView;
}


@end
