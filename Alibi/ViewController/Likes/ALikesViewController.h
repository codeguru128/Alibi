//
//  ALikesViewController.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AViewController.h"

@interface ALikesViewController : AViewController

@property (strong, nonatomic) NSMutableArray *likes;
@property (strong, nonatomic) APost *post;
@property (strong, nonatomic) IBOutlet UITableView *tableViewRefresh;

@end
