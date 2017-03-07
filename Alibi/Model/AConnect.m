//
//  AConnect.m
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AConnect.h"

#define kBaseLink @"https://api.alibichat.com/alibi/"
//#define kAPIKey @"!#wli!sdWQDScxzczFžŽYewQsq_?wdX09612627364[3072∑34260-#"
#define kConnectionTimeout 30
#define kCompressionQuality 1.0f

//Server status responses
#define kOK @"OK"
#define kBAD_REQUEST @"BAD_REQUEST"
#define kNO_CONNECTION @"NO_CONNECTION"
#define kSERVICE_UNAVAILABLE @"SERVICE_UNAVAILABLE"
#define kPARTIAL_CONTENT @"PARTIAL_CONTENT"
#define kCONFLICT @"CONFLICT"
#define kUNAUTHORIZED @"UNAUTHORIZED"
#define kNOT_FOUND @"NOT_FOUND"
#define kUSER_CREATED @"USER_CREATED"
#define kUSER_EXISTS @"USER_EXISTS"
#define kLIKE_CREATED @"LIKE_CREATED"
#define kLIKE_EXISTS @"LIKE_EXISTS"
#define kFORBIDDEN @"FORBIDDEN"
#define kCREATED @"CREATED"


@implementation AConnect

static AConnect *sharedConnect;

+ (AConnect*) sharedConnect {
    
    if (sharedConnect != nil) {
        return sharedConnect;
    }
    sharedConnect = [[AConnect alloc] init];
    return sharedConnect;
}

- (id)init {
    self = [super init];
    
    // comment for user persistance
    // [self removeCurrentUser];
    
    if (self) {
        httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseLink]];
//        [httpClient.requestSerializer setValue:kAPIKey forHTTPHeaderField:@"api_key"];
        httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
        json = [[SBJsonParser alloc] init];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _dateOnlyFormatter = [[NSDateFormatter alloc] init];
        [_dateOnlyFormatter setDateFormat:@"MM/dd/yyyy"];
        [_dateOnlyFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        
        NSData *archivedUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"_currentUser"];
        if (archivedUser) {
            _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedUser];
        }
        
        NSData *archivedClub = [[NSUserDefaults standardUserDefaults] objectForKey:@"_currentClub"];
        if (archivedClub) {
            _currentClub = [NSKeyedUnarchiver unarchiveObjectWithData:archivedClub];
        }
    }
    return self;
}

- (void)saveCurrentUser {
    
    if (self.currentUser) {
        NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:_currentUser];
        [[NSUserDefaults standardUserDefaults] setObject:archivedUser forKey:@"_currentUser"];
    }
}

- (void)saveCurrentClub {
    
    if (self.currentClub) {
        NSData *archivedClub = [NSKeyedArchiver archivedDataWithRootObject:_currentClub];
        [[NSUserDefaults standardUserDefaults] setObject:archivedClub forKey:@"_currentClub"];
    }
}

