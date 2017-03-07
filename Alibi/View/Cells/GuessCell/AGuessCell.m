//
//  AGuessCell.m
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "AGuessCell.h"

static AGuessCell *sharedCell = nil;

@implementation AGuessCell

#pragma mark - Object lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.viewSelectBox.layer.cornerRadius = 4;
    self.viewSelectBox.layer.masksToBounds = YES;
    
    self.viewSelectBox.layer.borderColor = RGB(229, 227, 218).CGColor;
    self.viewSelectBox.layer.borderWidth = 2;
    
    self.circleSelected.layer.cornerRadius = self.circleSelected.frame.size.height/2;
    self.circleSelected.layer.masksToBounds = YES;
    
    self.circleSelected.backgroundColor = NAVBAR_BACK_COLOR;
}


#pragma mark - Cell methods

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateFramesAndDataWithDownloads:YES];
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
}

- (void)updateFramesAndDataWithDownloads:(BOOL)downloads {
    
    if (self.usernameDict && ![self.usernameDict isEqual:[NSNull null]]) {
        self.labelUsername.text = _usernameDict[@"username"];
    }
}


#pragma mark - Action methods

- (IBAction)buttonUserTouchUpInside:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(showUser:sender:)]) {
//        [self.delegate showUser:self.guess.guessingUser sender:self];
    }
}

@end
