//
//  ClubsViewController.m
//  Alibi
//
//  Created by AnMac on 7/1/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import "AClubsViewController.h"
#import "AClub.h"
#import "ALoadingCell.h"
#import "AContainerViewController.h"

@interface AClubsViewController (){
}

@end

@implementation AClubsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CLUBS";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addButtonPressed:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self reloadData:YES];
    
    self.tableViewRefresh.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    loadMore = YES;
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
    
    if(indexPath.section == 2){
        AClubPasscodeViewController *passcodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AClubPasscodeViewController"];
        passcodeVC.club = self.clubs[indexPath.section][indexPath.row];
        passcodeVC.delegate = self;
        [self presentViewController:passcodeVC animated:YES completion:nil];
    }
    else{
        [self setClubAndGo:self.clubs[indexPath.section][indexPath.row]];
    }
    
}

- (void)addButtonPressed:(id)sender{
    AClubAddViewController *addVC = [self.storyboard
            instantiateViewControllerWithIdentifier:@"AClubAddViewController" ];
    [self presentViewController:addVC animated:YES completion:nil];
    
}

- (void)setClubAndGo:(AClub *)club{
    sharedConnect.currentClub = club;
    [sharedConnect saveCurrentClub];
    [sharedConnect.containerScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    
    [self reloadData:YES];
    
    AContainerViewController *containerVC = (AContainerViewController *)self.navigationController.parentViewController;
    [containerVC.navVC2.visibleViewController viewDidAppear:YES];
}

- (void)didEnterPasscodeCorrect:(AClub *)club{
    [self setClubAndGo:club];
}

#pragma mark - Data loading methods

- (void)reloadData:(BOOL)reloadAll {
    
    loading = YES;
    [sharedConnect getAllClubs:sharedConnect.currentUser.userID onCompletion:^(NSMutableArray *clubs, ServerResponse serverResponseCode) {
        loading = NO;
        
        self.clubs = [NSMutableArray arrayWithArray:@[[NSMutableArray array], [NSMutableArray array], [NSMutableArray array]]];
        
        for(AClub *club in clubs){
            if([club.clubPasscode isEqualToString:@""])
                [self.clubs[0] addObject:club];
            else{
                if([[NSUserDefaults  standardUserDefaults] objectForKey:[NSString stringWithFormat:@"club%i_unlocked", club.clubID]]){
                    [self.clubs[1] addObject:club];
                }
                else{
                    [self.clubs[2] addObject:club];
                }
            }
        }

        [self.tableViewRefresh reloadData];
        [refreshManager tableViewReloadFinishedAnimated:YES];
    }];
}


#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AClubCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *labelName = (UILabel *)[cell viewWithTag:202];
    AClub *club = self.clubs[indexPath.section][indexPath.row];
    labelName.text = club.clubName;
    
    UIImageView *imageViewTick = (UIImageView *)[cell viewWithTag:201];
    if(sharedConnect.currentClub.clubID == club.clubID)
        imageViewTick.image = [UIImage imageNamed:@"check"];
    else
        imageViewTick.image = nil;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.clubs.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *iconName, *title;
    if(section == 0){
        iconName = @"featured";
        title = @"FEATURED CLUBS";
    }
    else if(section == 1){
        iconName = @"myclub";
        title = @"MY CLUBS";
    }
    else if(section == 2){
        iconName = @"private";
        title = @"PRIVATE CLUBS";
    }
    
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ClubCategory" owner:nil options:nil];
    UIView* viewHeader = nibs[0];
    
    UIImageView *imageViewIcon = (UIImageView *)[viewHeader viewWithTag:201];
    UILabel *labelTitle = (UILabel *)[viewHeader viewWithTag:202];
    
    imageViewIcon.image = [UIImage imageNamed:iconName];
    labelTitle.text = title;
    
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSMutableArray *clubs = self.clubs[section];
    if(clubs.count > 0)
        return 38;
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *clubs = self.clubs[section];
    return clubs.count;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
