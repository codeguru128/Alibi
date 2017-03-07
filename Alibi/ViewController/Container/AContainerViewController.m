//
//  AContainerViewController.m
//  Alibi
//
//  Created by AnMac on 7/13/15.
//  Copyright (c) 2015 Goran Vuksic. All rights reserved.
//

#import "AContainerViewController.h"
#import "AClubsViewController.h"
#import "AMainFeedViewController.h"
#import "AProfileViewController.h"
#import "ALoginStartViewController.h"

@interface AContainerViewController (){
    IBOutlet UIScrollView *containerScrollView;
}

@end

@implementation AContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    containerScrollView.pagingEnabled = YES;
    containerScrollView.contentSize = CGSizeMake(320*3, 568);
    
    AClubsViewController *groupVC = (AClubsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AClubsViewController"];
    self.navVC1 = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigation"];
    [self.navVC1 pushViewController:groupVC animated:YES];
    groupVC.navigationItem.hidesBackButton = YES;
    [self addChildViewController:self.navVC1];
    
    [containerScrollView addSubview:self.navVC1.view];
    [self.navVC1 didMoveToParentViewController:self];
    
    self.navVC2 = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigation"];
    [self addChildViewController:self.navVC2];
    
    self.navVC2.view.frame = CGRectMake(320, 0, self.navVC2.view.frame.size.width, self.navVC2.view.frame.size.height);
    [containerScrollView addSubview:self.navVC2.view];
    [self.navVC2 didMoveToParentViewController:self];
    
    AProfileViewController *profileVC = (AProfileViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AProfileViewController"];
    self.navProfile = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigation"];
    [self.navProfile pushViewController:profileVC animated:YES];
    profileVC.navigationItem.hidesBackButton = YES;
    [self addChildViewController:self.navProfile];
    
    self.navProfile.view.frame = CGRectMake(640, 0, self.navProfile.view.frame.size.width,self.navProfile.view.frame.size.height);
    [containerScrollView addSubview:self.navProfile.view];
    [self.navProfile didMoveToParentViewController:self];
    
    ALoginStartViewController *loginVC = (ALoginStartViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ALoginStartViewController"];
    self.navLogin = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigation"];
    [self.navLogin pushViewController:loginVC animated:YES];
    loginVC.navigationItem.hidesBackButton = YES;
    [self addChildViewController:self.navLogin];
    
    self.navLogin.view.frame = CGRectMake(640, 0, self.navLogin.view.frame.size.width,self.navLogin.view.frame.size.height);
    [containerScrollView addSubview:self.navLogin.view];
    [self.navLogin didMoveToParentViewController:self];
    
    if ([AConnect sharedConnect].currentUser){
        self.navLogin.view.hidden = YES;
    }
    else{
        self.navProfile.view.hidden = YES;
    }
    
    [containerScrollView setContentOffset:CGPointMake(320, 0)];
    [AConnect sharedConnect].containerScrollView = containerScrollView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(page == 0){
        [self.navVC1.visibleViewController viewDidAppear:YES];
    }
    else if(page == 1){
        [self.navVC2.visibleViewController viewDidAppear:YES];
    }
    else if (page == 2) {
        if (![AConnect sharedConnect].currentUser){
//            self.navProfile.view.hidden = NO;
//            self.navLogin.view.hidden = YES;
//            [self.navProfile.visibleViewController viewDidAppear:YES];
//        }
//        else{
            self.navProfile.view.hidden = YES;
            self.navLogin.view.hidden = NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
