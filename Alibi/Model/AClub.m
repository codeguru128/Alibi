//
//  AClub.m
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AClub.h"

@implementation AClub

- (id)initWithDictionary:(NSDictionary*)clubWithInfo {
   
    self = [self init];
    if (self) {
        _clubID = [self integerFromDictionary:clubWithInfo forKey:@"clubID"];
        _clubName = [self stringFromDictionary:clubWithInfo forKey:@"clubName"];
        _clubPasscode = [self stringFromDictionary:clubWithInfo forKey:@"passcode"];
    }
    
    return self;
}


#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeInt:self.clubID forKey:@"clubID"];
    [encoder encodeObject:self.clubName forKey:@"clubName"];
    [encoder encodeObject:self.clubPasscode forKey:@"clubPasscode"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    if (self) {
        self.clubID = [decoder decodeIntForKey:@"clubID"];
        self.clubName = [decoder decodeObjectForKey:@"clubName"];
        self.clubPasscode = [decoder decodeObjectForKey:@"passcode"];
    }
    return self;
}


@end
