//
//  QMApi+Users.m
//  Qmunicate
//
//  Created by Andrey on 03.07.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMApi.h"
#import "QMUsersService.h"


@implementation QMApi (Users)

- (void)retrieveUsersWithIDs:(NSArray *)idsToFetch completion:(void(^)(BOOL updated))completion {
    
    NSArray *filteredIDs = [self checkExistIds:idsToFetch];
    
    if (filteredIDs.count == 0) {
        completion(NO);
    } else {
        
        PagedRequest *pagedRequest = [[PagedRequest alloc] init];
        pagedRequest.page = 1;
        pagedRequest.perPage = filteredIDs.count < 100 ? filteredIDs.count : 100;
        
        __weak __typeof(self)weakSelf = self;
        [self.usersService retrieveUsersWithIDs:filteredIDs pagedRequest:pagedRequest completion:^(QBUUserPagedResult *pagedResult) {
            [weakSelf addUsers:pagedResult.users];
            completion(YES);
        }];
    }
}

- (void)retrieveFriendsIfNeeded:(void(^)(BOOL updated))completion {
    
    NSArray *friendsIDs = [self idsFromContactListItems];
    [self retrieveUsersWithIDs:friendsIDs completion:completion];
}

- (void)retrieveUsersForChatDialog:(QBChatDialog *)chatDialog completion:(void(^)(BOOL updated))completion {
    
    [self retrieveUsersWithIDs:chatDialog.occupantIDs completion:completion];
}

- (BOOL)addUserToContactListRequest:(NSUInteger)userID {
    
    BOOL success = [[QBChat instance] addUserToContactListRequest:userID];
    return success;
}

- (BOOL)removeUserFromContactListWithUserID:(NSUInteger)userID {
    
    BOOL success = [[QBChat instance] removeUserFromContactList:userID];
    return success;
}

- (BOOL)confirmAddContactRequest:(NSUInteger)userID {
    
    BOOL success = [[QBChat instance] confirmAddContactRequest:userID];
    return success;
}

- (BOOL)rejectAddContactRequest:(NSUInteger)userID {
    
    BOOL success =[[QBChat instance] rejectAddContactRequest:userID];
    return success;
}

/**
 @param QBUUser ID
 @return QBContactListItem from chaced contactList
 */

- (QBContactListItem *)contactItemWithUserID:(NSUInteger)userID {
    
    NSArray *contacts = self.usersService.contactList;
    for (QBContactListItem *item in contacts) {
        if (item.userID == userID) {
            return item;
        }
    }
    
    return nil;
}

- (NSArray *)checkExistIds:(NSArray *)ids {
    
    NSMutableSet *idsToFetch = [NSMutableSet setWithArray:ids];
    for (NSString *userID in ids) {
        
        QBUUser *user = self.usersService.users[userID];
        if (user) {
            [idsToFetch removeObject:userID];
        }
    }
    
    return [idsToFetch allObjects];
}

- (NSArray *)idsWithUsers:(NSArray *)users {

    NSMutableSet *ids = [NSMutableSet set];
    for (QBUUser *user in users) {
        NSString *userID = [NSString stringWithFormat:@"%d", user.ID];
        [ids addObject:userID];
    }
    return [ids allObjects];
}

- (NSArray *)idsFromContactListItems {
    
    NSMutableArray *idsToFetch = [NSMutableArray new];
    NSArray *contactListItems = self.usersService.contactList;
    
    for (QBContactListItem *item in contactListItems) {
        NSString *stringID = [NSString stringWithFormat:@"%d", item.userID];
        [idsToFetch addObject:stringID];
    }
    
    return idsToFetch;
}

- (NSArray *)contactListItemsWithContactList:(QBContactList *)contactList {
    
    NSUInteger count = contactList.pendingApproval.count + contactList.contacts.count;
    NSMutableArray *contactListItems = [NSMutableArray arrayWithCapacity:count];
    [contactListItems addObjectsFromArray:contactList.contacts];
    [contactListItems addObjectsFromArray:contactList.pendingApproval];
    
    return contactListItems;
}

- (void)addUsers:(NSArray *)users {
    
    for (QBUUser *user in users) {
        [self addUser:user];
    }
}

- (void)addUser:(QBUUser *)user {
    
    NSString *key = [NSString stringWithFormat:@"%d", user.ID];
    self.usersService.users[key] = user;
}

- (QBUUser *)userWithID:(NSUInteger)userID {
    
    NSString *stingID = [NSString stringWithFormat:@"%d", userID];
    QBUUser *user = self.usersService.users[stingID];
    
    return user;
}

- (NSArray *)friends {
    
    NSArray *ids = [self idsFromContactListItems];
    NSMutableArray *allFriends = [NSMutableArray array];
    
    for (NSString * friendID in ids) {
        QBUUser *user = self.usersService.users[friendID];
        if (user) {
            [allFriends addObject:user];
        }
    }
    
    return allFriends;
}

@end
