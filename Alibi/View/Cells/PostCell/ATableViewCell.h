//
//  ATableViewCell.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUser.h"
#import "APost.h"

@class ATableViewCell;

@protocol ACellDelegate <NSObject>

- (void)showUser:(AUser*)user sender:(id)senderCell;
- (void)showImageForPost:(APost*)post sender:(id)senderCell;
- (void)toggleLikeForPost:(APost*)post sender:(id)senderCell;
- (void)toggleDeletePost:(APost*)post sender:(id)senderCell;
- (void)showCommentsForPost:(APost*)post sender:(id)senderCell;
- (void)goGuessForPost:(APost*)post sender:(id)senderCell;
- (void)showGuessForPost:(APost*)post sender:(id)senderCell;
- (void)showLikesForPost:(APost *)post sender:(id)senderCell;
- (void)followUser:(AUser *)user sender:(id)senderCell;
- (void)unfollowUser:(AUser *)user sender:(id)senderCell;

@end

@interface ATableViewCell : UITableViewCell

@end
