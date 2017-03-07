//
//  ACreateUsernameViewController.h
//  Alibi
//
//  Created by AnMac on 6/26/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AViewController.h"

@interface ACreateUsernameViewController : AViewController<UITextFieldDelegate>

@property (nonatomic, strong) NSDictionary *userDict;

@end
