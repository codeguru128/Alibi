//
//  AClubPasscodeViewController.m
//  Alibi
//
//  Created by AnMac on 8/27/15.
//  Copyright (c) 2015 Goran Vuksic. All rights reserved.
//

#import "AClubPasscodeViewController.h"

@interface AClubPasscodeViewController (){
    IBOutlet UITextField *textFieldPasscode;
}

@end

@implementation AClubPasscodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [textFieldPasscode becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField.text isEqualToString:self.club.clubPasscode]){
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"club%i_unlocked", self.club.clubID]];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate didEnterPasscodeCorrect:self.club];
    }
    else{
        ALERT(@"", @"Your passcode is incorrect. Please try again.");
    }
    return YES;
}

- (IBAction)didBackClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
