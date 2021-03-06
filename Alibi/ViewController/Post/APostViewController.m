//
//  ACommentsViewController.m
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "APostViewController.h"
#import "ACommentCell.h"
#import "ALoadingCell.h"
#import "GlobalDefines.h"

@implementation APostViewController

#pragma mark - Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.comments = [NSMutableArray array];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Post";
    [self reloadData:YES];
    
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reportButton.adjustsImageWhenHighlighted = NO;
    reportButton.frame = CGRectMake(0.0f, 0.0f, 40.0f, 30.0f);
    [reportButton setImage:[UIImage imageNamed:@"nav-btn-close"] forState:UIControlStateNormal];
    [reportButton addTarget:self action:@selector(barButtonItemReportTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:reportButton];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data loading methods

- (void)reloadData:(BOOL)reloadAll {
    
    loading = YES;
    int page = reloadAll ? 1 : (self.comments.count / kDefaultPageSize) + 1;
    [sharedConnect commentsForPostID:self.post.postID page:page pageSize:kDefaultPageSize onCompletion:^(NSMutableArray *comments, ServerResponse serverResponseCode) {
        loading = NO;
        if (reloadAll) {
            [self.comments removeAllObjects];
        }
        [self.comments addObjectsFromArray:comments];
        loadMore = comments.count == kDefaultPageSize;
        [self.tableViewRefresh reloadData];
        [refreshManager tableViewReloadFinishedAnimated:YES];
    }];
}


#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1){
        static NSString *CellIdentifier = @"APostCell";
        APostCell *cell = (APostCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"APostCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        cell.post = self.post;
        return cell;
        
    } else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"ACommentCell";
        ACommentCell *cell = (ACommentCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ACommentCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        cell.comment = self.comments[indexPath.row];
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
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.comments.count;
    } else {
        if (loadMore) {
            return 1;
        } else {
            return 0;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AComment *comment = self.comments[indexPath.row];
        [sharedConnect removeCommentWithCommentID:comment.commentID onCompletion:^(ServerResponse serverResponseCode) { }];
    }
}


#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return [APostCell sizeWithPost:self.post :tableView].height;
    } else if (indexPath.section == 2){
        return [ACommentCell sizeWithComment:self.comments[indexPath.row] :tableView].height;
    } else if (indexPath.section == 0){
        return 44 * loadMore * self.comments.count == 0;
    } else {
        return 44 * loadMore;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3 && loadMore && !loading) {
        [self reloadData:NO];
    }
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.31 animations:^{
        self.viewEnterComment.center = CGPointMake(self.viewEnterComment.center.x, self.viewEnterComment.center.y - 216 + 49);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.31 animations:^{
        self.viewEnterComment.center = CGPointMake(self.viewEnterComment.center.x, self.viewEnterComment.center.y + 216 - 49);
    } completion:^(BOOL finished) {
        if (self.textFieldEnterComment.text.length) {
            
            [hud show:YES];
            [sharedConnect sendCommentOnPostID:self.post.postID withCommentText:self.textFieldEnterComment.text onCompletion:^(AComment *comment, ServerResponse serverResponseCode) {
                [hud hide:YES];
                [self.comments insertObject:comment atIndex:0];
                [self.tableViewRefresh reloadData];
                self.textFieldEnterComment.text = @"";
            }];
        }
    }];
}


#pragma mark - APostCellDelegate methods

- (void)toggleLikeForPost:(APost*)post sender:(APostCell*)senderCell {
    
    if (post.likedThisPost) {
        [senderCell.buttonLike setImage:[UIImage imageNamed:@"btn-like.png"] forState:UIControlStateNormal];
        post.postLikesCount--;
        post.likedThisPost = NO;
        if (post.postLikesCount == 1) {
            [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d like", post.postLikesCount] forState:UIControlStateNormal];
        } else {
            [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d likes", post.postLikesCount] forState:UIControlStateNormal];
        }
        [[AConnect sharedConnect] removeLikeWithLikeID:post.postID onCompletion:^(ServerResponse serverResponseCode) {
            if (serverResponseCode != OK) {
                [senderCell.buttonLike setImage:[UIImage imageNamed:@"btn-liked.png"] forState:UIControlStateNormal];
                post.postLikesCount++;
                post.likedThisPost = YES;
                if (post.postLikesCount == 1) {
                    [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d like", post.postLikesCount] forState:UIControlStateNormal];
                } else {
                    [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d likes", post.postLikesCount] forState:UIControlStateNormal];
                }
            }
        }];
    } else {
        [senderCell.buttonLike setImage:[UIImage imageNamed:@"btn-liked.png"] forState:UIControlStateNormal];
        post.postLikesCount++;
        post.likedThisPost = YES;
        if (post.postLikesCount == 1) {
            [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d like", post.postLikesCount] forState:UIControlStateNormal];
        } else {
            [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d likes", post.postLikesCount] forState:UIControlStateNormal];
        }
        [[AConnect sharedConnect] setLikeOnPostID:post.postID onCompletion:^(ALike *like, ServerResponse serverResponseCode) {
            if (serverResponseCode != OK) {
                [senderCell.buttonLike setImage:[UIImage imageNamed:@"btn-like.png"] forState:UIControlStateNormal];
                post.postLikesCount--;
                post.likedThisPost = NO;
                if (post.postLikesCount == 1) {
                    [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d like", post.postLikesCount] forState:UIControlStateNormal];
                } else {
                    [senderCell.buttonLike setTitle:[NSString stringWithFormat:@"%d likes", post.postLikesCount] forState:UIControlStateNormal];
                }
            }
        }];
    }
}


#pragma mark - Actions methods

- (void)barButtonItemReportTouchUpInside:(UIBarButtonItem *)barButtonItem {
    
    if ([MFMailComposeViewController canSendMail]) {
        [[[UIAlertView alloc] initWithTitle:@"Report" message:@"Are you sure you want to report this post?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Report!", nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Report" message:@"This device is not configured to send mails, please enable mail and contact us at report@foodspotting.com" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}


#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if (result == MFMailComposeResultFailed) {
        [[[UIAlertView alloc] initWithTitle:@"Mail not sent!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:^{ }];
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqualToString:@"Report"] && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Report!"]) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.navigationBar.tintColor = [UIColor whiteColor];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setToRecipients:@[@"report@foodspotting.com"]];
        [mailComposeViewController setSubject:@"Report"];
        NSString *message = [NSString stringWithFormat:@"Reporting post with id: %d\n\nDescription: %@", self.post.postID, self.post.postTitle];
        [mailComposeViewController setMessageBody:message isHTML:NO];
        [self presentViewController:mailComposeViewController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}

@end
