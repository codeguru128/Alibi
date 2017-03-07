//
//  AAppDelegate.h
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATabBarController.h"
#import <CoreLocation/CoreLocation.h>

@interface AAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ATabBarController *tabBarController;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)createViewHierarchy;

@end
