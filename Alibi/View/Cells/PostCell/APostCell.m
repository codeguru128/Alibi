//
//  APostCell.m
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "APostCell.h"
#import "AConnect.h"

static APostCell *sharedCell = nil;

@implementation APostCell

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    frameDefaultLabelPostTitle = self.labelPostTitle.frame;
    //frameDefaultImageViewPost = self.imageViewPostImage.frame;
}


#pragma mark - Cell methods

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateFramesAndDataWithDownloads:YES];
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    self.labelPostTitle.frame = frameDefaultLabelPostTitle;
}

+ (CGSize)sizeWithPost:(APost*)post :(UITableView *)tableView {
    
    if (!sharedCell) {
        sharedCell = [tableView dequeueReusableCellWithIdentifier:@"APostCell"];
//        sharedCell = [[[NSBundle mainBundle] loadNibNamed:@"APostCell" owner:nil options:nil] lastObject];
    }
    [sharedCell prepareForReuse];
    sharedCell.post = post;
    [sharedCell updateFramesAndDataWithDownloads:NO];
    
    CGSize size = CGSizeMake(sharedCell.frame.size.width, CGRectGetMaxY(sharedCell.mainView.frame) + 5);
    
    return size;
}

- (void)updateFramesAndDataWithDownloads:(BOOL)downloads {
    
    if (self.post) {
        
        //UI
        self.backgroundColor = MAIN_BACK_COLOR;
        
     /*CALayer *layer = self.mainView.layer;
        layer.cornerRadius = 10;
        [layer setMasksToBounds: YES]; */
        
        self.buttonGuess.layer.cornerRadius = 3;
        self.buttonGuess.clipsToBounds = YES;
        
        //Set
        self.labelUserName.text = self.post.user.userUsername;
        self.labelTimeAgo.text = self.post.postTimeAgo;
        self.labelPostTitle.text = self.post.postTitle;
        
        if (self.post.likedThisPost) {
            [self.buttonLike setImage:[UIImage imageNamed:@"like_on.png"] forState:UIControlStateNormal];
        } else {
            [self.buttonLike setImage:[UIImage imageNamed:@"like_off.png"] forState:UIControlStateNormal];
        }
        
        [self.buttonLike setTitle:[NSString stringWithFormat:@"%d", self.post.postLikesCount] forState:UIControlStateNormal];
        [self.buttonComment setTitle:[NSString stringWithFormat:@"%d", self.post.postCommentsCount] forState:UIControlStateNormal];
        [self.buttonRightGuess setTitle:[NSString stringWithFormat:@"%d", self.post.postRightGuessCount] forState:UIControlStateNormal];
        [self.buttonWrongGuess setTitle:[NSString stringWithFormat:@"%d", self.post.postWrongGuessCount] forState:UIControlStateNormal];
        
        self.buttonGuess.layer.borderWidth = 0;
        [self.buttonGuess setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.buttonGuess setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 0.0f)];
        
        if(self.post.iGuessedRightWrong == 1){
            [self.buttonGuess setTitle:@"Guessed" forState:UIControlStateNormal];
            [self.buttonGuess setImage:[UIImage imageNamed:@"o"] forState:UIControlStateNormal];
            self.buttonGuess.backgroundColor = RGB(143, 209, 158);
            
            self.labelUserName.hidden = NO;
            self.labelPostTitle.frame = CGRectMake(self.labelUserName.frame.origin.x, self.labelUserName.frame.origin.y + 18, self.labelPostTitle.frame.size.width, self.labelPostTitle.frame.size.height);
        }
        else if(self.post.iGuessedRightWrong == -1){
            [self.buttonGuess setTitle:@"Guessed" forState:UIControlStateNormal];
            [self.buttonGuess setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
            self.buttonGuess.backgroundColor = RGB(232, 119, 136);
            
            self.labelUserName.hidden = YES;
            self.labelPostTitle.frame = CGRectMake(self.labelUserName.frame.origin.x, self.labelUserName.frame.origin.y, self.labelPostTitle.frame.size.width, self.labelPostTitle.frame.size.height);
        }
        else{
            if([AConnect sharedConnect].currentUser && self.post.user.userID == [AConnect sharedConnect].currentUser.userID){
                [self.buttonGuess setTitle:@"Remove" forState:UIControlStateNormal];
                self.buttonGuess.backgroundColor = [UIColor clearColor];
                self.buttonGuess.layer.borderColor = MAIN_BACK_COLOR.CGColor;
                self.buttonGuess.layer.borderWidth = 1;
                [self.buttonGuess setTitleColor:MAIN_BACK_COLOR forState:UIControlStateNormal];
                [self.buttonGuess setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, -8.0f, 0.0f, 0.0f)];
                
                self.labelUserName.hidden = YES;
                self.labelPostTitle.frame = CGRectMake(self.labelUserName.frame.origin.x, self.labelUserName.frame.origin.y, self.labelPostTitle.frame.size.width, self.labelPostTitle.frame.size.height);
            }
            else{
                [self.buttonGuess setTitle:@"Guess" forState:UIControlStateNormal];
                [self.buttonGuess setImage:[UIImage imageNamed:@"guess"] forState:UIControlStateNormal];
                self.buttonGuess.backgroundColor = RGB(208, 210, 211);
                
                self.labelUserName.hidden = YES;
                self.labelPostTitle.frame = CGRectMake(self.labelUserName.frame.origin.x, self.labelUserName.frame.origin.y, self.labelPostTitle.frame.size.width, self.labelPostTitle.frame.size.height);
            }
        }
        
        //Resize
        [self.labelPostTitle sizeToFit];
        if (self.labelPostTitle.frame.size.width < frameDefaultLabelPostTitle.size.width) {
            self.labelPostTitle.frame = CGRectMake(self.labelPostTitle.frame.origin.x, self.labelPostTitle.frame.origin.y, frameDefaultLabelPostTitle.size.width, self.labelPostTitle.frame.size.height);
        }
        if (self.labelPostTitle.frame.size.height < frameDefaultLabelPostTitle.size.height) {
            self.labelPostTitle.frame = CGRectMake(self.labelPostTitle.frame.origin.x, self.labelPostTitle.frame.origin.y, self.labelPostTitle.frame.size.width, frameDefaultLabelPostTitle.size.height);
        }
        //Set and resize done
        CGFloat offset = 5;
        
        self.imageClock.frame = CGRectMake(self.imageClock.frame.origin.x, CGRectGetMaxY(self.labelPostTitle.frame) + offset, self.imageClock.frame.size.width, self.imageClock.frame.size.height);
        self.labelTimeAgo.frame = CGRectMake(self.labelTimeAgo.frame.origin.x, CGRectGetMaxY(self.labelPostTitle.frame) + offset - (_labelTimeAgo.frame.size.height - _imageClock.frame.size.height)/2, self.labelTimeAgo.frame.size.width, self.labelTimeAgo.frame.size.height);
        
        offset = 10;
        
        self.buttonLike.frame = CGRectMake(self.buttonLike.frame.origin.x, CGRectGetMaxY(self.labelTimeAgo.frame) + offset, self.buttonLike.frame.size.width, self.buttonLike.frame.size.height);
        self.buttonComment.frame = CGRectMake(self.buttonComment.frame.origin.x, CGRectGetMaxY(self.labelTimeAgo.frame) + offset, self.buttonComment.frame.size.width, self.buttonComment.frame.size.height);
        self.buttonRightGuess.center = CGPointMake(self.buttonRightGuess.center.x, self.buttonLike.center.y);
        self.buttonWrongGuess.center = CGPointMake(self.buttonWrongGuess.center.x, self.buttonLike.center.y);
        self.buttonGuess.center = CGPointMake(self.buttonGuess.center.x, self.buttonLike.center.y);
        
        self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y, self.mainView.frame.size.width, CGRectGetMaxY(self.buttonGuess.frame) + 8);
        
        if(![self.contentView viewWithTag:200] && self.isPostCellForComments){
            UIView *viewBorder = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.mainView.frame)-8, self.mainView.frame.size.width, 15)];
            viewBorder.tag = 200;
            viewBorder.backgroundColor = [UIColor whiteColor];
            UIImageView *imageBorder = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"dotted_line"]];
            imageBorder.frame = CGRectMake(0, 13, self.mainView.frame.size.width, 2);
            //        imageBorder.contentMode = UIViewContentModeScaleAspectFit;
            [viewBorder addSubview:imageBorder];
            [self.contentView addSubview:viewBorder];
        }
    }
}


