//
//  HVZGameInfoViewController.m
//  HVZApp
//
//  Created by jarthurcs on 4/13/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "HVZGameInfoViewController.h"
#import "ASIHTTPRequest.h"

@interface HVZGameInfoViewController ()

@end

@implementation HVZGameInfoViewController
@synthesize bgImage;
@synthesize playerInfoBackground;
@synthesize gameInfoBackground;
@synthesize playerName;
@synthesize playerStatus;
@synthesize playerDorm;
@synthesize playerSchool;
@synthesize playerGradYear;
@synthesize gameMod;
@synthesize gameSeason;

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
    
    // Set background image of view
    [playerInfoBackground setBackgroundColor:[UIColor lightGrayColor]];
    [gameInfoBackground setBackgroundColor:[UIColor lightGrayColor]];
    playerInfoBackground.alpha = 0.4;
    gameInfoBackground.alpha = 0.4;
    
    // Call functions to load text
    [self displayPlayerInfo];
    [self displayGameInfo];
}

- (void)displayPlayerInfo
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
        playerName.text = @"Player Email: N/A";
        playerStatus.text = @"Status: N/A";
        playerGradYear.text = @"Graduation Year: N/A";
        playerSchool.text = @"School: N/A";
        playerDorm.text = @"Dorm: N/A";
        NSLog(@"Error executing request for player info");
        return;
    }
    
    NSData *responseData = [request responseData];
    
    NSDictionary *playerDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:NULL];
    
    NSString *status;
    if ([[playerDict objectForKey:@"team"] isEqualToString:@"H"]) {
        status = @"Human";
    } else {
        status = @"Zombie";
    }
    
    NSString *playerNameString = [NSString stringWithFormat:@"%@%@", @"Email: ", [playerDict objectForKey:@"email"]];
    NSString *playerStatusString = [NSString stringWithFormat:@"%@%@", @"Status: ", status];
    NSString *playerGradYearString = [NSString stringWithFormat:@"%@%@", @"Graduation Year: ", [playerDict objectForKey:@"gradyear"]];
    NSString *playerSchoolString = [NSString stringWithFormat:@"%@%@", @"School: ", [playerDict objectForKey:@"school"]];
    NSString *playerDormString = [NSString stringWithFormat:@"%@%@", @"Dorm: ", [playerDict objectForKey:@"dorm"]];
    
    playerName.text = playerNameString;
    playerStatus.text = playerStatusString;
    playerGradYear.text = playerGradYearString;
    playerSchool.text = playerSchoolString;
    playerDorm.text = playerDormString;
    
}

- (void)displayGameInfo
{
    // Set up request
    NSURL *url = [NSURL URLWithString:@"http://localhost:8000/api/gameinfo"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    
    // If the request fails, handle and stop
    if (error) {
        gameMod.text = @"Current Mod: N/A";
        gameSeason.text = @"Game: N/A";
        NSLog(@"Error executing request for game info");
        return;
    }
    
    NSData *responseData = [request responseData];
    
    NSDictionary *gameDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:NULL];
    
    NSString *gameModString = [NSString stringWithFormat:@"%@%@", @"Current Mod: ", [gameDict objectForKey:@"currentmod"]];
    NSString *gameSeasonString = [NSString stringWithFormat:@"%@%@", @"Game: ", [gameDict objectForKey:@"season"]];
    
    gameMod.text = gameModString;
    gameSeason.text = gameSeasonString;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
