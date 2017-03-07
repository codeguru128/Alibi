//
//  AGuessViewController.h
//  Alibi
//
//  Created by AnMac on 6/27/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AViewController.h"

@interface AGuessViewController : AViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) APost *post;

@end
