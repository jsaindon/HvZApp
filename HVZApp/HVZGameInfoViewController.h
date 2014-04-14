//
//  HVZGameInfoViewController.h
//  HVZApp
//
//  Created by jarthurcs on 4/13/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HVZGameInfoViewController : UIViewController

@property UIImage *bgImage;
@property (weak, nonatomic) IBOutlet UIImageView *playerInfoBackground;
@property (weak, nonatomic) IBOutlet UIImageView *gameInfoBackground;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UILabel *playerStatus;
@property (weak, nonatomic) IBOutlet UILabel *playerGradYear;
@property (weak, nonatomic) IBOutlet UILabel *playerSchool;
@property (weak, nonatomic) IBOutlet UILabel *playerDorm;
@property (weak, nonatomic) IBOutlet UILabel *gameMod;
@property (weak, nonatomic) IBOutlet UILabel *gameSeason;


@end
