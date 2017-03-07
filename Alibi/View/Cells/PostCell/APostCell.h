//
//  APostCell.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "ATableViewCell.h"
#import "APost.h"
#import "UIImageView+AFNetworking.h"

@class APostCell;

@interface APostCell : ATableViewCell {
    
    CGRect frameDefaultLabelPostTitle;
    CGRect frameDefaultImageViewPost;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UIImageView *imageClock;
@property (strong, nonatomic) IBOutlet UILabel *labelTimeAgo;
@property (strong, nonatomic) IBOutlet UILabel *labelPostTitle;
@property (strong, nonatomic) IBOutlet UIButton *buttonLike;
//@property (strong, nonatomic) IBOutlet UIButton *buttonLikes;
@property (strong, nonatomic) IBOutlet UIButton *buttonComment;
@property (strong, nonatomic) IBOutlet UIButton *buttonRightGuess;
@property (strong, nonatomic) IBOutlet UIButton *buttonWrongGuess;
@property (strong, nonatomic) IBOutlet UIButton *buttonGuess;

@property (strong, nonatomic) APost *post;
@property (nonatomic) BOOL isPostCellForComments;
@property (weak, nonatomic) id<ACellDelegate> delegate;

- (IBAction)buttonUserTouchUpInside:(id)sender;
- (IBAction)buttonPostTouchUpInside:(id)sender;
- (IBAction)buttonLikeTouchUpInside:(id)sender;
- (IBAction)buttonCommentTouchUpInside:(id)sender;
- (IBAction)buttonGuessTouchUpInside:(id)sender;
- (IBAction)buttonDeleteTouchUpInside:(id)sender;
//- (IBAction)buttonLikesTouchUpInside:(id)sender;

+ (CGSize)sizeWithPost:(APost*)post :(UITableView *)tableView;


@end
