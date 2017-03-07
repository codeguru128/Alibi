//
//  AHomeViewController.m
//  Alibi
//
//  Created by AnMac on 6/24/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import "AMainFeedViewController.h"
#import "APostCell.h"
#import "ALoadingCell.h"
#import "AConnect.h"
#import "AGuessViewController.h"
#import "AGuess.h"
#import "KGModal.h"
#import "AProfileViewController.h"

#import "EAIntroView.h"

#define ANIM_DURATION 0.2

@interface AMainFeedViewController (){
       
    IBOutlet UIView *bottomButtonsView;
    
    DCPathButton *centerButton;
    
    DCPathItemButton *groupsButton, *postButton, *profileButton;
    
    NSString *locationMode, *sortByMode;
    
    UIButton *buttonLocation, *buttonSortBy;
    UISegmentedControl *segmentSortBy;
    
    UIImageView *imageViewArrow1, *imageViewArrow2;
    
    IBOutlet UIView *viewButtonLocation;
    
    IBOutlet UIView *viewButtonSortBy;
    
    CLLocationManager *locationManager;
    
    CLLocation *currentLocation;
}

@end

@implementation AMainFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialViewed"]){
        EAIntroPage *page1 = [EAIntroPage page];
        page1.bgImage = [UIImage imageNamed:@"tut_iphone5_01"];
        EAIntroPage *page2 = [EAIntroPage page];
        page2.bgImage = [UIImage imageNamed:@"tut_iphone5_02"];
        EAIntroPage *page3 = [EAIntroPage page];
        page3.bgImage = [UIImage imageNamed:@"tut_iphone5_03"];
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
        
        [intro showFullscreenWithAnimateDuration:0.0];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorialViewed"];
    }
    
    id<AViewControllerRefreshProtocol> objectConformsToProtocol = (id<AViewControllerRefreshProtocol>)self;
    feedRefreshManager = [[MNMPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:objectConformsToProtocol.tableViewRefresh withClient:self];
    loadMore = YES;
    
    self.view.backgroundColor = MAIN_BACK_COLOR;
    self.tableViewRefresh.backgroundColor = MAIN_BACK_COLOR;
    self.tableViewRefresh.separatorColor = [UIColor clearColor];
    

    [self.navigationItem.backBarButtonItem setTitle:@""];
    
    centerButton = [[DCPathButton alloc] initWithCenterImage:[UIImage imageNamed:@"paost"]
                                                          highlightedImage:[UIImage imageNamed:@"post"]];
    [bottomButtonsView addSubview:centerButton];
    centerButton.delegate = self;
    groupsButton = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"groups"]
                                                           highlightedImage:[UIImage imageNamed:@"groups"]
                                                            backgroundImage:nil
                                                 backgroundHighlightedImage:nil];
    [centerButton addPathItems:@[groupsButton]];
    
    postButton = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"post"]
                                         highlightedImage:[UIImage imageNamed:@"post"]
                                          backgroundImage:nil
                               backgroundHighlightedImage:nil];
    [centerButton addPathItems:@[postButton]];
    
    profileButton = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"profile"]
                                       highlightedImage:[UIImage imageNamed:@"profile"]
                                        backgroundImage:nil
                             backgroundHighlightedImage:nil];
    [centerButton addPathItems:@[profileButton]];
    
    locationMode = @"national";
    sortByMode = @"recent";
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.tableViewRefresh addGestureRecognizer:doubleTap];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    currentLocation = locationManager.location;
}

- (void)viewDidAppear:(BOOL)animated{
    if(sharedConnect.currentClub)
        self.title = [sharedConnect.currentClub.clubName uppercaseString];
    else {
        sharedConnect.currentClub.clubID = 1;
        self.title = @"GENERAL";
    }
    
    
    int score = (sharedConnect.currentUser.myGuessesCount * 3) + (sharedConnect.currentUser.myPostsCount*5);
    NSString *sscore = [NSString stringWithFormat:@"%i", score];
    UIBarButtonItem *scoreButton = [[UIBarButtonItem alloc] initWithTitle:sscore style:UIBarButtonItemStylePlain target:self action:nil];
    
    [scoreButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"Helvetica-Bold" size:18.0], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = scoreButton;
    self.posts = [[NSMutableArray alloc] init];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    
    [self reloadData:YES];
    [centerButton pathCenterButtonBloom];
    
    if(sharedConnect.submittedGuess){
    }
}

- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
//    NSLog(@"You tap %@ at index : %lu", dcPathButton, (unsigned long)itemButtonIndex);
    if(itemButtonIndex == 1){
        if (![AConnect sharedConnect].currentUser) {
            [sharedConnect.containerScrollView setContentOffset:CGPointMake(640, 0) animated:YES];
        }
        else{
            [self performSegueWithIdentifier:@"GoNewPost" sender:nil];
        }
    }
    else if(itemButtonIndex == 0){
        [sharedConnect.containerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self showPathButtons:0.5];
    }
    else if(itemButtonIndex == 2){
        [sharedConnect.containerScrollView setContentOffset:CGPointMake(640, 0) animated:YES];
    }
    [self showPathButtons:0.5];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
 //   [self hideDropDown];
 //   [centerButton pathCenterButtonFold];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
        [feedRefreshManager tableViewReleased];
}

- (void)showPathButtons: (CGFloat)delay{
    double delayInSeconds = delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [centerButton pathCenterButtonBloom];
    });
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   // [centerButton pathCenterButtonBloom];
}

-(void)doubleTap:(UITapGestureRecognizer*)tap
{
    if (UIGestureRecognizerStateEnded == tap.state)
    {
        CGPoint p = [tap locationInView:tap.view];
        NSIndexPath* indexPath = [self.tableViewRefresh indexPathForRowAtPoint:p];
        if(indexPath.section == 2){
            APostCell* cell = (APostCell *)[self.tableViewRefresh cellForRowAtIndexPath:indexPath];
            [cell.buttonLike sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    [sharedConnect setLatLongWithUserID:sharedConnect.currentUser.userID latitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude onCompletion:^(AUser *user, ServerResponse serverResponseCode){
    }];
}

#pragma mark - Data loading methods

- (void)reloadData:(BOOL)reloadAll{
    if(loading)
        return;
    
    loading = YES;
    
    float latitude = currentLocation.coordinate.latitude;
    float longitude = currentLocation.coordinate.longitude;
    
    int page;
    if (reloadAll) {
        loadMore = YES;
        page = 1;
        [self.tableViewRefresh reloadData];
    } else {
        page  = (int)(self.posts.count / kDefaultPageSize) + 1;
    }
    [sharedConnect timelineForUserID:sharedConnect.currentUser.userID latitude:latitude longitude:longitude locationMode:locationMode sortByMode:sortByMode page:page pageSize:kDefaultPageSize onCompletion:^(NSMutableArray *posts, ServerResponse serverResponseCode) {
        loading = NO;
        if(reloadAll){
            self.posts = posts;
        }
        else{
            [self.posts addObjectsFromArray:posts];
        }
        loadMore = posts.count == kDefaultPageSize;
        [self.tableViewRefresh reloadData];
        [feedRefreshManager tableViewReloadFinishedAnimated:YES];
    }];
    
    [sharedConnect setLatLongWithUserID:sharedConnect.currentUser.userID latitude:latitude longitude:longitude onCompletion:^(AUser *user, ServerResponse serverResponseCode){
    }];
}

- (IBAction)buttonDropDownClicked:(UIButton *)sender{
    
    UIImageView *imageViewArrow;
    UIView *viewButton;
    
    if(sender.tag == 200){
        viewButton = viewButtonLocation;
        imageViewArrow = imageViewArrow1;
    }
    else{
        viewButton = viewButtonSortBy;
        imageViewArrow = imageViewArrow2;
    }
    
    viewButton.frame = CGRectMake(viewButton.frame.origin.x, 82 - self.tableViewRefresh.contentOffset.y, viewButton.frame.size.width, viewButton.frame.size.height);
    
    BOOL shouldShow = YES;

    if(viewButtonLocation.frame.size.height != 0 || viewButtonSortBy.frame.size.height != 0){
        if((viewButton == viewButtonSortBy && viewButtonLocation.frame.size.height != 0) || (viewButton == viewButtonLocation && viewButtonSortBy.frame.size.height != 0)){
            shouldShow = YES;
        }
        else
            shouldShow = NO;
        [self hideDropDown];
    }
    
    if(shouldShow){
        imageViewArrow.image = [UIImage imageNamed:@"option_arrow_on"];
        [UIView animateWithDuration:ANIM_DURATION animations:^{
            viewButton.frame = CGRectMake(viewButton.frame.origin.x, viewButton.frame.origin.y, viewButton.frame.size.width, 76);
        }];
    }
}

- (IBAction)buttonLocationSelected:(UIButton *)sender{
    NSArray *iconArray = @[@"national", @"local"];
    
    NSString *newLocationMode;
    UIButton *anotherButton;
    if(sender.tag == 200){
        anotherButton = (UIButton *)[sender.superview viewWithTag:201];
        newLocationMode = @"national";
    }
    else{
        anotherButton = (UIButton *)[sender.superview viewWithTag:200];
        newLocationMode = @"local";
    }
    
    if(![newLocationMode isEqualToString:locationMode]){
        locationMode = newLocationMode;
        [self.posts removeAllObjects];
        [self reloadData:YES];
    }
    
    [buttonLocation setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    [buttonLocation setImage:[UIImage imageNamed:iconArray[sender.tag-200]] forState:UIControlStateNormal];
    buttonLocation.contentEdgeInsets = sender.contentEdgeInsets;
    buttonLocation.titleEdgeInsets = sender.titleEdgeInsets;
    
    if(sender.tag == 201)
        buttonLocation.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    sender.backgroundColor = NAVBAR_BACK_COLOR;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *iconName = [NSString stringWithFormat:@"%@_on", iconArray[sender.tag-200]];
    [sender setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    
    anotherButton.backgroundColor = BUTTON_GRAY_BACK_COLOR;
    [anotherButton setTitleColor:MAIN_GRAY_FONT_COLOR forState:UIControlStateNormal];
    [anotherButton setImage:[UIImage imageNamed:iconArray[anotherButton.tag-200]] forState:UIControlStateNormal];
    
    [self hideDropDown];
}

- (IBAction)buttonSortBySelected:(id)sender{
    
    NSInteger clickedsegment = [sender selectedSegmentIndex];
    NSString *newSortByMode;
   
    if(clickedsegment == 0){
        newSortByMode = @"recent";
    }
    else if(clickedsegment == 1){
        newSortByMode = @"hot";
    }
    
    sortByMode = newSortByMode;
    [self.posts removeAllObjects];
    [self reloadData:YES];
}

- (void)hideDropDown{
    imageViewArrow1.image = [UIImage imageNamed:@"option_arrow"];
    if(viewButtonLocation.frame.size.height != 0){
        [UIView animateWithDuration:ANIM_DURATION animations:^{
            viewButtonLocation.frame = CGRectMake(viewButtonLocation.frame.origin.x, viewButtonLocation.frame.origin.y, viewButtonLocation.frame.size.width, 0);
        }];
    }
    
    imageViewArrow2.image = [UIImage imageNamed:@"option_arrow"];
    if(viewButtonSortBy.frame.size.height != 0){
        [UIView animateWithDuration:ANIM_DURATION animations:^{
            viewButtonSortBy.frame = CGRectMake(viewButtonSortBy.frame.origin.x, viewButtonSortBy.frame.origin.y, viewButtonSortBy.frame.size.width, 0);
        }];
    }
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        static NSString *CellIdentifier = @"APostTypeCell";
        ALoadingCell *cell = (ALoadingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        buttonLocation = (UIButton *)[cell viewWithTag:200];
        buttonSortBy = (UIButton *)[cell viewWithTag:201];
        
        imageViewArrow1 = (UIImageView *)[cell viewWithTag:100];
        imageViewArrow2 = (UIImageView *)[cell viewWithTag:101];
        
        CALayer *sublayerLeft = [CALayer layer];
        sublayerLeft.backgroundColor = RGB(198, 198, 198).CGColor;
        sublayerLeft.frame = CGRectMake(0, 0, 1, buttonLocation.frame.size.height);
        [buttonLocation.layer addSublayer:sublayerLeft];
        
        CALayer *sublayerRight = [CALayer layer];
        sublayerRight.backgroundColor = RGB(198, 198, 198).CGColor;
        sublayerRight.frame = CGRectMake(buttonLocation.bounds.size.width-1, 0, 1, buttonLocation.frame.size.height);
        [buttonLocation.layer addSublayer:sublayerRight];
        
        return cell;
    }
    if (indexPath.section == 2){
        static NSString *CellIdentifier = @"APostCell";
        APostCell *cell = (APostCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.post = self.posts[indexPath.row];
        cell.delegate = self;
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"ALoadingCell";
        ALoadingCell *cell = (ALoadingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ALoadingCell" owner:self options:nil] lastObject];
        }
        
        cell.backgroundColor = MAIN_BACK_COLOR;

        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    if (section == 2) {
        return self.posts.count;
    } else if (section == 1){
        if(loading){
            return 1;
        }
        else{
            return 0;
        }
    } else {
        if (loadMore) {
            return 1;
        } else {
            return 0;
        }
    }
}


#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return 38;
    }
    if (indexPath.section == 2) {
        return [APostCell sizeWithPost:self.posts[indexPath.row] :tableView].height;
    } else if (indexPath.section == 1){
        return 44 * loading * self.posts.count == 0;
    } else {
        return 44 * loadMore;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3 && loadMore && !loading) {
        [self reloadData:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideDropDown];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [feedRefreshManager tableViewScrolled];
}

- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager {
    
    if (!loading) {
        id<AViewControllerRefreshProtocol> objectConformsToProtocol = (id<AViewControllerRefreshProtocol>)self;
        [objectConformsToProtocol reloadData:YES];
    } else {
        [feedRefreshManager tableViewReloadFinishedAnimated:YES];
    }
}

@end
