//
//  AConnect.h
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "AFNetworking.h"

#import "AUser.h"
#import "APost.h"
#import "ALike.h"
#import "AFollow.h"
#import "AComment.h"
#import "AGuess.h"
#import "AClub.h"

enum ServerResponse {
    OK = 200,
    BAD_REQUEST = 400,
    UNAUTHORIZED = 401,
    FORBIDDEN = 403,
    NOT_FOUND = 404,
    CONFLICT = 409,
    SERVICE_UNAVAILABLE = 503,
    NO_CONNECTION,
    UNKNOWN_ERROR,
    PARTIAL_CONTENT,
    USER_EXISTS,
    USER_CREATED,
    LIKE_CREATED,
    LIKE_EXISTS
};

typedef enum ServerResponse ServerResponse;

@interface AConnect : NSObject {
    
    AFHTTPRequestOperationManager *httpClient;
    SBJsonParser *json;
}

@property (readonly, nonatomic) NSDateFormatter *dateFormatter;
@property (readonly, nonatomic) NSDateFormatter *dateOnlyFormatter;
@property (strong, nonatomic) AUser *currentUser;
@property (strong, nonatomic) AClub *currentClub;
@property (strong, nonatomic) AGuess *submittedGuess;

@property (strong, nonatomic) UIScrollView *containerScrollView;

+ (AConnect*) sharedConnect;

#pragma mark - user

- (void)loginUserWithUsername:(NSString*)username andPassword:(NSString*)password onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion;
- (void)loginUserWithInstagram:(NSString*)InstagramUserId ProfilePictureURL:(NSString*)ProfilePictureURL onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion;

- (void)registerUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email userAvatar:(UIImage*)userAvatar userType:(int)userType userFullName:(NSString*)userFullName userInfo:(NSString*)userInfo latitude:(float)latitude longitude:(float)longitude companyAddress:(NSString*)companyAddress companyPhone:(NSString*)companyPhone companyWeb:(NSString*)companyWeb instagramUserId:(NSString *)instagramUserId instagramUsername:(NSString *)instagramUsername onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion;

- (void)userWithUserID:(int)userID onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion;
- (void)setPNWithUserID:(int)userID PN:(BOOL)PN onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion;
- (void)setLatLongWithUserID:(int)userID latitude:(float)latitude longitude:(float)longitude onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion;
- (void)usersForGuess:(int)userID onCompletion:(void (^)(NSArray *, ServerResponse serverResponseCode))completion;
- (void)submitGuess:(int)guessedUserID :(int)postID onCompletion:(void (^)(AGuess *, ServerResponse serverResponseCode))completion;

- (void)updateUserWithUserID:(int)userID userType:(AUserType)userType userEmail:(NSString*)userEmail password:(NSString*)password userAvatar:(UIImage*)userAvatar userFullName:(NSString*)userFullName userInfo:(NSString*)userInfo latitude:(float)latitude longitude:(float)longitude companyAddress:(NSString*)companyAddress companyPhone:(NSString*)companyPhone companyWeb:(NSString*)companyWeb onCompletion:(void (^)(AUser *user, ServerResponse serverResponseCode))completion;

- (void)newUsersWithPageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *users, ServerResponse serverResponseCode))completion;

- (void)usersForSearchString:(NSString*)searchString page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *users, ServerResponse serverResponseCode))completion;

- (void)usersAroundLatitude:(float)latitude longitude:(float)longitude distance:(float)distance page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *users, ServerResponse serverResponseCode))completion;

- (void)timelineForUserID:(int)userID latitude:(float)latitude longitude:(float)longitude locationMode:(NSString *)locationMode sortByMode:(NSString *)sortByMode page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *posts, ServerResponse serverResponseCode))completion;
- (void)myPostsForUserID:(int)userID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *posts, ServerResponse serverResponseCode))completion;
- (void)myGuessesForUserID:(int)userID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *posts, ServerResponse serverResponseCode))completion;


#pragma mark - posts

- (void)sendPostWithTitle:(NSString*)postTitle postKeywords:(NSArray*)postKeywords postImage:(UIImage*)postImage onCompletion:(void (^)(APost *post, ServerResponse serverResponseCode))completion;

- (void)recentPostsWithPageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *posts, ServerResponse serverResponseCode))completion;

- (void)popularPostsOnPage:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *posts, ServerResponse serverResponseCode))completion;

- (void)deletePost:(int)postID onCompletion:(void (^)(ServerResponse serverResponseCode))completion;


#pragma mark - comments

- (void)sendCommentOnPostID:(int)postID withCommentText:(NSString*)commentText onCompletion:(void (^)(AComment *comment, ServerResponse serverResponseCode))completion;

- (void)removeCommentWithCommentID:(int)commentID onCompletion:(void (^)(ServerResponse serverResponseCode))completion;

- (void)commentsForPostID:(int)postID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *comments, ServerResponse serverResponseCode))completion;


#pragma mark - likes

- (void)setLikeOnPostID:(int)postID onCompletion:(void (^)(ALike *like, ServerResponse serverResponseCode))completion;

- (void)removeLikeWithLikeID:(int)likeID onCompletion:(void (^)(ServerResponse serverResponseCode))completion;

- (void)likesForPostID:(int)postID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *likes, ServerResponse serverResponseCode))completion;


#pragma mark - follow

- (void)setFollowOnUserID:(int)userID onCompletion:(void (^)(AFollow *follow, ServerResponse serverResponseCode))completion;

- (void)removeFollowWithFollowID:(int)followID onCompletion:(void (^)(ServerResponse serverResponseCode))completion;

- (void)followersForUserID:(int)userID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *followers, ServerResponse serverResponseCode))completion;

- (void)followingForUserID:(int)userID page:(int)page pageSize:(int)pageSize onCompletion:(void (^)(NSMutableArray *following, ServerResponse serverResponseCode))completion;

- (void)getAllClubs:(int)userID onCompletion:(void (^)(NSMutableArray *, ServerResponse serverResponseCode))completion;

- (void)saveCurrentClub;

- (void)logout;

@end
