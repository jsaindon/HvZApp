//
//  HVZRulesViewController.h
//  HVZApp
//
//  Created by jarthurcs on 3/12/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVZRulesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *viewRules;


// Shows status of web connection attempt if we fail
@property (weak, nonatomic) IBOutlet UILabel *StatusLine;

@end
