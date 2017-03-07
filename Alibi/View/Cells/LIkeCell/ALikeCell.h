//
//  ALikeCell.h
//  Alibi
//
//  Created by Matias Willand on 21/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATableViewCell.h"
#import "ALike.h"

@interface ALikeCell : ATableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewUser;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;

@property (assign, nonatomic) id<ACellDelegate> delegate;
@property (strong, nonatomic) ALike *like;

- (IBAction)buttonUserTouchUpInside:(id)sender;
+ (CGSize)sizeWithLike:(ALike *)like;

@end
