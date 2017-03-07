//
//  AGuess.h
//  Alibi
//
//  Created by AnMac on 6/27/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import "AObject.h"
#import "AUser.h"
#import "APost.h"

@interface AGuess : AObject

@property (nonatomic) int guessID;
@property (nonatomic, strong) NSString *guessTimeAgo;
@property (nonatomic, strong) NSDate *guessDate;
@property (nonatomic, strong) AUser *guessingUser;
@property (nonatomic, strong) APost *guessPost;
@property (nonatomic, strong) AUser *guessedUser;

- (id)initWithDictionary:(NSDictionary*)guessWithInfo;

@end
