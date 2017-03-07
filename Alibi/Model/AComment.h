//
//  AComment.h
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AObject.h"
#import "AUser.h"

@interface AComment : AObject

@property (nonatomic) int commentID;
@property (nonatomic, strong) NSString *commentText;
@property (nonatomic, strong) NSString *commentTimeAgo;
@property (nonatomic, strong) NSDate *commentDate;
@property (nonatomic, strong) AUser *user;

- (id)initWithDictionary:(NSDictionary*)commentWithInfo;

@end
