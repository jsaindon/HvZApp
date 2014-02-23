//
//  HVZViewController.h
//  HVZApp
//
//  Created by Richard Booth on 2/14/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVZViewController : UIViewController {
    IBOutlet UILabel *seconds;
    NSTimer *timer;
    int startingTime;
}

// Main page
- (IBAction)StartTimer;

// Settings page

@end
