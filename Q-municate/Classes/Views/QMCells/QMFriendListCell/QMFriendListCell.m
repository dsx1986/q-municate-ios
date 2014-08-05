//
//  QMFriendListCell.m
//  Q-municate
//
//  Created by Andrey Ivanov on 25/02/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMFriendListCell.h"
#import "QMImageView.h"
#import "QMApi.h"

@interface QMFriendListCell()

@property (weak, nonatomic) IBOutlet UIImageView *onlineCircle;
@property (weak, nonatomic) IBOutlet UIButton *addToFriendsButton;

@property (assign, nonatomic) BOOL isFriend;
@property (assign, nonatomic) BOOL online;

@end

@implementation QMFriendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /*isFriend - YES*/
    _isFriend = YES;
    self.addToFriendsButton.hidden = self.isFriend;
    /*isOnlien - NO*/
    self.onlineCircle.hidden = YES;
    self.descriptionLabel.text = NSLocalizedString(@"QM_STR_OFFLINE", nil);
}

- (void)setUserData:(id)userData {
    [super setUserData:userData];

    QBUUser *user = userData;
    self.titleLabel.text = (user.fullName.length == 0) ? @"" : user.fullName;
    NSURL *avatarUrl = [NSURL URLWithString:user.website];
    [self setUserImageWithUrl:avatarUrl];
}

- (void)setOnline:(BOOL)online {
    
    QBUUser *user = self.userData;
    online = (user.ID == [QMApi instance].currentUser.ID && [QMApi instance].currentUser.ID > 0) ? YES : online;
    
    if (_online != online) {
        _online = online;
    }
    
    NSString *status = NSLocalizedString(online ? @"QM_STR_ONLINE": @"QM_STR_OFFLINE", nil);
    
    self.descriptionLabel.text = status;
    self.onlineCircle.hidden = !online;
}

- (void)setContactlistItem:(QBContactListItem *)contactlistItem {

    [super setContactlistItem:contactlistItem];
    self.online = contactlistItem.online;
    self.isFriend = contactlistItem ?  YES : NO;
}

- (void)setIsFriend:(BOOL)isFriend {
    
    QBUUser *user = self.userData;
    isFriend = (user.ID == [QMApi instance].currentUser.ID && [QMApi instance].currentUser.ID > 0) ? YES : isFriend;
    
    _isFriend = isFriend;
    
    self.addToFriendsButton.hidden = isFriend;
    if (!_isFriend) {
        self.descriptionLabel.text = @"";
    }
}

- (void)setSearchText:(NSString *)searchText {
    
    _searchText = searchText;
    if (_searchText.length > 0) {
        
        QBUUser *user = self.userData;
        NSString *fullName = user.fullName;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:fullName];
        [text addAttribute: NSForegroundColorAttributeName
                     value:[UIColor redColor]
                     range:[fullName.lowercaseString rangeOfString:searchText.lowercaseString]];
        
        self.titleLabel.attributedText = text;
    }
}

#pragma mark - Actions

- (IBAction)pressAddBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(friendListCell:pressAddBtn:)]) {
        [self.delegate friendListCell:self pressAddBtn:sender];
    }
}

@end
