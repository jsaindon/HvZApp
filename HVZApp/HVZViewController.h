//
//  HVZViewController.h
//  HVZApp
//
//  Created by Richard Booth on 2/14/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVZViewController : UIViewController
// Main page
- (IBAction)StartTimer:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *runClock;

// Settings page

@end
