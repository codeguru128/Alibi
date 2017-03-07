//
//  AClubPasscodeViewController.h
//  Alibi
//
//  Created by AnMac on 8/27/15.
//  Copyright (c) 2015 Goran Vuksic. All rights reserved.
//

#import "AViewController.h"
#import "AClub.h"

@protocol  AClubPasscodeVCDelegate;

@interface AClubPasscodeViewController : AViewController<UITextFieldDelegate>

@property (nonatomic, strong) AClub *club;

@property (nonatomic, assign) id<AClubPasscodeVCDelegate> delegate;

@end

@protocol AClubPasscodeVCDelegate <NSObject>

- (void)didEnterPasscodeCorrect:(AClub *)club;

@end