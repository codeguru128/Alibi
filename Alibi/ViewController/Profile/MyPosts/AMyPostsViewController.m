//
//  AMyPostsViewController.m
//  Alibi
//
//  Created by AnMac on 7/1/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import "AMyPostsViewController.h"
#import "ALoadingCell.h"

@interface AMyPostsViewController (){
    IBOutlet UITableView *postsTableView;
}

@end

@implementation AMyPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"MY POSTS";
    self.view.backgroundColor = MAIN_GRAY_BACK_COLOR;
    postsTableView.backgroundColor = MAIN_GRAY_BACK_COLOR;
    postsTableView.separatorColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [self reloadData:YES];
}


#pragma mark - Data loading methods

- (void)reloadData:(BOOL)reloadAll {
    
    loading = YES;
    int page;
    if (reloadAll) {
        loadMore = YES;
        page = 1;
    } else {
        page  = (self.posts.count / kDefaultPageSize) + 1;
    }
    [sharedConnect myPostsForUserID:sharedConnect.currentUser.userID page:page pageSize:kDefaultPageSize onCompletion:^(NSMutableArray *posts, ServerResponse serverResponseCode) {
        loading = NO;
        self.posts = posts;
        loadMore = posts.count == kDefaultPageSize;
        [postsTableView reloadData];
        [refreshManager tableViewReloadFinishedAnimated:YES];
    }];
}


#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1){
        static NSString *CellIdentifier = @"APostCell";
        APostCell *cell = (APostCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.post = self.posts[indexPath.row];
        
        cell.buttonGuess.hidden = YES;
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"ALoadingCell";
        ALoadingCell *cell = (ALoadingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ALoadingCell" owner:self options:nil] lastObject];
        }
        
        cell.backgroundColor = MAIN_GRAY_BACK_COLOR;
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.posts.count;
    } else {
        if (loadMore) {
            return 1;
        } else {
            return 0;
        }
    }
}


#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return [APostCell sizeWithPost:self.posts[indexPath.row] :tableView].height;
    } else if (indexPath.section == 0){
        return 44 * loading * self.posts.count == 0;
    } else {
        return 44 * loadMore;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2 && loadMore && !loading) {
        [self reloadData:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
