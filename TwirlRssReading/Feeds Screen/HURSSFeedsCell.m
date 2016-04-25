//
//  HURSSFeedsCell.m
//  TwirlRssReading
//
//  Created by Alexandr Babenko on 16.04.16.
//  Copyright © 2016 Alexandr Babenko. All rights reserved.
//

#import "HURSSFeedsCell.h"

@implementation HURSSFeedsCell{
    
    // Сконфигурирована уже ячейка, или нет?
    BOOL _isBaseConfigured;
    
    // Запомненные констрейнты высот тайтлов
    MASConstraint *_feedsSummaryHeightConstraint;
    MASConstraint *_feedsTitleHeightConstraint;
    
    // Запомненный верхний констрейнт вьюшки контента
    MASConstraint *_feedsTopSummaryConstraint;
}


#pragma mark - BASE CONFIGURATION METHOD

/**
    @abstract При первом создании ячейки - выполнить базовую конфигурацию
    @discussion
    Код конфигурации выполняется только 1 раз для каждой ячейки. 
    Создает следующие сабвьюшки :
    <ol type="1">
        <li> backView - Фоновая вьюшка </li>
        <li> feedTitleLabel - Вьюшка-лейбл описания новости </li>
        <li> separatorView - Вьюшка, разделяющая контент и название </li>
        <li> feedAuthorlabel - Лейбл для отображения никнейма автора </li>
        <li> feedDateLabel - Лейбл для отображения даты </li>
        <li> feedDescriptionLabel - Лейбл для контента новости (использется аттрибутированная строка) </li>
    </ol>
 */
- (void)baseConfigurationIfNeeded{
    
    if(! _isBaseConfigured){
        
        [self configBaseCell];
        
        self.backView = [self createBackgroundView];
        self.feedTitleLabel = [self createFeedTitleLabel];
        self.separatorView = [self createSeparationView];
        self.feedAuthorLabel = [self createFeedAuthorLabel];
        self.feedDateLabel = [self createFeedDateLabel];
        self.feedDescriptionLabel = [self createFeedSummaryContentLabel];
        
        _isBaseConfigured = YES;
    }
}


#pragma mark - Config Cell

/// Базовая настройка ячейки
- (void)configBaseCell{
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


#pragma mark - CREATION SubViews

/// Создать фоновую вьюшку (сделать скругленные углы, и вписать в контент вью)
- (UIView*)createBackgroundView{
    
    // Инициализировать вьюшку и задать цвет
    UIView *backView = [UIView new];
    backView.backgroundColor = [[HURSSTwirlStyle sharedStyle] channelTextFieldBackColor];
    
    // Конфигурировать границу и углы
    UIColor *borderBackViewColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4f];
    CALayer *backViewLayer = backView.layer;
    [backViewLayer setBorderWidth:2.f];
    [backViewLayer setBorderColor:borderBackViewColor.CGColor];
    [backViewLayer setCornerRadius:26.f];
    
    // Добавить сабвьюшку
    [self.contentView addSubview:backView];
    
    // Вписать вьюшку в контент вью
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).with.offset(HU_RSS_FEEDS_TABLE_VIEW_MARGIN);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-HU_RSS_FEEDS_TABLE_VIEW_MARGIN);
        make.top.equalTo(self.contentView.mas_top).with.offset(HU_RSS_FEEDS_TABLE_VIEW_MARGIN);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-HU_RSS_FEEDS_TABLE_VIEW_MARGIN);
    }];
    return backView;
}

/// Создать лейбл для описания новости (лейбл с определяющимся количеством строк)
- (UILabel*)createFeedTitleLabel{
    
    // Создать и задать параметры текстового лейбла
    UILabel *feedTitleLabel = [UILabel new];
    feedTitleLabel.font = [[HURSSTwirlStyle sharedStyle] channelTextFieldFont];
    feedTitleLabel.textColor = [UIColor darkGrayColor];
    feedTitleLabel.numberOfLines = 0;
    feedTitleLabel.backgroundColor = [UIColor clearColor];
    
    // Добавить сабвьюшку
    [self.backView addSubview:feedTitleLabel];
    
    // Задать правила вьюшки
    [feedTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.backView.mas_width).with.offset(- (2.f * HU_RSS_FEEDS_CELL_CONTENT_MARGIN));
        make.centerX.equalTo(self.backView.mas_centerX);
        make.top.equalTo(self.backView.mas_top).with.offset(12.f);
        
        // Запомнить констрейнт высоты, чтобы потом можно было его удобно модифицировать
        MASConstraint *heightConstraint = make.height.mas_equalTo(24.f);
        _feedsTitleHeightConstraint = heightConstraint;
    }];
    return feedTitleLabel;
}

