//
//  AContainerViewController.h
//  Alibi
//
//  Created by AnMac on 7/13/15.
//  Copyright (c) 2015 Goran Vuksic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AContainerViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) UINavigationController *navVC1;

@property (nonatomic, strong) UINavigationController *navVC2;

@property (nonatomic, strong) UINavigationController *navProfile;

@property (nonatomic, strong) UINavigationController *navLogin;

@end
