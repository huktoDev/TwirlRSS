//
//  AppDelegate.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSAppDelegate.h"


@implementation HURSSAppDelegate{
    
    // Роутер приложения
    HURSSTwirlRouter *_userStoryRouter;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Инжектировать сервисы
    [self injectDependencies];
    
    // Перегрузить стандартное создание  (заменить собственным стартовым окном и контроллером)
    [_userStoryRouter overrideInitialScreenCreationByAppDelegate:self];
    
    return YES;
}

#pragma mark - Dependencies

/// Инжектировать зависимости
- (void)injectDependencies{
    
    _userStoryRouter = [HURSSTwirlRouter sharedRouter];
}


@end
