//
//  AProfileViewController.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AConnect.h"
#import "UIImageView+AFNetworking.h"
#import "AViewController.h"

@interface AProfileViewController : AViewController<UITableViewDataSource, UITableViewDelegate> {    
    IBOutlet UITableView *profileTableView;
}
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;

@property (nonatomic, strong) AUser *user;

@end
