//
//  ViewController.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HUSplashViewController.h"
#import "HURSSTwirlStyle.h"
#import "Masonry.h"

@interface HUSplashViewController ()

@property UIImageView *logoImageView;

@end

@implementation HUSplashViewController{
    
    id<HURSSStyleProtocol> presentStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    presentStyle = [HURSSTwirlStyle sharedStyle];
    
    
    UIColor *backColor = [presentStyle splashScreenColor];
    [self.view setBackgroundColor:backColor];
    
    
    const CGSize logoImageDefinedSize = [presentStyle splashLogoSize];
    UIImage *logoImage = [UIImage imageNamed:@"improveDigitalLogo.png"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    logoImageView.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(logoImageDefinedSize);
        make.center.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
