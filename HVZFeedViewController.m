//
//  HVZFeedViewController.m
//  HVZApp
//
//  Created by Richard Booth on 3/3/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "HVZFeedViewController.h"
#import "ASIFormDataRequest.h"
#import "CRSFGetter.h"
#include <QuartzCore/QuartzCore.h>

@interface HVZFeedViewController ()

@end

@implementation HVZFeedViewController
@synthesize Description;
@synthesize FeedCode;
@synthesize SubmitButton;
@synthesize DescriptionBox;
@synthesize pickedLocation;
@synthesize Hour;
@synthesize Minute;
@synthesize AmPm;
@synthesize Day;


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
    self.locationList = [[NSArray alloc] initWithObjects:@"East Dorm (Mudd)",@"West Dorm (Mudd)",@"North Dorm (Mudd)",@"South Dorm (Mudd)",@"Sontag Dorm (Mudd)",@"Atwood Dorm (Mudd)",@"Linde Dorm (Mudd)", @"Case Dorm (Mudd)", nil];
    // Make sure navigation bar shows
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    // Set border for description text view
    [[self.DescriptionBox layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.DescriptionBox layer] setBorderWidth:.4];
    [[self.DescriptionBox layer] setCornerRadius:8.0f];
    
    // Declare feed code and description delegates
    self.FeedCode.delegate = self;
    self.DescriptionBox.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    NSLog(@"Feed code finished editing");
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)SubmitButtonPress:(id)sender {
    // Default submit values
    self.Day = @"0";
    self.Hour = @"05";
    self.Minute = @"00";
    self.AmPm = @"a.m.";
    self.Description = DescriptionBox.text;
    
    // Make sure feed code has been entered and formatted correctly
    NSString *feedcode = [FeedCode text];
    
    // Set feed code to all caps
    feedcode = [feedcode capitalizedString];
    
    // Check if only allowed letters in the Feed Code text field
    
    if ([feedcode length] != 5) {
        NSLog(@"Feed code entered was not of proper length or uses invalid characters.");
        UIAlertView *codeAlert = [[UIAlertView alloc] initWithTitle:@"Feed Error" message:@"Feed code was not formatted properly." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [codeAlert show];
        return;
    }
    
    // Start by getting the necessary request information
    
    // Get past meal count to compare to post meal count
    int pastMealCount = [self getMealCount];
    
    // Get the login page of the site, so that our csrf validation token can be
    // scraped from it.
    NSURL *url = [NSURL URLWithString:@"http://localhost:8000/eat/"];
    NSString *token = [CRSFGetter getCRSFToken:url];
    
    // Check for error in getting token
    if ([token isEqualToString:@"error"]) {
        NSLog(@"Error in collecting CRSF token from website.");
        return;
    }
    
    // Now fill out the post request, using hardcoded values for data the user doesn't enter
    ASIFormDataRequest *feedAttempt = [ASIFormDataRequest requestWithURL:url];
    [feedAttempt setRequestMethod:@"POST"];
    [feedAttempt setPostValue:token forKey:@"csrfmiddlewaretoken"];
    [feedAttempt setPostValue:feedcode forKey:@"feedcode"];
    [feedAttempt setPostValue:self.Day forKey:@"day"];
    [feedAttempt setPostValue:self.Hour forKey:@"time_hour"];
    [feedAttempt setPostValue:self.Minute forKey:@"time_minute"];
    [feedAttempt setPostValue:self.AmPm forKey:@"time_meridiem"];
    [feedAttempt setPostValue:@"204" forKey:@"location"];
    [feedAttempt setPostValue:self.DescriptionBox.text forKey:@"description"];
    [feedAttempt startSynchronous];
    NSLog(@"Past feed request");
    
    NSError *error = [feedAttempt error];
    if (error) {
        // Let user know there was a problem with the feed request
        NSLog(@"Error: %@", [error description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feed Error" message:[NSString stringWithFormat:@"Error: %@.",error] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *feedResponse = [feedAttempt responseString];
    NSLog(@"Feed Response:\n%@", feedResponse);
    
    // Check meal count of user to make sure feed went through
    int currMealCount = [self getMealCount];
    if (currMealCount > pastMealCount) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feeding Successful!" message:[NSString stringWithFormat:@"Meal was processed successfully.\nMmmm, delicious brains!"] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feed Issue" message:[NSString stringWithFormat:@"Error: Meal failed to process\nPlayer might already have been devoured"] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
    return;
}

- (int)getMealCount
{
    // Retrieve username
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSString *username = [storage objectForKey:@"username"];
    
    // Set up request
    NSURL *url = [NSURL URLWithString:@"http://localhost:8000/api/currplayer"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:username];
    [request startSynchronous];
    
    NSError *error = [request error];
    
    // If the request fails, handle and stop
    if (error) {
        NSLog(@"Error executing request for player info");
        return -1;
    }
    
    NSData *responseData = [request responseData];
    
    NSDictionary *playerDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:NULL];
    
    int meal_count = [[playerDict objectForKey:@"meals"] intValue];
    
    return meal_count;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [self.locationList count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.locationList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch(row)
    {
    {
    case 0: self.pickedLocation = @"East";
    }
    {
    case 1: self.pickedLocation = @"West";
    }
    {
    case 2: self.pickedLocation = @"North";
    }
    {
    case 3: self.pickedLocation = @"South";
    }
    {
    case 4: self.pickedLocation = @"Sontag";
    }
    {
    case 6: self.pickedLocation = @"Atwood";
    }
    {
    case 7: self.pickedLocation = @"Linde";
    }
    {
    case 8: self.pickedLocation = @"Case";
    }
    }
}

@end
