//
//  AFollowingViewController.h
//  Alibi
//
//  Created by Matias Willand on 03/01/14.
//  Copyright (c) 2014 Planet 1107. All rights reserved.
//

#import "AViewController.h"

@interface AFollowingViewController : AViewController

@property (strong, nonatomic) IBOutlet UITableView *tableViewRefresh;
@property (strong, nonatomic) AUser *user;
@property (strong, nonatomic) NSMutableArray *following;

@end