- (void)removeCurrentUser {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_currentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeCurrentClub{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"_currentClub"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - User

- (void)loginUserWithUsername:(NSString*)username andPassword:(NSString*)password onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion {
    
    if (!username.length || !password.length) {
        completion(nil, BAD_REQUEST);
    } else {
	        NSDictionary *parameters = @{@"username": username, @"password": password};
        [httpClient POST:@"api/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rawUser = [responseObject objectForKey:@"item"];
            _currentUser = [[AUser alloc] initWithDictionary:rawUser];
            
            [self saveCurrentUser];
            
            [self debugger:parameters.description methodLog:@"api/login" dataLogFormatted:responseObject];
            completion(_currentUser, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/login" dataLog:error.description];
            if (operation.response) {
                completion(nil, operation.response.statusCode);
            } else {
                completion(nil, NO_CONNECTION);
            }
        }];
    }
}

- (void)loginUserWithInstagram:(NSString*)InstagramUserId ProfilePictureURL:(NSString*)ProfilePictureURL onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion {
    
    if (!InstagramUserId.length) {
        completion(nil, BAD_REQUEST);
    } else {
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"];
        if(!deviceToken)
            deviceToken = @"";
        NSDictionary *parameters = @{@"InstagramUserId": InstagramUserId, @"device_token": deviceToken, @"ProfilePictureURL": ProfilePictureURL};
        [httpClient POST:@"api/loginWithInstagram" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rawUser = [responseObject objectForKey:@"item"];
            _currentUser = [[AUser alloc] initWithDictionary:rawUser];
            
            [self saveCurrentUser];
            
            [self debugger:parameters.description methodLog:@"api/loginWithInstagram" dataLogFormatted:responseObject];
            completion(_currentUser, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/loginWithInstagram" dataLog:error.description];
            if (operation.response) {
                completion(nil, operation.response.statusCode);
            } else {
                completion(nil, NO_CONNECTION);
            }
        }];
    }
}

- (void)registerUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email userAvatar:(UIImage*)userAvatar userType:(int)userType userFullName:(NSString*)userFullName userInfo:(NSString*)userInfo latitude:(float)latitude longitude:(float)longitude companyAddress:(NSString*)companyAddress companyPhone:(NSString*)companyPhone companyWeb:(NSString*)companyWeb instagramUserId:(NSString *)instagramUserId instagramUsername:(NSString *)instagramUsername onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion {
    
    if (!username.length) {
        completion(nil, BAD_REQUEST);
    } else {
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"];
        NSDictionary *parameters = @{@"username" : username, @"password" : password, @"email" : email, @"userFullname" : userFullName, @"userTypeID" : @(userType), @"userInfo" : userInfo, @"userLat" : @(latitude), @"userLong" : @(longitude), @"userAddress" : companyAddress, @"userPhone" : companyPhone, @"userWeb" : companyWeb, @"instagram_userid":instagramUserId, @"instagram_username":instagramUsername, @"device_token": deviceToken};
        [httpClient POST:@"api/register" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (userAvatar) {
                NSData *imageData = UIImageJPEGRepresentation(userAvatar, kCompressionQuality);
                if (imageData) {
                    [formData appendPartWithFileData:imageData name:@"userAvatar" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rawUser = [responseObject objectForKey:@"item"];
            _currentUser = [[AUser alloc] initWithDictionary:rawUser];
            [self saveCurrentUser];
            [self debugger:parameters.description methodLog:@"api/register" dataLogFormatted:responseObject];
            completion(_currentUser, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/register" dataLog:error.description];
            if (operation.response) {
                completion(nil, operation.response.statusCode);
            } else {
                completion(nil, NO_CONNECTION);
            }
        }];
    }
}

- (void)userWithUserID:(int)userID onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion {
    
    if (userID < 1) {
        completion(nil, BAD_REQUEST);
    } else {
        NSDictionary *parameters = @{@"userID": [NSString stringWithFormat:@"%d", self.currentUser.userID], @"forUserID": [NSString stringWithFormat:@"%d", userID]};
        [httpClient POST:@"api/getProfile" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rawUser = [responseObject objectForKey:@"item"];
            AUser *user = [[AUser alloc] initWithDictionary:rawUser];
            if (user.userID == _currentUser.userID) {
                _currentUser = user;
                [self saveCurrentUser];
            }
            [self debugger:parameters.description methodLog:@"api/getProfile" dataLogFormatted:responseObject];
            completion(user, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/getProfile" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
    }
}

- (void)usersForGuess:(int)userID onCompletion:(void (^)(NSArray *, ServerResponse serverResponseCode))completion {
    
    if (userID < 1) {
        completion(nil, BAD_REQUEST);
    } else {
        NSDictionary *parameters = @{@"postedUserID": [NSString stringWithFormat:@"%d", userID]};
        [httpClient POST:@"api/getUsersForGuess" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *userArray = [responseObject objectForKey:@"items"];
            [self debugger:parameters.description methodLog:@"api/getUsersForGuess" dataLogFormatted:responseObject];
            completion(userArray, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/getUsersForGuess" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
    }
}

- (void)submitGuess:(int)guessedUserID :(int)postID onCompletion:(void (^)(AGuess *, ServerResponse serverResponseCode))completion {
    
    if (guessedUserID < 1) {
        completion(nil, BAD_REQUEST);
    } else {
        NSDictionary *parameters = @{@"guessingUserID": [NSString stringWithFormat:@"%d", self.currentUser.userID], @"guessedUserID": [NSString stringWithFormat:@"%d", guessedUserID], @"postID": [NSString stringWithFormat:@"%d", postID]};
        [httpClient POST:@"api/submitGuess" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rawGuess = [responseObject objectForKey:@"item"];
            AGuess *guess = [[AGuess alloc] initWithDictionary:rawGuess];
            [self debugger:parameters.description methodLog:@"api/submitGuess" dataLogFormatted:responseObject];
            completion(guess, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/submitGuess" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
    }
}

- (void)updateUserWithUserID:(int)userID userType:(AUserType)userType userEmail:(NSString*)userEmail password:(NSString*)password userAvatar:(UIImage*)userAvatar userFullName:(NSString*)userFullName userInfo:(NSString*)userInfo latitude:(float)latitude longitude:(float)longitude companyAddress:(NSString*)companyAddress companyPhone:(NSString*)companyPhone companyWeb:(NSString*)companyWeb onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion {
    
    if (userID < 1) {
        completion(nil, BAD_REQUEST);
    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSString stringWithFormat:@"%d", userID] forKey:@"userID"];
        if (userType) {
            [parameters setObject:[NSString stringWithFormat:@"%d", userType] forKey:@"userTypeID"];
        }
        if (userEmail.length) {
            [parameters setObject:userEmail forKey:@"email"];
        }
        if (password.length) {
            [parameters setObject:password forKey:@"password"];
        }
        if (userFullName.length) {
            [parameters setObject:userFullName forKey:@"userFullname"];
        }
        if (userInfo.length) {
            [parameters setObject:userInfo forKey:@"userInfo"];
        }
        [parameters setObject:[NSString stringWithFormat:@"%f", latitude] forKey:@"userLat"];
        [parameters setObject:[NSString stringWithFormat:@"%f", longitude] forKey:@"userLong"];
        if (companyAddress.length) {
            [parameters setObject:companyAddress forKey:@"userAddress"];
        }
        if (companyPhone.length) {
            [parameters setObject:companyPhone forKey:@"userPhone"];
        }
        if (companyWeb.length) {
            [parameters setObject:companyWeb forKey:@"userWeb"];
        }
        
        [httpClient POST:@"api/setProfile" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (userAvatar) {
                NSData *imageData = UIImageJPEGRepresentation(userAvatar, kCompressionQuality);
                if (imageData) {
                    [formData appendPartWithFileData:imageData name:@"userAvatar" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rawUser = [responseObject objectForKey:@"item"];
            AUser *user = [[AUser alloc] initWithDictionary:rawUser];
            self.currentUser = user;
            [self saveCurrentUser];
            
            [self debugger:parameters.description methodLog:@"api/setProfile" dataLogFormatted:responseObject];
            completion(user, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/setProfile" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
    }
}

- (void)setPNWithUserID:(int)userID PN:(BOOL)PN onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion {
    
    if (userID < 1) {
        completion(nil, BAD_REQUEST);
    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSString stringWithFormat:@"%d", userID] forKey:@"userID"];
        [parameters setObject:[NSString stringWithFormat:@"%d", PN] forKey:@"PN"];
        
        [httpClient POST:@"api/setPN" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rawUser = [responseObject objectForKey:@"item"];
            AUser *user = [[AUser alloc] initWithDictionary:rawUser];
            self.currentUser = user;
            [self saveCurrentUser];
            
            [self debugger:parameters.description methodLog:@"api/setPN" dataLogFormatted:responseObject];
            completion(user, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/setPN" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
    }
}

- (void)setLatLongWithUserID:(int)userID latitude:(float)latitude longitude:(float)longitude onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion {
    
    if (userID < 1) {
        completion(nil, BAD_REQUEST);
    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSString stringWithFormat:@"%d", userID] forKey:@"userID"];
        [parameters setObject:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
        [parameters setObject:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
        
        [httpClient POST:@"api/setLatLong" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rawUser = [responseObject objectForKey:@"item"];
            AUser *user = [[AUser alloc] initWithDictionary:rawUser];
            self.currentUser = user;
            [self saveCurrentUser];
            
            [self debugger:parameters.description methodLog:@"api/setLatLong" dataLogFormatted:responseObject];
            completion(user, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/setLatLong" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
    }
}


- (void)newUsersWithPageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *users, ServerResponse serverResponseCode))completion {
    
    NSDictionary *parameters = @{@"userID": [NSString stringWithFormat:@"%d", self.currentUser.userID], @"take": [NSString stringWithFormat:@"%d", pageSize]};
    [httpClient POST:@"api/getNewUsers" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *rawUsers = [responseObject objectForKey:@"items"];
        
        NSMutableArray *users = [NSMutableArray arrayWithCapacity:rawUsers.count];
        for (NSDictionary *rawUser in rawUsers) {
            AUser *user = [[AUser alloc] initWithDictionary:rawUser];
            [users addObject:user];
        }
        
        [self debugger:parameters.description methodLog:@"api/getNewUsers" dataLogFormatted:responseObject];
        completion(users, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/getNewUsers" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}

- (void)usersForSearchString:(NSString*)searchString page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *users, ServerResponse serverResponseCode))completion {
    
    if (!searchString.length) {
        completion(nil, BAD_REQUEST);
    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
        [parameters setObject:searchString forKey:@"searchTerm"];
        [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
        [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
        
        [httpClient POST:@"api/findUsers" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *rawUsers = [responseObject objectForKey:@"items"];
            
            NSMutableArray *users = [NSMutableArray arrayWithCapacity:rawUsers.count];
            for (NSDictionary *rawUser in rawUsers) {
                AUser *user = [[AUser alloc] initWithDictionary:rawUser];
                [users addObject:user];
            }
            
            [self debugger:parameters.description methodLog:@"api/findUsers" dataLogFormatted:responseObject];
            completion(users, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/findUsers" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
    }
}

- (void)timelineForUserID:(int)userID latitude:(float)latitude longitude:(float)longitude locationMode:(NSString *)locationMode sortByMode:(NSString *)sortByMode page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *posts, ServerResponse serverResponseCode))completion {
    
//    if (userID < 1) {
//        completion(nil, BAD_REQUEST);
//    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if(self.currentUser.userID)
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    else
        [parameters setObject:[NSString stringWithFormat:@"%d", [UNIQUE_ID intValue]] forKey:@"userID"];
    
    if(self.currentClub)
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentClub.clubID] forKey:@"clubID"];
    else
        [parameters setObject:@"0" forKey:@"clubID"];
    
        [parameters setObject:[NSString stringWithFormat:@"%d", userID] forKey:@"forUserID"];
        [parameters setObject:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
        [parameters setObject:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
        [parameters setObject:locationMode forKey:@"locationMode"];
        [parameters setObject:sortByMode forKey:@"sortByMode"];
        [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
        [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
        
        [httpClient POST:@"api/getTimeline" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *rawPosts = [responseObject objectForKey:@"items"];
            
            NSMutableArray *posts = [NSMutableArray arrayWithCapacity:rawPosts.count];
            for (NSDictionary *rawPost in rawPosts) {
                APost *post = [[APost alloc] initWithDictionary:rawPost];
                [posts addObject:post];
            }
            
            [self debugger:parameters.description methodLog:@"api/getTimeline" dataLogFormatted:responseObject];
            completion(posts, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/getTimeline" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
//    }
}

- (void)myPostsForUserID:(int)userID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *posts, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if(self.currentUser.userID)
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    else
        [parameters setObject:[NSString stringWithFormat:@"%d", [UNIQUE_ID intValue]] forKey:@"userID"];
    
    [parameters setObject:[NSString stringWithFormat:@"%d", userID] forKey:@"forUserID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
    
    [httpClient POST:@"api/getMyPosts" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *rawPosts = [responseObject objectForKey:@"items"];
        
        NSMutableArray *posts = [NSMutableArray arrayWithCapacity:rawPosts.count];
        for (NSDictionary *rawPost in rawPosts) {
            APost *post = [[APost alloc] initWithDictionary:rawPost];
            [posts addObject:post];
        }
        
        [self debugger:parameters.description methodLog:@"api/getMyPosts" dataLogFormatted:responseObject];
        completion(posts, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/getMyPosts" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}

- (void)myGuessesForUserID:(int)userID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *posts, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if(self.currentUser.userID)
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    else
        [parameters setObject:[NSString stringWithFormat:@"%d", [UNIQUE_ID intValue]] forKey:@"userID"];
    
    [parameters setObject:[NSString stringWithFormat:@"%d", userID] forKey:@"forUserID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
    
    [httpClient POST:@"api/getMyGuesses" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *rawPosts = [responseObject objectForKey:@"items"];
        
        NSMutableArray *posts = [NSMutableArray arrayWithCapacity:rawPosts.count];
        for (NSDictionary *rawPost in rawPosts) {
            APost *post = [[APost alloc] initWithDictionary:rawPost];
            [posts addObject:post];
        }
        
        [self debugger:parameters.description methodLog:@"api/getMyGuesses" dataLogFormatted:responseObject];
        completion(posts, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/getMyGuesses" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}

- (void)usersAroundLatitude:(float)latitude longitude:(float)longitude distance:(float)distance page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *users, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    [parameters setObject:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
    [parameters setObject:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
    [parameters setObject:[NSString stringWithFormat:@"%f", distance] forKey:@"distance"];
    [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
    
    [httpClient POST:@"api/getLocationsForLatLong" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *rawUsers = [responseObject objectForKey:@"items"];
        
        NSMutableArray *users = [NSMutableArray arrayWithCapacity:rawUsers.count];
        for (NSDictionary *rawUser in rawUsers) {
            AUser *user = [[AUser alloc] initWithDictionary:rawUser];
            [users addObject:user];
        }
        
        [self debugger:parameters.description methodLog:@"api/getLocationsForLatLong" dataLogFormatted:responseObject];
        completion(users, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/getLocationsForLatLong" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}


#pragma mark - posts

- (void)sendPostWithTitle:(NSString*)postTitle postKeywords:(NSArray*)postKeywords postImage:(UIImage*)postImage onCompletion:(void (^)(APost *post, ServerResponse serverResponseCode))completion {
    
    if (!postTitle.length) {
        completion(nil, BAD_REQUEST);
    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentClub.clubID] forKey:@"clubID"];
        [parameters setObject:postTitle forKey:@"postTitle"];
        
        [httpClient POST:@"api/sendPost" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (postImage) {
                NSData *imageData = UIImageJPEGRepresentation(postImage, kCompressionQuality);
                if (imageData) {
                    [formData appendPartWithFileData:imageData name:@"postImage" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rawPost = [responseObject objectForKey:@"item"];
            APost *post = [[APost alloc] initWithDictionary:rawPost];
            
            [self debugger:parameters.description methodLog:@"api/sendPost" dataLogFormatted:responseObject];
            completion(post, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/sendPost" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
        
        /*
        [httpClient POST:@"api/sendPost" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *rawPost = [responseObject objectForKey:@"item"];
            APost *post = [[APost alloc] initWithDictionary:rawPost];
            
            [self debugger:parameters.description methodLog:@"api/sendPost" dataLogFormatted:responseObject];
            completion(post, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/sendPost" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
         */
    }
}

- (void)recentPostsWithPageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *posts, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
    
    [httpClient POST:@"api/getRecentPosts" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *rawPosts = [responseObject objectForKey:@"items"];
        
        NSMutableArray *posts = [NSMutableArray arrayWithCapacity:rawPosts.count];
        for (NSDictionary *rawPost in rawPosts) {
            APost *post = [[APost alloc] initWithDictionary:rawPost];
            [posts addObject:post];
        }
        
        [self debugger:parameters.description methodLog:@"api/getRecentPosts" dataLogFormatted:responseObject];
        completion(posts, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/getRecentPosts" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}

- (void)popularPostsOnPage:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *posts, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
    [httpClient POST:@"api/getPopularPosts" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *rawPosts = [responseObject objectForKey:@"items"];
        
        NSMutableArray *posts = [NSMutableArray arrayWithCapacity:rawPosts.count];
        for (NSDictionary *rawPost in rawPosts) {
            APost *post = [[APost alloc] initWithDictionary:rawPost];
            [posts addObject:post];
        }
        
        [self debugger:parameters.description methodLog:@"api/getPopularPosts" dataLogFormatted:responseObject];
        completion(posts, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/getPopularPosts" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}

- (void)deletePost:(int)postID onCompletion:(void (^)(ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", postID] forKey:@"postID"];
    [httpClient POST:@"api/deletePost" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self debugger:parameters.description methodLog:@"api/deletePost" dataLogFormatted:responseObject];
        completion(OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/deletePost" dataLog:error.description];
        completion(UNKNOWN_ERROR);
    }];
}


#pragma mark - comments

- (void)sendCommentOnPostID:(int)postID withCommentText:(NSString*)commentText onCompletion:(void (^)(AComment *comment, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", postID] forKey:@"postID"];
    [parameters setObject:commentText forKey:@"commentText"];
    [httpClient POST:@"api/setComment" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rawComment = [responseObject objectForKey:@"item"];
        AComment *comment = [[AComment alloc] initWithDictionary:rawComment];
        
        [self debugger:parameters.description methodLog:@"api/setComment" dataLogFormatted:responseObject];
        completion(comment, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/setComment" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}

- (void)removeCommentWithCommentID:(int)commentID onCompletion:(void (^)(ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", commentID] forKey:@"commentID"];
    [httpClient POST:@"api/removeComment" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSDictionary *rawComment = [responseObject objectForKey:@"item"];
        //AComment *comment = [[AComment alloc] initWithDictionary:rawComment];
        
        [self debugger:parameters.description methodLog:@"api/removeComment" dataLogFormatted:responseObject];
        completion(OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/removeComment" dataLog:error.description];
        completion(UNKNOWN_ERROR);
    }];
}

- (void)commentsForPostID:(int)postID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *comments, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if(self.currentUser.userID)
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    else
        [parameters setObject:[NSString stringWithFormat:@"%d", [UNIQUE_ID intValue]] forKey:@"userID"];
    
    [parameters setObject:[NSString stringWithFormat:@"%d", postID] forKey:@"postID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
    [httpClient POST:@"api/getComments" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *rawComments = [responseObject objectForKey:@"items"];
        
        NSMutableArray *comments = [NSMutableArray arrayWithCapacity:rawComments.count];
        for (NSDictionary *rawComment in rawComments) {
            AComment *comment = [[AComment alloc] initWithDictionary:rawComment];
            [comments addObject:comment];
        }
        
        [self debugger:parameters.description methodLog:@"api/getComments" dataLogFormatted:responseObject];
        completion(comments, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/getComments" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}


#pragma mark - likes

- (void)setLikeOnPostID:(int)postID onCompletion:(void (^)(ALike *like, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSLog(@"%@", [UIDevice currentDevice].identifierForVendor.UUIDString);
    if(self.currentUser.userID)
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    else
        [parameters setObject:[NSString stringWithFormat:@"%d", [UNIQUE_ID intValue]] forKey:@"userID"];
//    [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", postID] forKey:@"postID"];
    [httpClient POST:@"api/setLike" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rawLike = [responseObject objectForKey:@"item"];
        ALike *like = [[ALike alloc] initWithDictionary:rawLike];
        
        [self debugger:parameters.description methodLog:@"api/setLike" dataLogFormatted:responseObject];
        completion(like, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/setLike" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}

- (void)removeLikeWithLikeID:(int)postID onCompletion:(void (^)(ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if(self.currentUser.userID)
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    else
        [parameters setObject:[NSString stringWithFormat:@"%d", [UNIQUE_ID intValue]] forKey:@"userID"];
    
    [parameters setObject:[NSString stringWithFormat:@"%d", postID] forKey:@"postID"];
    [httpClient POST:@"api/removeLike" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self debugger:parameters.description methodLog:@"api/removeLike" dataLogFormatted:responseObject];
        completion(OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/removeLike" dataLog:error.description];
        completion(UNKNOWN_ERROR);
    }];
}

- (void)likesForPostID:(int)postID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *likes, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", postID] forKey:@"postID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
    [httpClient POST:@"api/getLikes" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *rawLikes = [responseObject objectForKey:@"items"];
        
        NSMutableArray *likes = [NSMutableArray arrayWithCapacity:rawLikes.count];
        for (NSDictionary *rawLike in rawLikes) {
            ALike *like = [[ALike alloc] initWithDictionary:rawLike];
            [likes addObject:like];
        }
        
        [self debugger:parameters.description methodLog:@"api/getLikes" dataLogFormatted:responseObject];
        completion(likes, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/getLikes" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}


#pragma mark - follow

- (void)setFollowOnUserID:(int)userID onCompletion:(void (^)(AFollow *follow, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", userID] forKey:@"followingID"];
    [httpClient POST:@"api/setFollow" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rawFollow = [responseObject objectForKey:@"item"];
        AFollow *follow = [[AFollow alloc] initWithDictionary:rawFollow];
        self.currentUser.followingCount++;
        [self debugger:parameters.description methodLog:@"api/setFollow" dataLogFormatted:responseObject];
        completion(follow, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/setFollow" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}

- (void)removeFollowWithFollowID:(int)followID onCompletion:(void (^)(ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    [parameters setObject:[NSString stringWithFormat:@"%d", followID] forKey:@"followingID"];
    [httpClient POST:@"api/removeFollow" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSDictionary *rawFollow = [responseObject objectForKey:@"item"];
        //AFollow *follow = [[AFollow alloc] initWithDictionary:rawFollow];
        self.currentUser.followingCount--;
        [self debugger:parameters.description methodLog:@"api/removeFollow" dataLogFormatted:responseObject];
        completion(OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/removeFollow" dataLog:error.description];
        completion(UNKNOWN_ERROR);
    }];
}

- (void)followersForUserID:(int)userID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *followers, ServerResponse serverResponseCode))completion {
    
    if (userID < 1) {
        completion(nil, BAD_REQUEST);
    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
        [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
        [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
        [parameters setObject:[NSString stringWithFormat:@"%d", userID] forKey:@"forUserID"];
        [httpClient POST:@"api/getFollowers" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *rawUsers = responseObject[@"items"];
            
            NSMutableArray *users = [NSMutableArray arrayWithCapacity:rawUsers.count];
            for (NSDictionary *rawUser in rawUsers) {
                AUser *user = [[AUser alloc] initWithDictionary:rawUser[@"user"]];
                [users addObject:user];
            }
            
            [self debugger:parameters.description methodLog:@"api/getFollowers" dataLogFormatted:responseObject];
            completion(users, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/getFollowers" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
    }
}

- (void)followingForUserID:(int)userID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *following, ServerResponse serverResponseCode))completion {
    
    if (userID < 1) {
        completion(nil, BAD_REQUEST);
    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
        [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
        [parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"take"];
        [parameters setObject:[NSString stringWithFormat:@"%d", userID] forKey:@"forUserID"];
        [httpClient POST:@"api/getFollowing" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *rawUsers = responseObject[@"items"];
            
            NSMutableArray *users = [NSMutableArray arrayWithCapacity:rawUsers.count];
            for (NSDictionary *rawUser in rawUsers) {
                AUser *user = [[AUser alloc] initWithDictionary:rawUser[@"user"]];
                [users addObject:user];
            }
            
            [self debugger:parameters.description methodLog:@"api/getFollowing" dataLogFormatted:responseObject];
            completion(users, OK);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self debugger:parameters.description methodLog:@"api/getFollowing" dataLog:error.description];
            completion(nil, UNKNOWN_ERROR);
        }];
    }
}

- (void)getAllClubs:(int)userID onCompletion:(void (^)(NSMutableArray *, ServerResponse serverResponseCode))completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if(self.currentUser.userID)
        [parameters setObject:[NSString stringWithFormat:@"%d", self.currentUser.userID] forKey:@"userID"];
    else
        [parameters setObject:[NSString stringWithFormat:@"%d", [UNIQUE_ID intValue]] forKey:@"userID"];
    
    [httpClient POST:@"api/getAllClubs" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *rawClubs = [responseObject objectForKey:@"items"];
        NSMutableArray *clubs = [NSMutableArray arrayWithCapacity:rawClubs.count];
        for (NSDictionary *rawClub in rawClubs) {
            AClub *club = [[AClub alloc] initWithDictionary:rawClub];
            [clubs addObject:club];
        }
        
        [self debugger:parameters.description methodLog:@"api/getAllClubs" dataLogFormatted:responseObject];
        completion(clubs, OK);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self debugger:parameters.description methodLog:@"api/getAllClubs" dataLog:error.description];
        completion(nil, UNKNOWN_ERROR);
    }];
}

- (void)logout {
    
    _currentUser = nil;
    [self removeCurrentUser];
}

#pragma mark - debugger

- (void)debugger:(NSString *)post methodLog:(NSString *)method dataLog:(NSString *)data {
    
    #ifdef DEBUG
        NSLog(@"\n\nmethod: %@ \n\nparameters: %@ \n\nresponse: %@\n", method, post, (NSDictionary *) [json objectWithString:data]);
    #else
    #endif
}

- (void)debugger:(NSString *)post methodLog:(NSString *)method dataLogFormatted:(NSString *)data {
    
    #ifdef DEBUG
        NSLog(@"\n\nmethod: %@ \n\nparameters: %@ \n\nresponse: %@\n", method, post, data);
    #else
#endif
}

@end
