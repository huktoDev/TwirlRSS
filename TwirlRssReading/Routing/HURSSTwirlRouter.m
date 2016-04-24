//
//  HURSSTwirlRouter.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 17.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSTwirlRouter.h"


NSString *const HURSSTwirlBaseNavigationSegue   =   @"HURSSTwirlBaseNavigationSegue";
NSString *const HURSSTwirlChannelSelectedSegue  =   @"HURSSTwirlChannelSelectedSegue";
NSString *const HURSSTwirlFeedDetailsSegue      =   @"HURSSTwirlFeedDetailsSegue";


@implementation HURSSTwirlRouter

#pragma mark - CREATION & CONFIGURATION

+ (instancetype)sharedRouter{
    
    static HURSSTwirlRouter *_sharedRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRouter = [HURSSTwirlRouter new];
    });
    return _sharedRouter;
}

-  (instancetype)init{
    if(self = [super init]){
        [self configService];
    }
    return self;
}

/**
    @abstract Конфигурирует сервис конкретными классами контроллеров 
    @discussion
    Здесь можно подменять классы контроллеров на классы моков.
 */
- (void)configService{
    
    _splashScreenController     =   [HUSplashViewController class];
    _baseNavController          =   [HURSSNavigationController class];
    _selectChannelController    =   [HUSelectRSSChannelPresenter class];
    _feedsController            =   [HURSSFeedsPresenter class];
    _itemDetailsController      =   [HURSSItemPresenter class];
}


#pragma mark - HUBaseRouterProtocol IMP

/**
    @abstract Метод, запускающий на выполнение  переход к новому экрану
    @discussion
    Является подобием к методу UIStoryboardSegue-механизма - performSegueWithIdentifier
    Выполняет несколько последовательных задач :
    <ol type="1">
        <li> Проверяет, следуют ли входящие значения "контракту" </li>
        <li> Проверяет, может ли сега выполняться (если NO - прерывает выполнение) </li>
        <li> Если может - выполняет диспетчеризацию к соответствующему методу перехода </li>
    </ol>
 
    @param nameSegue      Название сеги
    @param screenVC       Контроллер или презентер экрана, с которого был инициирован переход
 */
- (void)performTransitionSegue:(NSString*)nameSegue forScreen:(UIViewController*)screenVC{
    
    // Проверка входящих параметров
    NSAssert((nameSegue != nil), @"Segue must be not nil in %s", __PRETTY_FUNCTION__);
    NSAssert([nameSegue isKindOfClass:[NSString class]], @"Segue must be NSString object");
    NSAssert(screenVC != nil, @"screenVC must be not nil");
    NSAssert([screenVC isKindOfClass:[UIViewController class]], @"screenVC must be object UIViewController");
    
    // Может ли выполниться переход
    BOOL canTransit = [self canPerformSegue:nameSegue forScreen:screenVC];
    if(! canTransit){
        return;
    }
    
    // Диспетчеризация к подходящему переходу
    BOOL isBaseNavSegue = [nameSegue isEqualToString:HURSSTwirlBaseNavigationSegue];
    if(isBaseNavSegue){
        [self performBaseNavigationSegueFromScreen:screenVC];
    }
    
    BOOL isChannelSelSegue = [nameSegue isEqualToString:HURSSTwirlChannelSelectedSegue];
    if(isChannelSelSegue){
        [self performChannelSelectedSegueFromScreen:screenVC];
    }
    
    BOOL isFeedDetailSegue = [nameSegue isEqualToString:HURSSTwirlFeedDetailsSegue];
    if(isFeedDetailSegue){
        [self performFeedDetailsSegueFromScreen:screenVC];
    }
}
    

/**
    @abstract Метод, возвращающий набор валидных переходов для экрана
    @discussion
    Для каждого экрана имеется жестко вбитый набор переходов (идентификаторов сег), которые позволительно выполнять для этого экрана.
 
    @throw unknownScreenException
        Если экран неизвестен (не захардкожен в методе)
 
    @param screenVC      Вью-контроллер или презентер, для которого нужно выяснить валидные переходы
    @return Множество валидных ID переходов
 */
- (NSSet <NSString*> *)possibleSeguesForScreen:(UIViewController*)screenVC{
    
    BOOL isSubclassViewController = [screenVC isKindOfClass:[UIViewController class]];
    NSAssert(isSubclassViewController, @"Screen %@ is not subclass UIViewController, Method : %s", screenVC,__PRETTY_FUNCTION__);
    
    NSSet <NSString*> *possibleSegues = nil;
    
    // Проверяется, какой это конкретно контроллер инициировал
    BOOL isSplashScreen = [screenVC isKindOfClass:[_splashScreenController class]];
    BOOL isRSSSelectScreen = [screenVC isKindOfClass:[_selectChannelController class]];
    BOOL isRSSFeedsScreen = [screenVC isKindOfClass:[_feedsController class]];
    BOOL isRSSItemDetailsScreen = [screenVC isKindOfClass:[_itemDetailsController class]];
    
    // Получается набор валидных переходов для конкретного экрана (из категории)
    if(isSplashScreen){
        possibleSegues = [self possibleSplashSegues];
    }else if(isRSSSelectScreen){
        possibleSegues = [self possibleSelectChannelSegues];
    }else if(isRSSFeedsScreen){
        possibleSegues = [self possibleFeedsSegues];
    }else if(isRSSItemDetailsScreen){
        possibleSegues = [self possibleItemDetailsSegues];
    }else{
        @throw [NSException exceptionWithName:@"unknownScreenException" reason:@"Unknown Screen for TwirlRSSReading. Register Screen in HURSSTwirlRouter" userInfo:nil];
    }
    
    return possibleSegues;
}

/**
    @abstract Возможно ли выполнить переход к сеге?
    @discussion
    На основании имеющихся сег для конкретного экрана - проверяется ее наличие
 
    @param nameSegue       название сеги
    @param screenVC      Вью-контроллер или презентер, для которого нужно выполнить проверку
    @return YES - если возможно, иначе - NO
 */
- (BOOL)canPerformSegue:(NSString*)nameSegue forScreen:(UIViewController*)screenVC{
    
    NSSet <NSString*> *possibleSegues = [self possibleSeguesForScreen:screenVC];
    if(possibleSegues.count == 0){
        return NO;
    }
    
    BOOL isKnownSegue = [possibleSegues containsObject:nameSegue];
    return isKnownSegue;
}


@end

