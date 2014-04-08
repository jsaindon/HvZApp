//
//  HVZFeedViewController.h
//  HVZApp
//
//  Created by Richard Booth on 3/3/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVZFeedViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *DescriptionBox;
@property (weak, nonatomic) IBOutlet UITextField *FeedCode;
@property (weak, nonatomic) IBOutlet UIButton *SubmitButton;
@property (strong, nonatomic) NSArray *locationList;
@property (strong, nonatomic) NSString *pickedLocation;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSString *Hour;
@property (strong, nonatomic) NSString *Minute;
@property (strong, nonatomic) NSString *AmPm;
@property (strong, nonatomic) NSString *Day;

@end
