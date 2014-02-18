//
//  HVZSettingsViewController.m
//  HVZApp
//
//  Created by Richard Booth on 2/17/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "HVZSettingsViewController.h"

@interface HVZSettingsViewController ()

@end

@implementation HVZSettingsViewController
@synthesize readEmail;
@synthesize showEmail;
@synthesize readPassword;
@synthesize showPassword;
@synthesize email;
@synthesize password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    email = [prefs stringForKey:@"email"];
    if (email != (id)[NSNull null] && email.length != 0) {
        showEmail.text = email;
    }
    password = [prefs stringForKey:@"password"];
    if (password != (id)[NSNull null] && password.length != 0) {
        showPassword.text = password;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SubmitCreds:(id)sender {
    showEmail.text = readEmail.text;
    showPassword.text = readPassword.text;
    [self.view endEditing:YES];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:readEmail.text forKey:@"email"];
    [prefs setObject:readPassword.text forKey:@"password"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
