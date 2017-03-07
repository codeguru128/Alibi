//
//  ACommentsViewController.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface APostViewController : AViewController <AViewControllerRefreshProtocol, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViewRefresh;
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) IBOutlet UIView *viewEnterComment;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEnterComment;
@property (strong, nonatomic) APost *post;

@end
