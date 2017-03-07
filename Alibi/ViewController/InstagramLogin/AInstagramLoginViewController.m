//
//  AInstagramLoginViewController.m
//  Alibi
//
//  Created by AnMac on 6/26/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import "AInstagramLoginViewController.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "ACreateUsernameViewController.h"

@interface AInstagramLoginViewController (){
    NSString *client_id;
    NSString *secret;
    NSString *callback;
    
    NSDictionary *instagramUserDict;
}

@end

@implementation AInstagramLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"INSTAGRAM LOGIN";
    
    client_id = @"a134b49936e74b3787fa28deb0bc7ea3";
    secret = @"c969862783ba48bf915bfc5535c2e0de";
    callback = @"http://api.alibichat.com/alibi/api/index.php"; // sample call back URL
    
    
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code",client_id,callback];
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    [hud show:YES];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //    [indicator startAnimating];
    if ([[[request URL] host] isEqualToString:@"api.alibichat.com"]) {
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"code"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            
            NSString *data = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",client_id,secret,callback,verifier];
            
            NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token"];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            receivedData = [[NSMutableData alloc] init];
        } else {
            // ERROR!
        }
        
        [webView removeFromSuperview];
        
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hide:YES];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"%@", error]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    SBJsonParser *jResponse = [[SBJsonParser alloc]init];
    NSDictionary *tokenData = [jResponse objectWithString:response];
    instagramUserDict = tokenData[@"user"];
    NSLog(@"%@", instagramUserDict[@"profile_picture"]);
    
    [sharedConnect loginUserWithInstagram:instagramUserDict[@"id"] ProfilePictureURL:instagramUserDict[@"profile_picture"] onCompletion:^(AUser *user, ServerResponse serverResponseCode) {
        [hud hide:YES];
        if (serverResponseCode == OK) {
            [sharedConnect.containerScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
            [self performSegueWithIdentifier:@"goMyProfile" sender:nil];
        } else if (serverResponseCode == NO_CONNECTION) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No connection. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else{
            [self performSegueWithIdentifier:@"GoCreateUsername" sender:nil];
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"GoCreateUsername"]){
        ACreateUsernameViewController *vc = (ACreateUsernameViewController *)segue.destinationViewController;
        vc.userDict = instagramUserDict;
    }
}

@end
