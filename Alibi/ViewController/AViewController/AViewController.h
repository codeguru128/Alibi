//
//  AViewController.h
//  Alibi
//
//  Created by Matias Willand on 9/30/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PNTToolbar.h"
#import "APostCell.h"
#import "MNMPullToRefreshManager.h"
#import "AConnect.h"

@protocol AViewControllerRefreshProtocol <NSObject>

@property (strong, nonatomic) UITableView *tableViewRefresh;
- (void)reloadData:(BOOL)reloadAll;

@end

@interface AViewController : UIViewController <ACellDelegate, MNMPullToRefreshManagerClient> {
    
    PNTToolbar *toolbar;
    MNMPullToRefreshManager *refreshManager;
    MBProgressHUD *hud;
    BOOL loadMore;
    BOOL loading;
    __weak AConnect *sharedConnect;
}

@end
