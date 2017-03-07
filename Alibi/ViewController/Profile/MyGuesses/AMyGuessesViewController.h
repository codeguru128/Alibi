//
//  AMyGuessesViewController.h
//  Alibi
//
//  Created by AnMac on 7/1/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AViewController.h"

@interface AMyGuessesViewController : AViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *posts;

@end
