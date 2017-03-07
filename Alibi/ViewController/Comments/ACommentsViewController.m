//
//  ACommentsViewController.m
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "ACommentsViewController.h"
#import "ACommentCell.h"
#import "ALoadingCell.h"
#import "GlobalDefines.h"

@interface ACommentsViewController(){
    APostCell *postCell;
}

@end

@implementation ACommentsViewController


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"POST";
    self.view.backgroundColor = MAIN_BACK_COLOR;
    self.tableViewRefresh.backgroundColor = MAIN_BACK_COLOR;
    
    self.comments = [NSMutableArray array];
    
    [self.tableViewRefresh setSeparatorColor:MAIN_BACK_COLOR];
    [self reloadData:YES];
    //self.viewEnterComment.frame = CGRectMake(0, CGRectGetMaxY(self.tableViewRefresh.frame), CGRectGetWidth(self.viewEnterComment.frame), CGRectGetHeight(self.viewEnterComment.frame));
    //[self.view addSubview:self.viewEnterComment];
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
        [self adjustHeightOfTableview];
    }];
}

- (void)adjustHeightOfTableview
{
    CGFloat height = self.tableViewRefresh.contentSize.height;
    CGFloat maxHeight = self.tableViewRefresh.superview.frame.size.height - self.tableViewRefresh.frame.origin.y - self.viewEnterComment.frame.size.height;
    
    // if the height of the content is greater than the maxHeight of
    // total space on the screen, limit the height to the size of the
    // superview.
    
    if (height > maxHeight)
        height = maxHeight;
    
    // now set the frame accordingly
    
    CGRect frame = self.tableViewRefresh.frame;
    frame.size.height = height;
    self.tableViewRefresh.frame = frame;
}


#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        static NSString *CellIdentifier = @"APostCell";
        postCell = (APostCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        postCell.isPostCellForComments = YES;
        postCell.post = self.post;
        postCell.delegate = self;
        postCell.buttonComment.enabled = NO;
        
        return postCell;
    }
    else if (indexPath.section == 2){
        static NSString *CellIdentifier = @"ACommentCell";
        ACommentCell *cell = (ACommentCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.comment = self.comments[indexPath.row];
        return cell;
    } else {
        static NSString *CellIdentifier = @"ALoadingCell";
        ALoadingCell *cell = (ALoadingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ALoadingCell" owner:self options:nil] lastObject];
        }
        
        cell.backgroundColor = MAIN_BACK_COLOR;
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 2) {
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
        [sharedConnect removeCommentWithCommentID:comment.commentID onCompletion:^(ServerResponse serverResponseCode) {
            
        }];
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return [APostCell sizeWithPost:self.post :tableView].height;
    }
    else if (indexPath.section == 2) {
        return [ACommentCell sizeWithComment:self.comments[indexPath.row] :tableView].height;
    } else if (indexPath.section == 1){
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
        self.viewEnterComment.center = CGPointMake(self.viewEnterComment.center.x, self.viewEnterComment.center.y - 216);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.31 animations:^{
        self.viewEnterComment.center = CGPointMake(self.viewEnterComment.center.x, self.viewEnterComment.center.y + 216);
    } completion:^(BOOL finished) {
        if (self.textFieldEnterComment.text.length) {
//            if ([AConnect sharedConnect].currentUser){
                [hud show:YES];
                [sharedConnect sendCommentOnPostID:self.post.postID withCommentText:self.textFieldEnterComment.text onCompletion:^(AComment *comment, ServerResponse serverResponseCode) {
                    [hud hide:YES];
                    if(serverResponseCode == OK){
                        [self.comments insertObject:comment atIndex:0];
                        [self.tableViewRefresh reloadData];
                        [self adjustHeightOfTableview];
                        self.textFieldEnterComment.text = @"";
                        
                        postCell.post.commentedThisPost = YES;
                        postCell.post.postCommentsCount++;
                        [postCell.buttonComment setTitle:[NSString stringWithFormat:@"%d", postCell.post.postCommentsCount] forState:UIControlStateNormal];
                    }
                }];
//            }
//            else{
//                [self performSegueWithIdentifier:@"GoLogin" sender:nil];
//            }
        }
    }];
}

@end
