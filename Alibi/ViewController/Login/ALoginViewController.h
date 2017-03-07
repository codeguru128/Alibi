//
//  ALoginViewController.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AViewController.h"

@interface ALoginViewController : AViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewLogin;
@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UIView *viewContentLogin;

- (IBAction)buttonRegisterTouchUpInside:(id)sender;

@end