/// Создать сепаратор между контентом и тайтлом
- (UIView*)createSeparationView{
    
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    
    [self.backView addSubview:separatorView];
    
    [separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backView.mas_leading);
        make.trailing.equalTo(self.backView.mas_trailing);
        make.top.equalTo(self.feedTitleLabel.mas_bottom).with.offset(8.f);
        make.height.mas_equalTo(2.f);
    }];
    return separatorView;
}

/// Создать лейбл для отображения никнейма автора
- (UILabel*)createFeedAuthorLabel{
    
    // Создать и задать параметры вьюшки
    UILabel *feedAuthorLabel = [UILabel new];
    feedAuthorLabel.font = [UIFont boldSystemFontOfSize:18.f];
    feedAuthorLabel.textColor = [[UIColor brownColor] colorWithAlphaComponent:0.8f];
    
    // Добавить вьюшку
    [self.backView addSubview:feedAuthorLabel];
    
    // Задать правила вьюшки (к низу сепаратора привязать)
    [feedAuthorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.backView.mas_width).with.multipliedBy(0.85f);
        make.leading.equalTo(self.backView.mas_leading).with.offset(HU_RSS_FEEDS_CELL_CONTENT_MARGIN);
        make.height.mas_offset(30.f);
        make.top.equalTo(self.separatorView.mas_bottom).with.offset(4.f);
    }];
    return feedAuthorLabel;
}

/// Создать лейбл для отображения даты создания новости
- (UILabel*)createFeedDateLabel{
    
    // Создать и задать параметры вьюшки
    UILabel *feedDateLabel = [UILabel new];
    feedDateLabel.font = [UIFont systemFontOfSize:12.f];
    feedDateLabel.textColor = [UIColor colorWithWhite:0.4f alpha:1.f];
    feedDateLabel.textAlignment = NSTextAlignmentRight;
    
    // Добавить вьюшку
    [self.backView addSubview:feedDateLabel];
    
    // Задать правила вьюшки (к низу authorLabel привязать)
    [self configBottomLocationFeedsDate];
    return feedDateLabel;
}

/// Создать лейбл для отображения контента новости (что перед катом)
- (UILabel*)createFeedSummaryContentLabel{
    
    // Создать и задать параметры вьюшки (автоподстройка количества линий)
    UILabel *feedDescriptionLabel = [UILabel new];
    feedDescriptionLabel.backgroundColor = [UIColor clearColor];
    feedDescriptionLabel.numberOfLines = 0;
    
    // Добавить вьюшку
    [self.backView addSubview:feedDescriptionLabel];
    
    // Задать правила интерфейса (привязывается к низу dateLabel)
    [feedDescriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.feedTitleLabel.mas_width);
        make.centerX.equalTo(self.feedTitleLabel.mas_centerX);
        
        // Запомнить констрейнт для изменения привязка к лейблу даты
        MASConstraint *topConstraint = make.top.equalTo(self.feedDateLabel.mas_bottom).with.offset(-8.f);
        _feedsTopSummaryConstraint = topConstraint;
        
        // Запомнить констрейнт для удобного изменения высоты
        MASConstraint *heightConstraint = make.height.mas_equalTo(400.f);
        _feedsSummaryHeightConstraint = heightConstraint;
    }];
    return feedDescriptionLabel;
}


#pragma mark - Config Locations

/// Задать лейблу даты нижнее расположение (под лейблом автора)
- (void)configBottomLocationFeedsDate{
    
    [self.feedDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.backView.mas_width).with.multipliedBy(0.6f);
        make.trailing.equalTo(self.backView.mas_trailing).with.offset(-HU_RSS_FEEDS_CELL_CONTENT_MARGIN);
        make.height.mas_offset(16.f);
        make.top.equalTo(self.feedAuthorLabel.mas_bottom).with.offset(-4.f);
    }];
}

