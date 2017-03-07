//
//  AGuess.m
//  Alibi
//
//  Created by AnMac on 6/27/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import "AGuess.h"

@implementation AGuess

//Initializes AGuess object from NSDictionary that was created by JSON parsing.
- (id)initWithDictionary:(NSDictionary*)guessWithInfo {
    self = [self init];
    if (self) {
        
        _guessID = [self integerFromDictionary:guessWithInfo forKey:@"guessID"];
        _guessTimeAgo = [self stringFromDictionary:guessWithInfo forKey:@"timeAgo"];
        _guessDate = [self dateFromDictionary:guessWithInfo forKey:@"guessDate"];
        
        NSDictionary *guessingUser = [self dictionaryFromDictionary:guessWithInfo forKey:@"guessingUser"];
        _guessingUser = [[AUser alloc] initWithDictionary:guessingUser];
        
        NSDictionary *guessedUser = [self dictionaryFromDictionary:guessWithInfo forKey:@"guessedUser"];
        _guessedUser = [[AUser alloc] initWithDictionary:guessedUser];
        
        NSDictionary *guessPost = [self dictionaryFromDictionary:guessWithInfo forKey:@"guessPost"];
        _guessPost = [[APost alloc] initWithDictionary:guessPost];
    }
    
    return self;
}

@end
