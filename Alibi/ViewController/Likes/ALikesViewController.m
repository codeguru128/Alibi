//
//  ALikesViewController.m
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "ALikesViewController.h"
#import "ALikeCell.h"
#import "ALoadingCell.h"
#import "GlobalDefines.h"

@implementation ALikesViewController

#pragma mark - Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.likes = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Likes";
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data loading methods

- (void)reloadData {
    
    loading = YES;
    int page = (self.likes.count / kDefaultPageSize) + 1;
    [sharedConnect likesForPostID:self.post.postID page:page pageSize:kDefaultPageSize onCompletion:^(NSMutableArray *likes, ServerResponse serverResponseCode) {
        loading = NO;
        [self.likes addObjectsFromArray:likes];
        loadMore = likes.count == kDefaultPageSize;
        [self.tableViewRefresh reloadData];
    }];
}


#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1){
        static NSString *CellIdentifier = @"ALikeCell";
        ALikeCell *cell = (ALikeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ALikeCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        cell.like = self.likes[indexPath.row];
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
        return self.likes.count;
    } else {
        if (loadMore) {
            return 1;
        } else {
            return 0;
        }
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return 56.0f;
    } else if (indexPath.section == 0){
        return 44.0f * loadMore * self.likes.count == 0;
    } else {
        return 44.0f * loadMore;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2 && loadMore && !loading) {
        [self reloadData];
    }
}

@end
