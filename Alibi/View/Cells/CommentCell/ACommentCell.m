//
//  ACommentCell.m
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "ACommentCell.h"
#import "UIImageView+AFNetworking.h"

static ACommentCell *sharedCell = nil;

@implementation ACommentCell

#pragma mark - Object lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    frameDefaultLabelCommentText = self.labelCommentTtext.frame;
    //frameDefaultImageViewPost = self.imageViewPostImage.frame;
    
    self.imageViewUser.layer.cornerRadius = self.imageViewUser.frame.size.height/2;
    self.imageViewUser.layer.masksToBounds = YES;
}


#pragma mark - Cell methods

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateFramesAndDataWithDownloads:YES];
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    [self.imageViewUser cancelImageRequestOperation];
    self.labelCommentTtext.frame = frameDefaultLabelCommentText;
}

+ (CGSize)sizeWithComment:(AComment *)comment :(UITableView *)tableView {
    
    if (!sharedCell) {
        sharedCell = [tableView dequeueReusableCellWithIdentifier:@"ACommentCell"];
    }
    [sharedCell prepareForReuse];
    sharedCell.comment = comment;
    [sharedCell updateFramesAndDataWithDownloads:NO];
    
    return CGSizeMake(sharedCell.frame.size.width, CGRectGetMaxY(sharedCell.mainView.frame) + 1.0f);
}

- (void)updateFramesAndDataWithDownloads:(BOOL)downloads {
    
    if (self.comment && ![self.comment isEqual:[NSNull null]]) {
        
        if (downloads) {
            [self.imageViewUser setImageWithURL:[NSURL URLWithString:self.comment.user.userAvatarPath]];
        }
        
        //UI
        self.backgroundColor = MAIN_BACK_COLOR;
        
        self.buttonDot.layer.cornerRadius = self.buttonDot.layer.frame.size.width/2;
        self.buttonDot.clipsToBounds = YES;
        self.buttonDot.backgroundColor = RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
        
        self.labelUsername.text = self.comment.user.userUsername;
        self.labelTimeAgo.text = self.comment.commentTimeAgo;
        
        //Set and resize
        self.labelCommentTtext.text = self.comment.commentText;
        [self.labelCommentTtext sizeToFit];
        if (self.labelCommentTtext.frame.size.width < frameDefaultLabelCommentText.size.width) {
            self.labelCommentTtext.frame = CGRectMake(self.labelCommentTtext.frame.origin.x, self.labelCommentTtext.frame.origin.y, frameDefaultLabelCommentText.size.width, self.labelCommentTtext.frame.size.height);
        }
        if (self.labelCommentTtext.frame.size.height < frameDefaultLabelCommentText.size.height) {
            self.labelCommentTtext.frame = CGRectMake(self.labelCommentTtext.frame.origin.x, self.labelCommentTtext.frame.origin.y, self.labelCommentTtext.frame.size.width, frameDefaultLabelCommentText.size.height);
        }
        
        CGFloat offset = 5;
        self.labelUsername.frame = CGRectMake(self.labelUsername.frame.origin.x, CGRectGetMaxY(self.labelCommentTtext.frame) + offset, self.labelUsername.frame.size.width, self.labelUsername.frame.size.height);
        self.labelTimeAgo.frame = CGRectMake(self.labelTimeAgo.frame.origin.x, CGRectGetMaxY(self.labelCommentTtext.frame) + offset, self.labelTimeAgo.frame.size.width, self.labelTimeAgo.frame.size.height);
        
        self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y, self.mainView.frame.size.width, CGRectGetMaxY(self.labelTimeAgo.frame) + 10);
        
        self.buttonDot.center = CGPointMake(10, self.mainView.frame.size.height/2);
        //Set and resize done
    }
}


#pragma mark - Action methods

- (IBAction)buttonUserTouchUpInside:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(showUser:sender:)]) {
        [self.delegate showUser:self.comment.user sender:self];
    }
}

@end
