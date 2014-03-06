//
//  HVZSettingsViewController.h
//  HVZApp
//
//  Created by jarthurcs on 3/5/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVZSettingsViewController : UIViewController

// Shows status of web connection attempt
@property (weak, nonatomic) IBOutlet UILabel *StatusLine;

// Logout Button
- (IBAction)logoutButton:(id)sender;

@end
