//
//  HVZFeedViewController.m
//  HVZApp
//
//  Created by Richard Booth on 3/3/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "HVZFeedViewController.h"
#import "ASIFormDataRequest.h"

@interface HVZFeedViewController ()

@end

@implementation HVZFeedViewController
@synthesize Description;
@synthesize LocationPicker;
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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SubmitButtonPress:(id)sender {
    // Awful evil hack
    self.Day = @"Tue";
    self.Hour = @"05";
    self.Minute = @"00";
    self.AmPm = @"a.m.";
    self.Description = DescriptionBox.text;
    
    
    // Start by getting the information out of our
    
    // Get the login page of the site, so that our csrf validation token can be
    // scraped from it.
    NSURL *url = [NSURL URLWithString:@"http://localhost:8000/eat/"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSLog(@"Past first request"); // We're logging these because a synchronous request can sometimes hang
    
    NSError *error = [request error];
    if (error) {
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
    ASIFormDataRequest *feedAttempt = [ASIFormDataRequest requestWithURL:url];
    [feedAttempt setRequestMethod:@"POST"];
    [feedAttempt setPostValue:token forKey:@"csrfmiddlewaretoken"];
    
    [feedAttempt setPostValue:self.Day forKey:@"day"];
    [feedAttempt setPostValue:self.Hour forKey:@"time_hour"];
    [feedAttempt setPostValue:self.Minute forKey:@"time_minute"];
    [feedAttempt setPostValue:self.AmPm forKey:@"time_meridiem"];
    [feedAttempt setPostValue:self.pickedLocation forKey:@"location"];
    [feedAttempt setPostValue:FeedCode.text forKey:@"feedcode"];
    [feedAttempt startSynchronous];
    NSLog(@"Past second request");
    error = [feedAttempt error];
    NSString *feedResponse = [feedAttempt responseString];
    NSLog(@"%@", feedResponse);
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