/// Задать лейблу даты верхнее расположение (под сепаратором)
- (void)configTopLocationFeedsDate{
    
    [self.feedDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.backView.mas_width).with.multipliedBy(0.6f);
        make.trailing.equalTo(self.backView.mas_trailing).with.offset(-HU_RSS_FEEDS_CELL_CONTENT_MARGIN);
        make.height.mas_offset(16.f);
        make.top.equalTo(self.separatorView.mas_bottom).with.offset(4.f);
    }];
}

#pragma mark - PREPARE With Model

/**
    @abstract Подготовить ячейку информацией о новости
    @discussion
    Этот метод вызывается каждый раз при формировании ячейки, или для заполнения ее новой информацией. 
    Модель заранее подготавливается, и соответствующая информация кэшируется, обрабатывается, вычисляется.
 
    @note Если это первый вызов этого метода для ячейки - конфигурироват вьюшку (создать сабвьюшки)
 
    <h4> Устанавливает следующую информацию : </h4>
    <ol type="a">
        <li>feedTitleLabel -  Устанавливает описание новости </li>
        <li> feedAuthorLabel - Устанавливает никнейм автора </li>
        <li> feedDateLabel - Устанавливает строку  даты новости </li>
        <li> feedDescriptionLabel - Устанавливает контент новости </li>
        <li> Обновляет высоту тайтла </li>
        <li> Обновляет высоту контента </li>
        <li> Делает некоторые другие настройки для более удобного отображения контента </li>
    </ol>
 
    @param feedItem      Модель RSS-новости, которую будет представлять ячейка
 */
- (void)prepareWithFeedItem:(HURSSFeedItem*)feedItem{
    
    // Выполнить базовую конфигурацию ячейки (решил выполнять отложенно, а не при создании) (тогда пришлось бы сразу несколько констукторов переопределять)
    [self baseConfigurationIfNeeded];
    
    // Устанавливает содержимое
    [self.feedTitleLabel setText:feedItem.title];
    [self.feedAuthorLabel setText:feedItem.author];
    [self.feedDateLabel setText:feedItem.formattedCreationDate];
    [self.feedDescriptionLabel setAttributedText:feedItem.attributedSummary];
    
    // Установить высоту тайтлов немного с запасом (отступы)
    [_feedsTitleHeightConstraint setOffset:(feedItem.titleContentHeight + 8.f)];
    [_feedsSummaryHeightConstraint setOffset:(feedItem.summaryContentHeight + 8.f)];
    
    // Если первый символ текста - это отступ - убрать его последствия
    unichar firstSummaryChar = [feedItem.attributedSummary.string characterAtIndex:0];
    BOOL isFirstCharIndent = (firstSummaryChar == '\n');
    if(isFirstCharIndent){
        [_feedsTopSummaryConstraint setOffset:-16.f];
    }else{
        [_feedsTopSummaryConstraint setOffset:0.f];
    }
    
    // Если нету автора у текста - перепривязать ячейку даты к сепаратору, иначе - к лейблу автора
    if(feedItem.author.length > 0){
        [self configBottomLocationFeedsDate];
    }else{
        [self configTopLocationFeedsDate];
    }
    
    // Пересобрать макет
    [self layoutIfNeeded];
}

/**
    @abstract Метод подсветки ячейки
    @discussion
    Когда пользователь нажимает на ячейку - она "подсвечивается"
    Когда делает тач аут - подсветка снимается
 
    @note Анимация подсветки выполняется с эффектом  пружины
    @note При анимации изменяется скейл, цвет и альфа-свойство
 
    @param highlighted      Включить или выключить подсветку?
    @param animated         Анимированно или нет выполнить подсветку?
 */
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    NSTimeInterval animationDuration = 0.6f; /*animated ? 0.6f : 0.f;*/
    if(highlighted){
        
        [UIView animateWithDuration:animationDuration delay:0.f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.backView.transform = CGAffineTransformScale(self.backView.transform, 0.96f, 0.96f);
            self.backView.backgroundColor = [[HURSSTwirlStyle sharedStyle] channelButtonBackColor];
            self.backView.alpha = 0.88f;
            
        } completion:nil];
        
    }else {
        
        [UIView animateWithDuration:animationDuration delay:0.f usingSpringWithDamping:0.3f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.backView.transform = CGAffineTransformIdentity;
            self.backView.alpha = 1.f;
            self.backView.backgroundColor = [[HURSSTwirlStyle sharedStyle] channelTextFieldBackColor];
            
        } completion:nil];
    }
}


@end





