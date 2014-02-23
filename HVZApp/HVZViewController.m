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

@implementation HVZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)StartTimer {
    startingTime = 10;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    startingTime -= 1;
    seconds.text = [NSString stringWithFormat:@"%i", startingTime];
    if (startingTime == 0) {
        [timer invalidate];
    }
}

@end
