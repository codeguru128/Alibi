//
//  AInstagramLoginViewController.h
//  Alibi
//
//  Created by AnMac on 6/26/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAppDelegate.h"
#import "OAuthConsumer.h"

@interface AInstagramLoginViewController : AViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webview;
    OAConsumer* consumer;
    OAToken* requestToken;
    OAToken* accessToken;
    NSMutableData *receivedData;
}

//@property (nonatomic, retain) IBOutlet TapazineLoadingIndicator *indicator;
@property (nonatomic, retain) NSString *isLogin;
@property (assign, nonatomic) Boolean isReader;
@end