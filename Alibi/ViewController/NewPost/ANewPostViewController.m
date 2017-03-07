//
//  ANewPostViewController.m
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "ANewPostViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ANewPostViewController


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"NEW POST";
    
    self.textViewPost.placeholder = @"Share what you are thinking!";
    
    [self.textViewPost becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons methods

- (IBAction)buttonSendTouchUpInside:(id)sender {
    
    if (!self.textViewPost.text.length) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        [hud show:YES];
        if ([self.textViewPost isFirstResponder]) {
            [self.textViewPost resignFirstResponder];
        }
        [sharedConnect sendPostWithTitle:self.textViewPost.text postKeywords:nil postImage:nil onCompletion:^(APost *post, ServerResponse serverResponseCode) {
            [hud hide:YES];
            
            if(serverResponseCode != OK)
                return;
            
            sharedConnect.currentUser.myPostsCount++;
            
            self.textViewPost.text = @"";
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

@end
