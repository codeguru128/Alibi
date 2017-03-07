//
//  AWelcomeViewController.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALoginViewController.h"
#import "ARegisterViewController.h"

@protocol AWelcomeViewControllerDelegate <NSObject>

- (void)showLogin;
- (void)showRegister;

@end

@interface AWelcomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) id <AWelcomeViewControllerDelegate> delegate;

- (IBAction)buttonLoginTouchUpInside:(id)sender;
- (IBAction)buttonRegisterTouchUpInside:(id)sender;

@end
