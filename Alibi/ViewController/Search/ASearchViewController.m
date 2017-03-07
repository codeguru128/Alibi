//
//  ASearchViewController.m
//  Alibi
//
//  Created by Matias Willand on 09/01/14.
//  Copyright (c) 2014 Planet 1107. All rights reserved.
//

#import "ASearchViewController.h"
#import "AUserCell.h"
#import "ALoadingCell.h"
#import "GlobalDefines.h"

@implementation ASearchViewController

#pragma mark - Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.users = [NSMutableArray array];
        self.title = @"Search users";
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data loading methods

- (void)reloadData:(BOOL)reloadAll {
    
    loading = YES;
    [self.tableViewSearch reloadData];
    int page = reloadAll ? 1 : (self.users.count / kDefaultPageSize) + 1;
    [sharedConnect usersForSearchString:self.searchBarSearchUsers.text page:page pageSize:kDefaultPageSize onCompletion:^(NSMutableArray *users, ServerResponse serverResponseCode) {
        loading = NO;
        if (reloadAll) {
            [self.users removeAllObjects];
        }
        [self.users addObjectsFromArray:users];
        loadMore = users.count == kDefaultPageSize;
        [self.tableViewSearch reloadData];
        [refreshManager tableViewReloadFinishedAnimated:YES];
    }];
}


#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1){
        static NSString *CellIdentifier = @"AUserCell";
        AUserCell *cell = (AUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AUserCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        cell.user = self.users[indexPath.row];
        return cell;
    } else {
        static NSString *CellIdentifier = @"ALoadingCell";
        ALoadingCell *cell = (ALoadingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ALoadingCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    if (section == 1) {
        return self.users.count;
    } else {
        if (loadMore) {
            return 1;
        } else {
            return 0;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return 44;
    } else if (indexPath.section == 0){
        return 44 * loading * self.users.count == 0;
    } else {
        return 44 * loadMore;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2 && loadMore && !loading) {
        [self reloadData:NO];
    }
}


#pragma mark - UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self reloadData:YES];
    [self.searchBarSearchUsers resignFirstResponder];
    self.searchBarSearchUsers.text = @"";
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [self.users removeAllObjects];
    [self.tableViewSearch reloadData];
}


#pragma mark - AUserCellDelegate methods

- (void)followUser:(AUser *)user sender:(id)senderCell {
    
    AUserCell *cell = (AUserCell*)senderCell;
    [cell.buttonFollowUnfollow setImage:[UIImage imageNamed:@"btn-unfollow.png"] forState:UIControlStateNormal];
    user.followingUser = YES;
    [sharedConnect setFollowOnUserID:user.userID onCompletion:^(AFollow *follow, ServerResponse serverResponseCode) {
        if (serverResponseCode != OK) {
            user.followingUser = NO;
            [cell.buttonFollowUnfollow setImage:[UIImage imageNamed:@"btn-follow.png"] forState:UIControlStateNormal];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occured, user was not followed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void)unfollowUser:(AUser *)user sender:(id)senderCell {
    
    AUserCell *cell = (AUserCell*)senderCell;
    [cell.buttonFollowUnfollow setImage:[UIImage imageNamed:@"btn-follow.png"] forState:UIControlStateNormal];
    user.followingUser = NO;
    [sharedConnect removeFollowWithFollowID:user.userID onCompletion:^(ServerResponse serverResponseCode) {
        if (serverResponseCode != OK) {
            user.followingUser = YES;
            [cell.buttonFollowUnfollow setImage:[UIImage imageNamed:@"btn-unfollow.png"] forState:UIControlStateNormal];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occured, user was not unfollowed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

@end
