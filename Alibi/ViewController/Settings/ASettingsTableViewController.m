//
//  ASettingsTableViewController.m
//  Alibi
//
//  Created by AnMac on 8/26/15.
//  Copyright (c) 2015 Goran Vuksic. All rights reserved.
//

#import "ASettingsTableViewController.h"

@interface ASettingsTableViewController (){
    IBOutlet UIButton *buttonIG;
    
    IBOutlet UIButton *buttonTW;
    IBOutlet UILabel *buttonPP;
    
    IBOutlet UIButton *buttonFB;
    
    IBOutlet UISwitch *switchPN;
}

@end

@implementation ASettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"SETTINGS";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if([AConnect sharedConnect].currentUser.pnOn)
        switchPN.on = YES;
    else
        switchPN.on = NO;

    [switchPN addTarget:self action:@selector(switchPNChanged) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)onSpreadButtonClicked:(id)sender{
    
    NSString *url;
    
    if(sender == buttonIG){
        url = @"https://instagram.com/alibichat";
    }
    else if(sender == buttonTW){
        url = @"https://www.twitter.com/alibichat";
    }
    else if(sender == buttonFB){
        url = @"https://www.facebook.com/alibichatapp";
    }
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

- (void)switchPNChanged{
    [[AConnect sharedConnect] setPNWithUserID:[AConnect sharedConnect].currentUser.userID PN:switchPN.on onCompletion:^(AUser *user, ServerResponse serverResponseCode) {
        if(serverResponseCode == OK){
            ALERT(@"", @"Push Notification settings changed");
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 12;
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
    
    if(indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 11){
        if([MFMailComposeViewController canSendMail]) {
            
            NSString *receipientEmail = @"info@alibichat.com";
            if(indexPath.row == 10)
                receipientEmail = @"NewClub@alibichat.com";
            else if(indexPath.row == 11)
                receipientEmail = @"Clubs@alibichat.com";
            
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            
            [mailCont setSubject:@""];
            [mailCont setToRecipients:[NSArray arrayWithObject:receipientEmail]];
            [mailCont setMessageBody:@"" isHTML:NO];
            
            [self presentViewController:mailCont animated:YES completion:^{ }];
        }
    }
    else if(indexPath.row == 4 || indexPath.row == 5)
    {
        NSString *pp = [NSString stringWithFormat:@"http://alibichat.com/documentation/privacypolicy/"];
        NSString *tos = [NSString stringWithFormat:@"http://alibichat.com/documentation/"];
        
        if(indexPath.row == 4)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tos]];
        if(indexPath.row == 5)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pp]];
    }
//    [sharedConnect.containerScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
}

// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
