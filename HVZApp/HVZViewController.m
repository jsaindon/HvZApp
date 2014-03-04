//
//  HVZViewController.m
//  HVZApp
//
//  Created by Richard Booth on 2/14/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "HVZViewController.h"

@interface HVZViewController ()

@end

// Length of stun time for hit zombies
const double STUN_TIME = 120;

@implementation HVZViewController
@synthesize TimerButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)StartTimer {
    
    TimerButton.enabled = NO;
    startingTime = STUN_TIME;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    // Push notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:STUN_TIME];
    localNotification.alertBody = @"You are free to eat all you want now!!!!";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}

- (void)countDown {
    startingTime -= 1;
    NSInteger minutes = startingTime / 60;
    NSInteger secondsLeft = startingTime % 60;
    seconds.text = [NSString stringWithFormat:@"%02d:%02d", minutes, secondsLeft];
    if (startingTime == 0) {
        [timer invalidate];
        TimerButton.enabled = YES;
    }
}



@end
