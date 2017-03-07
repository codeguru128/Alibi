//
//  ACommentCell.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AComment.h"
#import "ATableViewCell.h"

@interface ACommentCell : ATableViewCell {
    
    CGRect frameDefaultLabelCommentText;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *buttonDot;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewUser;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UILabel *labelTimeAgo;
@property (strong, nonatomic) IBOutlet UILabel *labelCommentTtext;

@property (strong, nonatomic) AComment *comment;
@property (weak, nonatomic) id<ACellDelegate> delegate;

- (IBAction)buttonUserTouchUpInside:(id)sender;
+ (CGSize)sizeWithComment:(AComment *)comment :(UITableView *)tableView;

@end
