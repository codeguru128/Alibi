//
//  AClub.h
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AObject.h"

@interface AClub : AObject

@property (nonatomic) int clubID;
@property (nonatomic, strong) NSString *clubName;
@property (nonatomic, strong) NSString *clubPasscode;

- (id)initWithDictionary:(NSDictionary*)clubWithInfo;

@end
