//
//  AUser.h
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AObject.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef enum {
    AUserTypeUnknown = 0,
    AUserTypePerson = 1,
    AUserTypeCompany = 2
} AUserType;

@interface AUser : AObject <MKAnnotation>

@property (nonatomic) int userID;
@property (nonatomic) AUserType userType;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userInfo;
@property (nonatomic, strong) NSString *userAvatarPath;
@property (nonatomic, strong) NSString *userUsername;
@property (nonatomic, assign) BOOL followingUser;
@property (nonatomic, assign) BOOL pnOn;

//when userType == AUserTypeCompany
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *companyAddress;
@property (nonatomic, strong) NSString *companyPhone;
@property (nonatomic, strong) NSString *companyWeb;
@property (nonatomic, strong) NSString *companyEmail;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic) int followersCount;
@property (nonatomic) int followingCount;

@property (nonatomic) int myPostsCount;
@property (nonatomic) int myGuessesCount;
@property (nonatomic) int myScoreCount;

- (id)initWithDictionary:(NSDictionary*)userWithInfo;


@end
