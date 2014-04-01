//
//  HVZRulesViewController.m
//  HVZApp
//
//  Created by jarthurcs on 3/12/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "HVZRulesViewController.h"

@interface HVZRulesViewController ()

@end

@implementation HVZRulesViewController
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
	// Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    // Load web view of rules onto WebView object
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Rules" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"Got to request");
    [_viewRules loadRequest:request];
    NSLog(@"WebView: %@", self.viewRules);
    NSLog(@"Tried to load request");
    
}

// Error handling for WebView request
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    StatusLine.text = @"Get connection failed.";
    NSLog(@"An error occurred during load");
}

// Log WebView progress
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"loading started");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"finished loading");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
