//
//  HVZFeedViewController.h
//  HVZApp
//
//  Created by Richard Booth on 3/3/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVZFeedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *Description;
@property (weak, nonatomic) IBOutlet UIPickerView *LocationPicker;
@property (weak, nonatomic) IBOutlet UITextField *FeedCode;
@property (weak, nonatomic) IBOutlet UIButton *SubmitButton;

@end
