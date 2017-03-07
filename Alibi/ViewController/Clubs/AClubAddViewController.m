//
//  AClubPasscodeViewController.m
//  Alibi
//
//  Created by AnMac on 8/27/15.
//  Copyright (c) 2015 Goran Vuksic. All rights reserved.
//

#import "AClubAddViewController.h"

@interface AClubAddViewController (){
    IBOutlet UITextField *textFieldSchoolName;
}

@end

@implementation AClubAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [textFieldSchoolName becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.text){
        [self dismissViewControllerAnimated:YES completion:^{
            ALERT(@"Uh oh!", @"It seems your school doesn't have enough users to have a club, get 8 of your friends to request it using this menu and we will add your school!");
        }];
    }
    else{
        ALERT(@"", @"Please input something");
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
