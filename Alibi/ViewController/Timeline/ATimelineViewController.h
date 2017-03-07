//
//  ATimelineViewController.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AViewController.h"

@interface ATimelineViewController : AViewController <AViewControllerRefreshProtocol>

@property (strong, nonatomic) IBOutlet UITableView *tableViewRefresh;
@property (strong, nonatomic) NSArray *posts;


@end