#pragma mark - Action methods

- (IBAction)buttonUserTouchUpInside:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(showUser:sender:)]) {
        [self.delegate showUser:self.post.user sender:self];
    }
}

- (IBAction)buttonPostTouchUpInside:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(showImageForPost:sender:)] && self.post.postImagePath.length) {
        [self.delegate showImageForPost:self.post sender:self];
    }
}

- (IBAction)buttonLikeTouchUpInside:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(toggleLikeForPost:sender:)]) {
        [self.delegate toggleLikeForPost:self.post sender:self];
    }
}

- (IBAction)buttonCommentTouchUpInside:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(showCommentsForPost:sender:)]) {
        [self.delegate showCommentsForPost:self.post sender:self];
    }
}

- (IBAction)buttonGuessTouchUpInside:(id)sender {
    if([self.buttonGuess.titleLabel.text isEqualToString:@"Remove"]){
        if ([self.delegate respondsToSelector:@selector(toggleDeletePost:sender:)]) {
            [self.delegate toggleDeletePost:self.post sender:self];
        }
    }
    else if(self.post.iGuessedRightWrong == 0){
        if ([self.delegate respondsToSelector:@selector(goGuessForPost:sender:)]) {
            [self.delegate goGuessForPost:self.post sender:self];
        }
    }
    else{
        ALERT(@"", @"You already guessed this post");
    }
}

//- (IBAction)buttonLikesTouchUpInside:(id)sender {
//    
//    if ([self.delegate respondsToSelector:@selector(showLikesForPost:sender:)]) {
//        [self.delegate showLikesForPost:self.post sender:self];
//    }
//}

@end
