//
//  APost.h
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AObject.h"
#import "AUser.h"

@interface APost : AObject

@property (nonatomic) int postID;
@property (nonatomic, strong) NSString *postTitle;
@property (nonatomic, strong) NSString *postImagePath;
@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic, strong) NSString *postTimeAgo;
@property (nonatomic, strong) NSMutableArray *postKeywords;
@property (nonatomic, strong) AUser *user;
@property (nonatomic) int postLikesCount;
@property (nonatomic) int postCommentsCount;
@property (nonatomic) int postRightGuessCount;
@property (nonatomic) int postWrongGuessCount;
@property (nonatomic) int iGuessedRightWrong;
@property (nonatomic) BOOL likedThisPost;
@property (nonatomic) BOOL commentedThisPost;

- (id)initWithDictionary:(NSDictionary*)postWithInfo;

@end
