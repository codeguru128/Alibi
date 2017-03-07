//
//  AViewController.m
//  Alibi
//
//  Created by Matias Willand on 9/30/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AViewController.h"
#import "ALoginStartViewController.h"
#import "ACommentsViewController.h"
#import "ALikesViewController.h"
#import "AProfileViewController.h"
#import "APostViewController.h"
#import "AGuessViewController.h"

@implementation AViewController

#pragma mark - Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sharedConnect = [AConnect sharedConnect];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sharedConnect = [AConnect sharedConnect];
    
    toolbar = [PNTToolbar defaultToolbar];
    if ([self conformsToProtocol:@protocol(AViewControllerRefreshProtocol)]) {
        id<AViewControllerRefreshProtocol> objectConformsToProtocol = (id<AViewControllerRefreshProtocol>)self;
        refreshManager = [[MNMPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:objectConformsToProtocol.tableViewRefresh withClient:self];
    }
    loadMore = YES;
    
//    if (self.navigationController.viewControllers.count > 1) {
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.adjustsImageWhenHighlighted = NO;
//        backButton.frame = CGRectMake(0.0f, 0.0f, 40.0f, 30.0f);
//        [backButton setImage:[UIImage imageNamed:@"nav-btn-back.png"] forState:UIControlStateNormal];
//        [backButton addTarget:self action:@selector(barButtonItemBackTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    } else if (self.presentingViewController) {
//        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelButton.adjustsImageWhenHighlighted = NO;
//        cancelButton.frame = CGRectMake(0.0f, 0.0f, 40.0f, 30.0f);
//        [cancelButton setImage:[UIImage imageNamed:@"nav-btn-close.png"] forState:UIControlStateNormal];
//        [cancelButton addTarget:self action:@selector(barButtonItemCancelTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
//    }
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions methods

- (void)barButtonItemBackTouchUpInside:(UIButton*)backButton {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)barButtonItemCancelTouchUpInside:(UIButton*)backButton {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - APostCellDelegate methods

- (void)showUser:(AUser*)user sender:(APostCell*)senderCell {
    
    AProfileViewController *profileViewController = [[AProfileViewController alloc] initWithNibName:@"AProfileViewController" bundle:nil];
    profileViewController.user = user;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

- (void)showImageForPost:(APost*)post sender:(APostCell*)senderCell {
    
    if (![self isMemberOfClass:[APostViewController class]]) {
        APostViewController *postViewController = [[APostViewController alloc] initWithNibName:@"APostViewController" bundle:nil];
        postViewController.post = post;
        [self.navigationController pushViewController:postViewController animated:YES];
    }
}

- (void)toggleLikeForPost:(APost*)post sender:(APostCell*)senderCell {
    
    if (post.likedThisPost) {
        [senderCell.buttonLike setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
        post.postLikesCount--;
        post.likedThisPost = NO;
        [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d", post.postLikesCount] forState:UIControlStateNormal];
        [[AConnect sharedConnect] removeLikeWithLikeID:post.postID onCompletion:^(ServerResponse serverResponseCode) {
            if (serverResponseCode != OK) {
                [senderCell.buttonLike setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
                post.postLikesCount++;
                post.likedThisPost = YES;
                [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d", post.postLikesCount] forState:UIControlStateNormal];
            }
        }];
    } else {
        [senderCell.buttonLike setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
        post.postLikesCount++;
        post.likedThisPost = YES;
        [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d", post.postLikesCount] forState:UIControlStateNormal];
        
        [[AConnect sharedConnect] setLikeOnPostID:post.postID onCompletion:^(ALike *like, ServerResponse serverResponseCode) {
            if (serverResponseCode != OK) {
                [senderCell.buttonLike setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
                post.postLikesCount--;
                post.likedThisPost = NO;
                [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d", post.postLikesCount] forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)reloadData:(BOOL)reloadAll{

}

- (void)toggleDeletePost:(APost*)post sender:(APostCell*)senderCell {
    [[AConnect sharedConnect] deletePost:post.postID onCompletion:^(ServerResponse serverResponseCode) {
        if (serverResponseCode == OK) {
            [self reloadData:YES];
        }
        else{
            ALERT(@"", @"An error occured while deleting the post.");
        }
    }];
}

- (void)goGuessForPost:(APost*)post sender:(APostCell*)senderCell {
    if(sharedConnect.currentUser){
        sharedConnect.containerScrollView.scrollEnabled = NO;
        AGuessViewController *guessViewController = (AGuessViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AGuessViewController"];
        guessViewController.post = post;
        [self.navigationController pushViewController:guessViewController animated:YES];
    }
    else{
        [sharedConnect.containerScrollView setContentOffset:CGPointMake(320 * 2, 0) animated:YES];
    }
}

- (void)showCommentsForPost:(APost*)post sender:(APostCell*)senderCell {
    
    ACommentsViewController *commentsViewController = (ACommentsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ACommentsViewController"];
    commentsViewController.post = post;
    [self.navigationController pushViewController:commentsViewController animated:YES];
}

- (void)showGuessForPost:(APost *)post sender:(id)senderCell {
    
    AGuessViewController *guessViewController = (AGuessViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AGuessViewController"];
    guessViewController.post = post;
    [self.navigationController pushViewController:guessViewController animated:YES];
}

- (void)showLikesForPost:(APost *)post sender:(ATableViewCell*)senderCell {
    
    ALikesViewController *likesViewController = [[ALikesViewController alloc] initWithNibName:@"ALikesViewController" bundle:nil];
    likesViewController.post = post;
    [self.navigationController pushViewController:likesViewController animated:YES];
}

- (void)followUser:(AUser *)user sender:(id)senderCell {
    
    [sharedConnect setFollowOnUserID:user.userID onCompletion:^(AFollow *follow, ServerResponse serverResponseCode) {
        
    }];
}

- (void)unfollowUser:(AUser *)user sender:(id)senderCell {
    
    [sharedConnect removeFollowWithFollowID:user.userID onCompletion:^(ServerResponse serverResponseCode) {
        
    }];
}

- (void)goLogin{
    ALoginStartViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ALoginStartViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - MNMPullToRefreshClient methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [refreshManager tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [refreshManager tableViewReleased];
    
}

- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager {
    
    if (!loading) {
        id<AViewControllerRefreshProtocol> objectConformsToProtocol = (id<AViewControllerRefreshProtocol>)self;
        [objectConformsToProtocol reloadData:YES];
    } else {
        [refreshManager tableViewReloadFinishedAnimated:YES];
    }
}

@end
