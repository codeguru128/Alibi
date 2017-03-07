//
//  AHomeViewController.h
//  Alibi
//
//  Created by AnMac on 6/24/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCPathButton.h"
#import "AViewController.h"
#import "MNMPullToRefreshManager.h"

@interface AMainFeedViewController : AViewController<DCPathButtonDelegate, UITableViewDataSource, UITableViewDelegate, MNMPullToRefreshManagerClient> {
    MNMPullToRefreshManager *feedRefreshManager;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewRefresh;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedSort;


- (IBAction)buttonSortBySelected:(id)sender;

@property (strong, nonatomic) NSMutableArray *posts;

@end