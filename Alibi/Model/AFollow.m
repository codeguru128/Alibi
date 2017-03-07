//
//  AFollow.m
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AFollow.h"

@implementation AFollow

//Initializes AFollow object from NSDictionary that was created by JSON parsing.
- (id)initWithDictionary:(NSDictionary*)followWithInfo {
    self = [self init];
    if (self) {
        
        _followID = [self integerFromDictionary:followWithInfo forKey:@"followID"];
        _followDate = [self dateFromDictionary:followWithInfo forKey:@"followDate"];
        NSDictionary *rawFollower = [self dictionaryFromDictionary:followWithInfo forKey:@"follower"];
        _follower = [[AUser alloc] initWithDictionary:rawFollower];
        NSDictionary *rawFollowing = [self dictionaryFromDictionary:followWithInfo forKey:@"following"];
        _following = [[AUser alloc] initWithDictionary:rawFollowing];
    }
    
    return self;
}

@end
