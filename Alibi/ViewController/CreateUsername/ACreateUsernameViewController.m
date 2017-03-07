//
//  ACreateUsernameViewController.m
//  Alibi
//
//  Created by AnMac on 6/26/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import "ACreateUsernameViewController.h"

@interface ACreateUsernameViewController (){
    IBOutlet UITextField *usernameTextField;
    
    IBOutlet UIButton *startButton;
}

@end

@implementation ACreateUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PROFILE SETTING";
    usernameTextField.text = self.userDict[@"full_name"];
    
    startButton.layer.cornerRadius = 10;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self startButtonClicked:nil];
    return YES;
}

- (IBAction)startButtonClicked:(id)sender{
    [hud show:YES];
    
    NSString *username = usernameTextField.text;
    NSString *password = @"";
    NSString *email = GET_VALIDATED_STRING(_userDict[@"email"], @"");
   // NSString *avatar = GET_VALIDATED_STRING(_userDict[@"profile_picture"], @"");
    NSString *fullname = GET_VALIDATED_STRING(_userDict[@"full_name"], @"");
    NSString *address = GET_VALIDATED_STRING(_userDict[@"address"], @"");
    NSString *phone = GET_VALIDATED_STRING(_userDict[@"phone"], @"");
    
    /* FIXME Using the web field for storing user profile picutres */
    NSString *web = GET_VALIDATED_STRING(_userDict[@"profile_picture"], @"");
    NSString *instagram_userid = GET_VALIDATED_STRING(_userDict[@"id"], @"");
    NSString *instagram_username = GET_VALIDATED_STRING(_userDict[@"username"], @"");
    
    [sharedConnect registerUserWithUsername:username password:password email:email userAvatar:nil userType:AUserTypePerson userFullName:fullname userInfo:@"" latitude:0 longitude:0 companyAddress:address companyPhone:phone companyWeb:web instagramUserId:instagram_userid instagramUsername:instagram_username onCompletion:^(AUser *user, ServerResponse serverResponseCode) {
        [hud hide:YES];
        if (serverResponseCode == OK) {
            [sharedConnect.containerScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
            [self performSegueWithIdentifier:@"goMyProfile" sender:nil];
        } else if (serverResponseCode == NO_CONNECTION) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No connection. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else if (serverResponseCode == CONFLICT) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"User already exists. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end