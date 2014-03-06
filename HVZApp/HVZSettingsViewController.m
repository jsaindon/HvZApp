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
}

- (IBAction)logoutButton:(id)sender {
    
    // Drop our user information from local storage
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage removeObjectForKey:@"username"];
    [storage removeObjectForKey:@"password"];
    
    // Get the logout page of the site, so that our csrf validation token can be
    // scraped from it, and so we can logout.
    NSURL *url = [NSURL URLWithString:@"http://localhost:8000/logout"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSLog(@"Past first request"); // We're logging these because a synchronous request can sometimes hang
    
    NSError *error = [request error];
    if (error) {
        // No connection, so we need to quit.
        NSLog(@"Get connection failed.");
        
        // We deleted local data, so notify user.
        NSLog(@"No connection to the HvZ website");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failed" message:@"Logout successful, but you have no connection to the website." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        
        // Since we've cleared user information, we should segue and return
        [self performSegueWithIdentifier:@"logoutSuccess" sender:self];
        return;
    }
    NSString *response = [request responseString];
    
    
    // Parse the csrf token out of the html returned
    NSRegularExpression *csrfToken = [NSRegularExpression regularExpressionWithPattern:@"<input type='hidden' name='csrfmiddlewaretoken' value='.*>"  options:0 error:NULL];
    
    NSRange rangeOfCell = [csrfToken rangeOfFirstMatchInString:response options:0 range:NSMakeRange(0, [response length])];
    NSString *cell = [response substringWithRange:rangeOfCell];
    NSRange tokenRange = NSMakeRange(55, 32); // The html is programmatically validated. I would not
    // do this if I didn't moderate the site in question.
    NSString *token = [cell substringWithRange:tokenRange];
    NSLog(@"%@", token);
    NSLog(@"Parsed string, about to construct request.");
    
    // Now we logout, using the token we just scraped
    ASIFormDataRequest *logoutAttempt = [ASIFormDataRequest requestWithURL:url];
    [logoutAttempt setRequestMethod:@"POST"];
    [logoutAttempt setPostValue:token forKey:@"csrfmiddlewaretoken"];
    [logoutAttempt startSynchronous];
    NSLog(@"Past second request");
    error = [logoutAttempt error];
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
