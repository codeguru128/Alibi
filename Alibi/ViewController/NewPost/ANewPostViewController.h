//
//  ANewPostViewController.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AViewController.h"
#import "UIPlaceHolderTextView.h"

@interface ANewPostViewController : AViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *textViewPost;

- (IBAction)buttonSendTouchUpInside:(id)sender;

@end
