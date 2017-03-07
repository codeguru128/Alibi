//
//  AGuessViewController.m
//  Alibi
//
//  Created by AnMac on 6/27/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import "AGuessViewController.h"
#import "AGuess.h"
#import "AGuessCell.h"
#import "KGModal.h"

@interface AGuessViewController (){
    IBOutlet UIView *mainView;
    
    IBOutlet UILabel *postLabel;
    
    IBOutlet UITableView *usersTableView;
    
    NSMutableArray *userArray;
    
    NSInteger selectedRowInd;
}

@end

@implementation AGuessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainView.layer.cornerRadius = 10.0f;

    self.title = @"GUESS";
    
    postLabel.text = self.post.postTitle;
    
    usersTableView.hidden = YES;
    usersTableView.separatorColor = MAIN_BACK_COLOR;
    [self reloadData:YES];
    self.navigationItem.hidesBackButton = YES;
    
    usersTableView.scrollEnabled = NO;
    //self.viewEnterComment.frame = CGRectMake(0, CGRectGetMaxY(self.tableViewRefresh.frame), CGRectGetWidth(self.viewEnterComment.frame), CGRectGetHeight(self.viewEnterComment.frame));
    //[self.view addSubview:self.viewEnterComment];
}

- (IBAction)submitGuess:(id)sender{
    if(selectedRowInd < 0){
        ALERT(@"", @"Please select a username and submit guess.");
        return;
    }
    
    loading = YES;
    [hud show:YES];
    NSDictionary *selectedUser = userArray[selectedRowInd];
    [sharedConnect submitGuess:[selectedUser[@"userID"] intValue]:self.post.postID onCompletion:^(AGuess *guess, ServerResponse serverResponseCode){
        loading = NO;
        [hud hide:YES];
        
        if(serverResponseCode != OK)
            return ;
        
        sharedConnect.submittedGuess = guess;
        sharedConnect.currentUser.myGuessesCount++;
        
        NSUInteger postUserID = sharedConnect.submittedGuess.guessPost.user.userID;
        NSUInteger guessedUserID = sharedConnect.submittedGuess.guessedUser.userID;
        
        NSString *postUserProfilePicture = sharedConnect.submittedGuess.guessPost.user.companyWeb;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:postUserProfilePicture]];
        
        BOOL correct = (guessedUserID == postUserID);
        
        NSString *guessImage = correct ? @"correct01" : @"incorrect";
        
        NSLog(@"%@", postUserProfilePicture);
        
        [KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeNone;
        [KGModal sharedInstance].tapOutsideToDismiss = NO;
        [KGModal sharedInstance].backgroundDisplayStyle = KGModalBackgroundDisplayStyleSolid;;
        [KGModal sharedInstance].modalBackgroundColor = RGBA(0, 0, 0, 1);
        
        UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(21, 0, 278, 450)];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        UIImageView *imageCorrect = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(imageView.frame)+150, 226, 75)];
        imageCorrect.image = [UIImage imageNamed:@"incorrect02"];
        
        
        if(correct && (postUserProfilePicture.length > 1)){
            imageView.image = [UIImage imageWithData:imageData];
        }
        else{
            imageView.image = [UIImage imageNamed:guessImage];
        }
        
        [imageView sizeToFit];
        [resultView addSubview:imageView];
        
        [imageView setFrame:CGRectMake((278 - imageView.frame.size.width) / 2, 0, imageView.frame.size.width, imageView.frame.size.height)];
        
        [imageView setFrame:CGRectMake((278 - imageView.frame.size.width) / 2, 0, imageView.frame.size.height, imageView.frame.size.height)];
            imageView.clipsToBounds = true;
            imageView.layer.cornerRadius = (imageView.frame.size.height) / 2 ;
            imageView.layer.borderColor = [UIColor colorWithRed:0.22 green:0.78 blue:0.93 alpha:1.0].CGColor;
            imageView.layer.borderWidth = 4.0f;
        
        if(!correct){
            [resultView addSubview:imageCorrect];
        }
        
        
        CGFloat buttonY;
        if(correct){
            UILabel *yesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, 278, 30)];
            yesLabel.textColor = [UIColor whiteColor];
            yesLabel.font = [UIFont fontWithName:MAIN_SEMIBOLDFONT_NAME size:18];
            yesLabel.textAlignment = NSTextAlignmentCenter;
            yesLabel.text = @"Yes, it was";
            [resultView addSubview:yesLabel];
            
            UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(yesLabel.frame), 278, 40)];
            usernameLabel.textColor = [UIColor whiteColor];
            usernameLabel.font = [UIFont fontWithName:MAIN_SEMIBOLDFONT_NAME size:24];
            usernameLabel.textAlignment = NSTextAlignmentCenter;
            usernameLabel.text = sharedConnect.submittedGuess.guessedUser.userUsername;
            [resultView addSubview:usernameLabel];
            
            buttonY = CGRectGetMaxY(usernameLabel.frame) + 40;
        }
        else{
            buttonY = CGRectGetMaxY(imageView.frame) + 40;
        }
        
        UIButton *continueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonY+65, 278, 40)];
        if (correct)
            [continueButton setFrame:CGRectMake(0, buttonY, 278, 40)];
        continueButton.backgroundColor = RGB(143, 209, 158);
        continueButton.layer.cornerRadius = 10;
        continueButton.clipsToBounds = YES;
        [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
        [continueButton addTarget:self action:@selector(dismissResultModal) forControlEvents:UIControlEventTouchUpInside];
        [resultView addSubview:continueButton];
        
        [resultView setFrame:CGRectMake(21, ([UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(continueButton.frame))/2, 278, CGRectGetMaxY(continueButton.frame))];
        
        [[KGModal sharedInstance] showWithContentView:resultView andAnimated:YES];
    }];
}

- (void)dismissResultModal{
    sharedConnect.containerScrollView.scrollEnabled = YES;
    
    [[KGModal sharedInstance] hideAnimated:YES];
    
    sharedConnect.submittedGuess = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Data loading methods

- (void)reloadData:(BOOL)reloadAll {
    loading = YES;
    [hud show:YES];
    [sharedConnect usersForGuess:self.post.user.userID onCompletion:^(NSArray *users, ServerResponse serverResponseCode) {
        loading = NO;
        [hud hide:YES];
        usersTableView.hidden = NO;
        
        userArray = [[NSMutableArray alloc] initWithArray:users];
        uint32_t rndPos = arc4random_uniform([userArray count]);
        [userArray insertObject:@{@"userID":[NSString stringWithFormat:@"%d", self.post.user.userID], @"username":self.post.user.userUsername} atIndex:rndPos];
        selectedRowInd = -1;
        [usersTableView reloadData];
        [refreshManager tableViewReloadFinishedAnimated:YES];
    }];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AGuessCell";
    AGuessCell *cell = (AGuessCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.delegate = self;
//    cell.comment = self.comments[indexPath.row];
    cell.usernameDict = userArray[indexPath.row];
    if(indexPath.row == selectedRowInd)
    {
        cell.circleSelected.hidden = NO;
    }
    else{
        cell.circleSelected.hidden = YES;
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
    NSInteger oldSelectedInd = selectedRowInd;
    selectedRowInd = indexPath.row;
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldSelectedInd inSection:0], [NSIndexPath indexPathForRow:selectedRowInd inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
