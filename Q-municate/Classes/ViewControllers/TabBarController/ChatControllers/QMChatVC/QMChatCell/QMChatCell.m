//
//  QMChatCell.m
//  Q-municate
//
//  Created by Ivanov Andrey on 11.06.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMChatCell.h"
#import "NSString+UsedSize.h"
#import "QMImageView.h"
#import "Parus.h"

@interface QMChatCell ()

@property (strong, nonatomic) UIView *messageContainer;
@property (strong, nonatomic) QMImageView *userImageView;
@property (strong, nonatomic) UIImageView *balloonImageView;
@property (strong, nonatomic) CALayer *maskLayer;
@property (strong, nonatomic) NSArray *currentAlignConstrains;

@property (strong, nonatomic) NSLayoutConstraint *rMessageContainerConstraint;
@property (strong, nonatomic) NSLayoutConstraint *lMessageContainerConstraint;
@property (strong, nonatomic) NSLayoutConstraint *tMessageContainerConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bMessageContainerConstraint;

@property (strong, nonatomic) NSLayoutConstraint *hUserImageViewConstraint;
@property (strong, nonatomic) NSLayoutConstraint *wUserImageViewConstraint;

@property (strong, nonatomic) NSLayoutConstraint *hBalloonConstraint;
@property (strong, nonatomic) NSLayoutConstraint *wBalloonConstraint;

@property (strong, nonatomic) NSLayoutConstraint *bContainerConstraint;
@property (strong, nonatomic) NSLayoutConstraint *hContainerConstraint;
@property (strong, nonatomic) NSLayoutConstraint *wContainerConstraint;

@property (strong, nonatomic) NSLayoutConstraint *tTitleConstraint;
@property (strong, nonatomic) NSLayoutConstraint *lTitleConstraint;
@property (strong, nonatomic) NSLayoutConstraint *rTitleConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bTitleConstraint;

@end

@implementation QMChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createContainerSubviews];
    }
    return self;
}

//#define SHOW_BORDERS

- (void)createContainerSubviews {
    
    self.messageContainer = [[UIView alloc] init];
    self.containerView = [[UIView alloc] init];
    self.balloonImageView = [[UIImageView alloc] init];
    self.userImageView = [[QMImageView alloc] init];
    self.headerView = [[UILabel alloc] init];
    self.maskLayer = [CALayer layer];
    
    self.messageContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.balloonImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.userImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.userImageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.contentView addSubview:self.messageContainer];
    [self.messageContainer addSubview:self.balloonImageView];
    [self.messageContainer addSubview:self.userImageView];
    [self.balloonImageView addSubview:self.containerView];
    [self.messageContainer addSubview:self.headerView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
#ifdef SHOW_BORDERS
    
    self.messageContainer.layer.borderColor = [UIColor colorWithRed:1.000 green:0.975 blue:0.000 alpha:1.000].CGColor;
    self.messageContainer.layer.borderWidth = 1;
    
    self.containerView.layer.borderColor = [UIColor colorWithRed:0.706 green:0.147 blue:0.000 alpha:1.000].CGColor;
    self.containerView.layer.borderWidth = 1;
    
    self.userImageView.layer.borderColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.552 alpha:1.000].CGColor;
    self.userImageView.layer.borderWidth = 1;
    
    self.balloonImageView.layer.borderColor = [UIColor colorWithRed:0.000 green:0.826 blue:1.000 alpha:1.000].CGColor;
    self.balloonImageView.layer.borderWidth = 1;
    
    /***** ******/
    self.balloonImageView.backgroundColor = [UIColor lightGrayColor];
    //    self.containerView.backgroundColor = [UIColor orangeColor];
    self.userImageView.backgroundColor = [UIColor greenColor];
    self.headerView.backgroundColor = [UIColor colorWithWhite:0.128 alpha:0.400];
    self.messageContainer.backgroundColor = [UIColor yellowColor];
    
#endif
    [self createConstrains];
    
}

- (void)setBalloonImage:(UIImage *)balloonImage {
    
    if (_balloonImage != balloonImage) {
        _balloonImage = balloonImage;
        self.balloonImageView.image = _balloonImage;
    }
}

- (void)setBalloonTintColor:(UIColor *)balloonTintColor {
    
    if (_balloonTintColor != balloonTintColor) {
        _balloonTintColor = balloonTintColor;
        self.messageContainer.tintColor = _balloonTintColor;
    }
}

