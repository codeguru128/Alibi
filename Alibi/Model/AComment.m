//
//  AComment.m
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AComment.h"

@implementation AComment

//Initializes AComment object from NSDictionary that was created by JSON parsing.
- (id)initWithDictionary:(NSDictionary*)commentWithInfo {
    self = [self init];
    if (self) {
        
        _commentID = [self integerFromDictionary:commentWithInfo forKey:@"commentID"];
        _commentText = [self stringFromDictionary:commentWithInfo forKey:@"commentText"];
        _commentTimeAgo = [self stringFromDictionary:commentWithInfo forKey:@"timeAgo"];
        _commentDate = [self dateFromDictionary:commentWithInfo forKey:@"commentDate"];
        
        NSDictionary *rawUser = [self dictionaryFromDictionary:commentWithInfo forKey:@"user"];
        _user = [[AUser alloc] initWithDictionary:rawUser];
    }
    
    return self;
}

@end
