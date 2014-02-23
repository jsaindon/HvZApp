//
//  HVZLoginPageViewController.m
//  HVZApp
//
//  Created by jarthurcs on 2/18/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "HVZLoginPageViewController.h"

@interface HVZLoginPageViewController ()

@end

@implementation HVZLoginPageViewController
@synthesize usernameInput;
@synthesize passwordInput;
@synthesize username;
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
    
    credentialsDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"password", nil] forKeys:[NSArray arrayWithObjects:@"username", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButton:(id)sender {
    [self.view endEditing:YES];
    
    if([[credentialsDictionary objectForKey:usernameInput.text]isEqualToString:passwordInput.text]) { // Credentials are correct
    
        [self performSegueWithIdentifier:@"loginCorrect" sender:self];
    }
    
    else { // Username/Password not in the database
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Username/Password" message:@"This username/password combination is incorrect." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
