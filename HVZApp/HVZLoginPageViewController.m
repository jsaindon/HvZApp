//
//  HVZLoginPageViewController.m
//  HVZApp
//
//  Created by jarthurcs on 2/18/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "HVZLoginPageViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface HVZLoginPageViewController ()

@end

@implementation HVZLoginPageViewController
@synthesize usernameInput;
@synthesize passwordInput;
@synthesize username;
@synthesize password;
@synthesize StatusLine;

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
	self.navigationItem.hidesBackButton = YES;
    
    // Declare text field delegates
    self.usernameInput.delegate = self;
    self.passwordInput.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButton:(id)sender {
    NSLog(@"Button clacked.");
    [self.view endEditing:YES];
    // Persist the entered username and password in the user settings.
    password = passwordInput.text;
    username = usernameInput.text;
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setObject:password forKey:@"password"];
    [storage setObject:username forKey:@"username"];
    
    // Get the login page of the site, so that our csrf validation token can be
    // scraped from it.
    NSURL *url = [NSURL URLWithString:@"http://localhost:8000/login/"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSLog(@"Past first request"); // We're logging these because a synchronous request can sometimes hang
    
    NSError *error = [request error];
    if (error) {
        StatusLine.text = @"Get connection failed.";
        NSLog(@"Get connection failed.");
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
    // Now login, using the token we just scraped and the username/password entered by the user
    ASIFormDataRequest *loginAttempt = [ASIFormDataRequest requestWithURL:url];
    [loginAttempt setRequestMethod:@"POST"];
    [loginAttempt setPostValue:token forKey:@"csrfmiddlewaretoken"];
    [loginAttempt setPostValue:username forKey:@"username"];
    [loginAttempt setPostValue:password forKey:@"password"];
    [loginAttempt startSynchronous];
    NSLog(@"Past second request");
    error = [loginAttempt error];
    NSString *loginResponse = [loginAttempt responseString];
    
    // Check if we logged in correctly.
    NSRegularExpression *loggedInAs = [NSRegularExpression regularExpressionWithPattern:@"logout" options:0 error:NULL];
    NSUInteger loggedIn = [loggedInAs numberOfMatchesInString:loginResponse options:0 range:NSMakeRange(0, [loginResponse length])];
    NSLog(@"%@", [NSString stringWithFormat:@"%d", loggedIn]);
    NSLog(@"%@", loginResponse);
    Boolean connect = false;
    
    if (loggedIn > 0 && !error) {
        connect = true;
    } else if (loggedIn == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Username/Password" message:@"This username/password combination is incorrect." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failed" message:@"Either the website is down or you do not have internet coverage." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    
    
    
    if(connect) { // Credentials are correct
        
        [self performSegueWithIdentifier:@"loginCorrect" sender:self];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    NSLog(@"Text field finished editing");
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
