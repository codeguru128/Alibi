//
//  APostCollectionViewCell.h
//  Alibi
//
//  Created by Matias Willand on 21/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APost.h"
#import "ATableViewCell.h"

@interface APostCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewPost;

@property (strong, nonatomic) APost *post;
@property (weak, nonatomic) id<ACellDelegate> delegate;

@end
