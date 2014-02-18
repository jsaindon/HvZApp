//
//  HVZSettingsViewController.h
//  HVZApp
//
//  Created by Richard Booth on 2/17/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVZSettingsViewController : UIViewController
- (IBAction)SubmitCreds:(id)sender;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UITextField *readPassword;
@property (weak, nonatomic) IBOutlet UITextField *readEmail;
@property (weak, nonatomic) IBOutlet UILabel *showEmail;
@property (weak, nonatomic) IBOutlet UILabel *showPassword;

@property (nonatomic) IBOutlet NSString *email;
@property (nonatomic) IBOutlet NSString *password;

@end
