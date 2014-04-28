//
//  HVZNotificationsViewController.m
//  HVZApp
//
//  Created by CS121 on 4/20/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "HVZNotificationsViewController.h"
#import "HVZAppDelegate.h"

#import "UAirship.h"
#import "UAInbox.h"
#import "UAInboxMessageListController.h"
#import "UAInboxMessageViewController.h"
#import "UAInboxNavUI.h"
#import "UAInboxUI.h"
#import "UAUtils.h"

#import "JSONKit.h"


@implementation HVZNotificationsViewController

@synthesize messageBox;
@synthesize message;



- (IBAction)sendMessage:(id)sender {
    
    // Grabs the message
    message = messageBox.text;
    
    // Gets permission from Urban Airship to do a push
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://go.urbanairship.com/api/push/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *authStr = [NSString stringWithFormat:@"2Cu9KCvERtW4WbwPGOryhg:nYFOvASmSG6W9EvMbaREkQ"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedDataWithOptions:nil]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    // Formats the push we want to make
    NSDictionary *push = @{@"aps":@{@"alert":message},@"device_tokens":@[@"87892382J393FS77789S90909N82022312332"]};
    request.HTTPBody = [push.JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"push: %@",push);
    NSLog(@"request: %@",request);
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

}


- (IBAction)mail:(id)sender {
    [UAInbox displayInboxInViewController:self.navigationController animated:YES];
}

- (IBAction)selectInboxStyle:(id)sender {
    
    NSString *popoverOrNav;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        popoverOrNav = @"Popover";
    }
    
    else {
        popoverOrNav = @"Navigation Controller";
    }
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Inbox Style" delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Modal", popoverOrNav, nil];
    
    [sheet showInView:self.view];
    
}

// Specifies which Inbox Style button was clicked
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [UAInbox useCustomUI:[UAInboxUI class]];
            [UAInbox shared].pushHandler.delegate = [UAInboxUI shared];
            break;
        case 1:
            [UAInbox useCustomUI:[UAInboxNavUI class]];
            [UAInbox shared].pushHandler.delegate = [UAInboxNavUI shared];
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set border for description text view
    [[self.messageBox layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.messageBox layer] setBorderWidth:.4];
    [[self.messageBox layer] setCornerRadius:8.0f];
    
    self.messageBox.delegate = self;
    
    // Creates Inbox button in UIBar
    self.navigationItem.rightBarButtonItem
    = [[UIBarButtonItem alloc] initWithTitle:@"Inbox" style:UIBarButtonItemStylePlain target:self action:@selector(mail:)];
    
    // For UINavigationController UI
    [UAInboxNavUI shared].popoverButton = self.navigationItem.rightBarButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Interface Rotation

// for iOS5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

// Minimizes Keyboard on Touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
