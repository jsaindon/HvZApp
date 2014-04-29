//
//  HVZSettingsViewController.h
//  HVZApp
//
//  Created by jarthurcs on 3/5/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVZSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;

// Logout Button
- (IBAction)logoutButton:(id)sender;

@end
