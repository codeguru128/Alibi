//
//  AClubPasscodeViewController.h
//  Alibi
//
//  Created by AnMac on 8/27/15.
//  Copyright (c) 2015 Goran Vuksic. All rights reserved.
//

#import "AViewController.h"
#import "AClub.h"

@protocol  AClubAddVCDelegate;

@interface AClubAddViewController : AViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSString *clubname;

@end

@protocol AClubAddVCDelegate <NSObject>

@end