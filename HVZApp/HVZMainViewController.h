//
//  HVZViewController.h
//  HVZApp
//
//  Created by Richard Booth on 2/14/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

const double STUN_TIME;

@interface HVZMainViewController : UIViewController {
    IBOutlet UILabel *seconds;
    NSTimer *timer;
    int startingTime;
}

// Main page
- (IBAction)StartTimer;
@property (weak, nonatomic) IBOutlet UIButton *TimerButton;
@property (weak, nonatomic) IBOutlet UILabel *HVZRatioLabel;
@property (weak, nonatomic) IBOutlet UIButton *FeedButton;



// Settings page

@end
