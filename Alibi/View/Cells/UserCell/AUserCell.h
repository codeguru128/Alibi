//
//  AUserCell.h
//  Alibi
//
//  Created by Matias Willand on 07/01/14.
//  Copyright (c) 2014 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUser.h"
#import "ATableViewCell.h"

@interface AUserCell : ATableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewUserImage;
@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UIButton *buttonFollowUnfollow;

@property (strong, nonatomic) AUser *user;
@property (weak, nonatomic) id<ACellDelegate> delegate;

- (IBAction)buttonFollowUnfollowTouchUpInside:(UIButton *)sender;

@end
