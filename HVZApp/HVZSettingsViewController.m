//
//  HVZSettingsViewController.m
//  HVZApp
//
//  Created by jarthurcs on 3/5/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "HVZSettingsViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CRSFGetter.h"

@interface HVZSettingsViewController ()

@end

@implementation HVZSettingsViewController

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (IBAction)logoutButton:(id)sender {
    
    // Drop our user information from local storage
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage removeObjectForKey:@"username"];
    [storage removeObjectForKey:@"password"];
    
    
    // Get the logout page of the site, so that our csrf validation token can be
    // scraped from it.
    NSURL *url = [NSURL URLWithString:@"http://localhost:8000/logout/"];
    NSString *token = [CRSFGetter getCRSFToken:url];
    
    // Check for error in getting token
    if ([token isEqualToString:@"error"]) {
        NSLog(@"Error in collecting CRSF token from website.");
        return;
    }
    
    // Now we logout, using the token we just scraped
    ASIFormDataRequest *logoutAttempt = [ASIFormDataRequest requestWithURL:url];
    [logoutAttempt setRequestMethod:@"POST"];
    [logoutAttempt setPostValue:token forKey:@"csrfmiddlewaretoken"];
    [logoutAttempt startSynchronous];
    NSLog(@"Past second request");
    NSError *error = [logoutAttempt error];
    NSString *logoutResponse = [logoutAttempt responseString];
    
    // Check if we logged out correctly.
    NSRegularExpression *loggedInAs = [NSRegularExpression regularExpressionWithPattern:@"logout" options:0 error:NULL];
    NSUInteger loggedIn = [loggedInAs numberOfMatchesInString:logoutResponse options:0 range:NSMakeRange(0, [logoutResponse length])];
    NSLog(@"%@", [NSString stringWithFormat:@"%d", loggedIn]);
    NSLog(@"%@", logoutResponse);
    Boolean loggedOut = false;
    
    // Only true if we're still logged in
    if (loggedIn > 0 && !error) {
        loggedOut = false;
    } else if (loggedIn == 0) {
        // Yay we logged out!
        NSLog(@"Logged out successfully!");
        loggedOut = true;
    } else {
        // Do nothing
    }
    
    
    // Since we've cleared user information, we should always segue
    [self performSegueWithIdentifier:@"logoutSuccess" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
