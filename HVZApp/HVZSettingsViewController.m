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
@synthesize redSlider;
@synthesize blueSlider;
@synthesize greenSlider;

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
    
    // Set sliders to send continuous values
    blueSlider.continuous = YES;
    redSlider.continuous = YES;
    greenSlider.continuous = YES;
    
}

- (void) viewWillAppear:(BOOL)animated{
    /* Set background color if color values are stored */
    
    // Retrieve background color values from storage
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    
    // Check if color values are stored - all should be stored or none are
    if ([storage objectForKey:@"redValue"] == nil) {
        return;
    }
    
    CGFloat redVal = (CGFloat) [[storage objectForKey:@"redValue"] floatValue];
    CGFloat blueVal = (CGFloat) [[storage objectForKey:@"blueValue"] floatValue];
    CGFloat greenVal = (CGFloat) [[storage objectForKey:@"greenValue"] floatValue];
    
    // Change background color to reflect slider value
    self.view.backgroundColor = [UIColor colorWithRed:redVal green:greenVal blue:blueVal alpha:1.0f];
}

- (IBAction)logoutButton:(id)sender {
    
    // Drop our user information from local storage
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage removeObjectForKey:@"username"];
    [storage removeObjectForKey:@"password"];
    [storage removeObjectForKey:@"redValue"];
    [storage removeObjectForKey:@"blueValue"];
    [storage removeObjectForKey:@"greenValue"];
    
    
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

-(IBAction)sliderChanged:(id)sender
{
    CGFloat sliderMax = redSlider.maximumValue;
    
    UISlider *slider = (UISlider *) sender;
    NSInteger sliderValue = lround(slider.value);
    
    CGFloat redVal = redSlider.value/sliderMax;
    CGFloat greenVal = greenSlider.value/sliderMax;
    CGFloat blueVal = blueSlider.value/sliderMax;
    
    if (slider == redSlider) {
        redVal = sliderValue/sliderMax;
    } else if (slider == blueSlider) {
        blueVal = sliderValue/sliderMax;
    } else {
        greenVal = sliderValue/sliderMax;
    }
    
    // Change background color to reflect slider value
    self.view.backgroundColor = [UIColor colorWithRed:redVal green:greenVal blue:blueVal alpha:1.0f];
    
    // Store color values for other pages
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setObject:[NSString stringWithFormat:@"%f", redVal] forKey:@"redValue"];
    [storage setObject:[NSString stringWithFormat:@"%f", blueVal]  forKey:@"blueValue"];
    [storage setObject:[NSString stringWithFormat:@"%f", greenVal]  forKey:@"greenValue"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
