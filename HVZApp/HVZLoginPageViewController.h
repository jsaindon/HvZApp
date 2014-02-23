//
//  HVZLoginPageViewController.h
//  HVZApp
//
//  Created by jarthurcs on 2/18/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVZLoginPageViewController : UIViewController {
    NSDictionary *credentialsDictionary;
}

// Username and Password fields
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

// Storage components for Username and Password
@property (nonatomic) IBOutlet NSString *username;
@property (nonatomic) IBOutlet NSString *password;

// Submit Button
- (IBAction)submitButton:(id)sender;

// Close Keyboard
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event;

@end
