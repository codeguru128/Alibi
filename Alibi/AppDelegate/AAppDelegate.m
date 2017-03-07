//
//  AAppDelegate.m
//  Alibi
//
//  Created by Matias Willand on 6/20/2015.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AAppDelegate.h"
#import "ANewPostViewController.h"
#import "ANearbyViewController.h"
#import "APopularViewController.h"
#import "AProfileViewController.h"
#import "ATimelineViewController.h"
#import "AConnect.h"

#import "TSMessageView.h"
#import "TSMessage.h"
#import "KGModal.h"


@implementation AAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    

    
    CLAuthorizationStatus locationAuthorizationStatus = [CLLocationManager authorizationStatus];
    if (locationAuthorizationStatus != kCLAuthorizationStatusDenied) {
        self.locationManager = [[CLLocationManager alloc] init];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
            [self.locationManager performSelector:@selector(requestWhenInUseAuthorization) withObject:nil];
        }
    }
    
//    for (NSString *familyName in [UIFont familyNames]) {
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"%@", fontName);
//        }
//    }
    
//    [self createViewHierarchy];
    
    if(UNIQUE_ID == nil){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger: -rand()] forKey:@"uniqueID"];
        
    }
    
    // navigation bar appearance
    [[UINavigationBar appearance] setBarTintColor:NAVBAR_BACK_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-back64.png"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-back44.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    // status bar appearance
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
         
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", newToken] forKey:@"device_token"];
    //    DEVICE_TOKEN = deviceToken;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:userInfo];
    if (application.applicationState == UIApplicationStateActive) {
        NSString *alertBody = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    //    NSString *body = [[NSString alloc]initWithFormat:@"%@", [userInfo objectForKey:@"body"]];
        [TSMessage showNotificationWithTitle:alertBody type:TSMessageNotificationTypeMessage];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - UITabBarControllerDelegate methods

- (BOOL)tabBarController:(UITabBarController *)tabBarController  shouldSelectViewController:(UIViewController *)viewController {
    
    UINavigationController *navigationViewController = (UINavigationController *)viewController;
    if ([navigationViewController.topViewController isKindOfClass:[ANewPostViewController class]]) {
        ANewPostViewController *newPostViewController = [[ANewPostViewController alloc] initWithNibName:@"ANewPostViewController" bundle:nil];
        UINavigationController *newPostNavigationController = [[UINavigationController alloc] initWithRootViewController:newPostViewController];
        newPostNavigationController.navigationBar.translucent = NO;
        [tabBarController presentViewController:newPostNavigationController animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - Other methods

- (void)createViewHierarchy {
    
    ATimelineViewController *timelineViewController = [[ATimelineViewController alloc] initWithNibName:@"ATimelineViewController" bundle:nil];
    UINavigationController *timelineNavigationController = [[UINavigationController alloc] initWithRootViewController:timelineViewController];
    timelineNavigationController.navigationBar.translucent = NO;
    
    APopularViewController *popularViewController = [[APopularViewController alloc] initWithNibName:@"APopularViewController" bundle:nil];
    UINavigationController *popularNavigationController = [[UINavigationController alloc] initWithRootViewController:popularViewController];
    popularNavigationController.navigationBar.translucent = NO;
    
    ANewPostViewController *newPostViewController = [[ANewPostViewController alloc] initWithNibName:@"ANewPostViewController" bundle:nil];
    UINavigationController *newPostNavigationController = [[UINavigationController alloc] initWithRootViewController:newPostViewController];
    newPostNavigationController.navigationBar.translucent = NO;
    
    ANearbyViewController *nearbyViewController = [[ANearbyViewController alloc] initWithNibName:@"ANearbyViewController" bundle:nil];
    UINavigationController *nearbyNavigationController = [[UINavigationController alloc] initWithRootViewController:nearbyViewController];
    nearbyNavigationController.navigationBar.translucent = NO;
    
    AProfileViewController *profileViewController = [[AProfileViewController alloc] initWithNibName:@"AProfileViewController" bundle:nil];
    UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    profileNavigationController.navigationBar.translucent = NO;
    
    self.tabBarController = [[ATabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[timelineNavigationController, popularNavigationController,newPostNavigationController, nearbyNavigationController, profileNavigationController];

    UITabBarItem *timelineTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Timeline" image:[[UIImage imageNamed:@"tabbar-timeline"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar-timeline"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    timelineViewController.tabBarItem = timelineTabBarItem;
    UITabBarItem *popularTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Popular" image:[[UIImage imageNamed:@"tabbar-popular"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar-popular"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    popularViewController.tabBarItem = popularTabBarItem;
    UITabBarItem *newPostTabBarItem = [[UITabBarItem alloc] initWithTitle:@"New post" image:[[UIImage imageNamed:@"tabbar-newpost"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar-newpost"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    newPostViewController.tabBarItem = newPostTabBarItem;
    UITabBarItem *nearbyTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Nearby" image:[[UIImage imageNamed:@"tabbar-nearby"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar-nearby"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    nearbyViewController.tabBarItem = nearbyTabBarItem;
    UITabBarItem *profileTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[[UIImage imageNamed:@"tabbar-profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tabbar-profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    profileViewController.tabBarItem = profileTabBarItem;
    
    self.window.rootViewController = self.tabBarController;
}

@end
