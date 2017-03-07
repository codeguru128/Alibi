//
//  AProfileViewController.m
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AProfileViewController.h"
#import "AEditProfileViewController.h"
#import "GlobalDefines.h"
#import "AFollowingViewController.h"
#import "AFollowersViewController.h"
#import "ASearchViewController.h"
#import "AWelcomeViewController.h"
#import "AAppDelegate.h"

@implementation AProfileViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = sharedConnect.currentUser;
    
    if(self.user)
        self.title = [self.user.userUsername uppercaseString];
    else
        self.title = @"PROFILE";
    
    self.view.backgroundColor = MAIN_GRAY_BACK_COLOR;
    self.navigationItem.hidesBackButton = TRUE;
    
    profileTableView.separatorColor = MAIN_GRAY_BACK_COLOR;
    profileTableView.layer.cornerRadius = 10;
    profileTableView.clipsToBounds = YES;
    
    [profileTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self updateFramesAndDataWithDownloads:YES];
    [profileTableView reloadData];
}

- (void)updateFramesAndDataWithDownloads:(BOOL)downloads {
    
    [sharedConnect userWithUserID:self.user.userID onCompletion:^(AUser *user, ServerResponse serverResponseCode) {
        if(serverResponseCode != OK)
            return;
        
        sharedConnect.currentUser = user;
        self.user = user;
        
        [profileTableView reloadData];
        [self.profilePictureView setImageWithURL:[NSURL URLWithString:self.user.companyWeb]];
        self.profilePictureView.clipsToBounds = true;
        self.profilePictureView.layer.cornerRadius = (self.profilePictureView.frame.size.height) / 2 ;
        self.profilePictureView.layer.borderColor = [UIColor colorWithRed:0.22 green:0.78 blue:0.93 alpha:1.0].CGColor;
        self.profilePictureView.layer.borderWidth = 4.0f;
        
//        self.labelName.text = self.user.userFullName;
//        if (self.user.followingUser) {
//            [self.buttonFollow setTitle:@"Following" forState:UIControlStateNormal];
//        } else {
//            [self.buttonFollow setTitle:@"Follow!" forState:UIControlStateNormal];
//        }
//        self.labelFollowingCount.text = [NSString stringWithFormat:@"following %d", self.user.followingCount];
//        self.labelFollowersCount.text = [NSString stringWithFormat:@"followers %d", self.user.followersCount];
//        
//        self.labelAddress.text = self.user.companyAddress;
//        self.labelPhone.text = self.user.companyPhone;
//        self.labelWeb.text = self.user.companyWeb;
//        self.labelEmail.text = self.user.companyEmail;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AProfileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *label = (UILabel *)[cell viewWithTag:200];
    if(indexPath.row == 0){
        label.text = [NSString stringWithFormat:@"My Posts (%d)", self.user.myPostsCount];
    }
    else if(indexPath.row == 1){
        label.text = [NSString stringWithFormat:@"My Guesses (%d)", self.user.myGuessesCount];
    }
    else if(indexPath.row == 2){
        label.text = @"Settings";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"GoMyPosts" sender:nil];
    }
    else if(indexPath.row == 1){
        [self performSegueWithIdentifier:@"GoMyGuesses" sender:nil];
    }
    else if(indexPath.row == 2){
        [self performSegueWithIdentifier:@"GoSettings" sender:nil];
    }
}

@end
