//
//  ALike.m
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "ALike.h"

@implementation ALike

//Initializes ALike object from NSDictionary that was created by JSON parsing.
- (id)initWithDictionary:(NSDictionary*)likeWithInfo {
    self = [self init];
    if (self) {
        
        _likeID = [self integerFromDictionary:likeWithInfo forKey:@"likeID"];
        NSDictionary *rawUser = [self dictionaryFromDictionary:likeWithInfo forKey:@"user"];
        _user = [[AUser alloc] initWithDictionary:rawUser];
    }
    
    return self;
}

@end
