//
//  HVZNotificationsViewController.h
//  HVZApp
//
//  Created by CS121 on 4/20/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAInboxUI.h"


@interface HVZNotificationsViewController : UIViewController <UIActionSheetDelegate>

@property(nonatomic, weak) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UITextView *messageBox;
@property (nonatomic) IBOutlet NSString *message;

-(IBAction)mail:(id)sender;
-(IBAction)selectInboxStyle:(id)sender;


// Close Keyboard
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event;


@end
