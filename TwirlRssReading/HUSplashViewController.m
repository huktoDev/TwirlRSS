//
//  ViewController.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSplashViewController.h"

#import "HURSSTwirlRouter.h"
#import "HURSSTwirlStyle.h"
#import "Masonry.h"

@interface HUSplashViewController ()

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
