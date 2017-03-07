//
//  APost.m
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "APost.h"

@implementation APost

- (id)initWithDictionary:(NSDictionary*)postWithInfo {

    self = [self init];
    if (self) {
        _postID = [self integerFromDictionary:postWithInfo forKey:@"postID"];
        _postTitle = [self stringFromDictionary:postWithInfo forKey:@"postTitle"];
        _postImagePath = [self stringFromDictionary:postWithInfo forKey:@"postImage"];
        _postDate = [self dateFromDictionary:postWithInfo forKey:@"postDate"];
        _postTimeAgo = [self stringFromDictionary:postWithInfo forKey:@"timeAgo"];
        NSDictionary *rawUser = [self dictionaryFromDictionary:postWithInfo forKey:@"user"];
        _user = [[AUser alloc] initWithDictionary:rawUser];
        _postLikesCount = [self integerFromDictionary:postWithInfo forKey:@"totalLikes"];
        _postCommentsCount = [self integerFromDictionary:postWithInfo forKey:@"totalComments"];
        _postRightGuessCount = [self integerFromDictionary:postWithInfo forKey:@"rightGuess"];
        _postWrongGuessCount = [self integerFromDictionary:postWithInfo forKey:@"wrongGuess"];
        _likedThisPost = [self boolFromDictionary:postWithInfo forKey:@"isLiked"];
        _commentedThisPost = [self boolFromDictionary:postWithInfo forKey:@"isCommented"];
        
        if([self boolFromDictionary:postWithInfo forKey:@"iGuessedRight"]){
            _iGuessedRightWrong = 1;
        }
        else if([self boolFromDictionary:postWithInfo forKey:@"iGuessedWrong"]){
            _iGuessedRightWrong = -1;
        }
        else{
            _iGuessedRightWrong = 0;
        }
    }
    
    return self;
}

@end
