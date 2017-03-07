//
//  ClubsViewController.h
//  Alibi
//
//  Created by AnMac on 7/1/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AViewController.h"
#import "AClubPasscodeViewController.h"
#import "AClubAddViewController.h"

@interface AClubsViewController : AViewController<AViewControllerRefreshProtocol, AClubPasscodeVCDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViewRefresh;

@property (strong, nonatomic) UIBarButtonItem *addButton;

@property (strong, nonatomic) NSMutableArray *clubs;

@end
