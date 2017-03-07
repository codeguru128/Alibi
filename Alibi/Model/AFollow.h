//
//  AFollow.h
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AObject.h"
#import "AUser.h"

@interface AFollow : AObject

@property (nonatomic) int followID;
@property (nonatomic, strong) NSDate *followDate;
@property (nonatomic, strong) AUser *follower;
@property (nonatomic, strong) AUser *following;

- (id)initWithDictionary:(NSDictionary*)followWithInfo;

@end
