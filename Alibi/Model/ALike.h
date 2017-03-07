//
//  ALike.h
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AObject.h"
#import "AUser.h"

@interface ALike : AObject

@property (nonatomic) int likeID;
@property (nonatomic, strong) AUser *user;

- (id)initWithDictionary:(NSDictionary*)likeWithInfo;

@end