- (void)createConstrains {
    
    self.bMessageContainerConstraint = PVBottomOf(self.messageContainer).equalTo.bottomOf(self.contentView).asConstraint;
    self.tMessageContainerConstraint = PVTopOf(self.messageContainer).equalTo.topOf(self.contentView).asConstraint;
    self.lMessageContainerConstraint = PVLeftOf(self.messageContainer).equalTo.leftOf(self.contentView).asConstraint;
    self.rMessageContainerConstraint = PVRightOf(self.messageContainer).equalTo.rightOf(self.contentView).asConstraint;

    self.wUserImageViewConstraint = PVWidthOf(self.userImageView).equalTo.constant(0).asConstraint;
    self.hUserImageViewConstraint = PVHeightOf(self.userImageView).equalTo.constant(0).asConstraint;
    
    self.hBalloonConstraint = PVHeightOf(self.balloonImageView).equalTo.constant(0).asConstraint;
    self.wBalloonConstraint = PVWidthOf(self.balloonImageView).equalTo.constant(0).asConstraint;
    
    self.tTitleConstraint = PVTopOf(self.headerView).equalTo.topOf(self.balloonImageView).asConstraint;
    self.lTitleConstraint = PVLeftOf(self.headerView).equalTo.leftOf(self.balloonImageView).asConstraint,
    self.rTitleConstraint = PVRightOf(self.headerView).equalTo.rightOf(self.balloonImageView).asConstraint,
    self.bTitleConstraint = PVBottomOf(self.headerView).equalTo.topOf(self.containerView).asConstraint;
    
    self.bContainerConstraint = PVBottomOf(self.containerView).equalTo.bottomOf(self.balloonImageView).asConstraint;
    self.hContainerConstraint= PVHeightOf(self.containerView).equalTo.constant(0).asConstraint;
    self.wContainerConstraint= PVWidthOf(self.containerView).equalTo.constant(0).asConstraint;
    
    [self.contentView addConstraints:@[self.bMessageContainerConstraint, self.tMessageContainerConstraint,
                                       self.lMessageContainerConstraint, self.rMessageContainerConstraint,

                                       self.wUserImageViewConstraint,self.hUserImageViewConstraint,
                                       
                                       PVBottomOf(self.userImageView).equalTo.bottomOf(self.messageContainer).asConstraint,
                                       PVBottomOf(self.balloonImageView).equalTo.bottomOf(self.messageContainer).asConstraint,
                                       
                                       self.hBalloonConstraint, self.wBalloonConstraint,
                
                                       self.bContainerConstraint,self.hContainerConstraint, self.wContainerConstraint,
                                       
                                       self.tTitleConstraint, self.lTitleConstraint, self.rTitleConstraint, self.bTitleConstraint
                                       ]];
}

- (void)setCurrentAlignConstrains:(NSArray *)currentAlignConstrains {
    
    if (_currentAlignConstrains) {
        [self.contentView removeConstraints:_currentAlignConstrains];
    }
    _currentAlignConstrains = currentAlignConstrains;
    
    [self.contentView addConstraints:_currentAlignConstrains];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Set user image

- (void)setMessage:(QMMessage *)message {
    
    if (_message != message) {
        _message = message;
        
        QMMessageContentAlign align = self.message.align;
        QMMessageLayout layout = self.message.layout;
        UIEdgeInsets insets = UIEdgeInsetsZero;
        
        /*Layout text container*/
        self.bMessageContainerConstraint.constant = -layout.messageMargin.bottom;
        self.tMessageContainerConstraint.constant = layout.messageMargin.top;
        self.lMessageContainerConstraint.constant = layout.messageMargin.left;
        self.rMessageContainerConstraint.constant = - layout.messageMargin.right;
        
        CGSize userImageSize = self.isHiddenUserImage ? CGSizeZero : layout.userImageSize;
        self.hUserImageViewConstraint.constant = userImageSize.height;
        self.wUserImageViewConstraint.constant = userImageSize.width;
        
        if (align == QMMessageContentAlignLeft) {
            insets = layout.leftBalloon.imageCapInsets;
        } else if (align == QMMessageContentAlignRight) {
            insets = layout.rightBalloon.imageCapInsets;
        }
        
        CGFloat balloonWidth = insets.left + layout.contentSize.width + insets.right;
        
        if (balloonWidth < layout.messageMinWidth) {
            balloonWidth = layout.messageMinWidth;
        }
        
        if (align == QMMessageContentAlignLeft) {
            
            self.currentAlignConstrains =
            PVGroup(@[
                      PVLeftOf(self.userImageView).equalTo.leftOf(self.messageContainer).asConstraint,
                      PVLeftOf(self.balloonImageView).equalTo.rightOf(self.userImageView).asConstraint,
                      PVLeftOf(self.containerView).equalTo.leftOf(self.balloonImageView).plus(insets.left).asConstraint,
                      ]).asArray;
            
        } else if (align == QMMessageContentAlignRight) {
            
            self.currentAlignConstrains =
            PVGroup(@[
                      PVRightOf(self.userImageView).equalTo.rightOf(self.messageContainer).asConstraint,
                      PVRightOf(self.balloonImageView).equalTo.leftOf(self.userImageView).asConstraint,
                      PVRightOf(self.containerView).equalTo.rightOf(self.balloonImageView).minus(insets.right).asConstraint,

                      ]).asArray;
        }
        
        self.bContainerConstraint.constant = -insets.top;
        self.hContainerConstraint.constant = layout.contentSize.height;
        self.wContainerConstraint.constant = layout.contentSize.width;
        
        self.hBalloonConstraint.constant = insets.top + layout.contentSize.height + insets.bottom + layout.titleHeight;
        self.wBalloonConstraint.constant = balloonWidth;
        
        self.lTitleConstraint.constant = insets.left;
        self.rTitleConstraint.constant = -insets.right;
    }
    
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}

- (void)setUser:(QBUUser *)user {
    
    if (_user != user) {
        _user = user;
        NSURL *url = [NSURL URLWithString:user.website];
        UIImage *placeHolder = [UIImage imageNamed:@"upic-placeholder"];
        [self.userImageView sd_setImageWithURL:url placeholderImage:placeHolder];
    }
}

static NSDateFormatter *_dateFormatter = nil;

- (NSDateFormatter *)formatter {
    
    if (!_dateFormatter) {
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"HH:mm"];
    }
    
    return _dateFormatter;
}

@end
