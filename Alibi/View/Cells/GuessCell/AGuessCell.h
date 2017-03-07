//
//  AGuessCell.h
//  Alibi
//
//  Created by AnMac on 6/27/15.
//  Copyright (c) 2015 Matias Willand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGuess.h"
#import "ATableViewCell.h"

@interface AGuessCell : ATableViewCell {
    
    CGRect frameDefaultLabelCommentText;
}

@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UIView *viewSelectBox;
@property (strong, nonatomic) IBOutlet UIView *circleSelected;

@property (strong, nonatomic) NSDictionary *usernameDict;
@property (weak, nonatomic) id<ACellDelegate> delegate;

- (IBAction)buttonUserTouchUpInside:(id)sender;

@end