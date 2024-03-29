//
//  TTTViewController.m
//  Tac
//
//  Created by Joseph Lau on 7/29/14.
//  Copyright (c) 2014 Joseph Lau. All rights reserved.
//

#import "TTTViewController.h"
#import "TTTTouchSpot.h"

@interface TTTViewController () <UIAlertViewDelegate>

@end

@implementation TTTViewController
{
    NSMutableArray * spots;
    BOOL player1Turn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        spots = [@[] mutableCopy];
        
        player1Turn = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int spotWH = 80;
    int padding = 20;
    int gridWH = (spotWH * 3) + (padding * 2);
    float spacingW = (SCREEN_WIDTH - gridWH) / 2;
    float spacingH = (SCREEN_HEIGHT - gridWH) / 2;
    
    // run for each row
    for (int row = 0; row < 3; row++)
    {
        // run for each col in each row
        for (int col = 0; col < 3; col++)
        {
            int x = (spotWH + padding) * col + spacingW;
            int y = (spotWH + padding) * row + spacingH;
            
            // create view
            TTTTouchSpot * spot = [[TTTTouchSpot alloc] initWithFrame:CGRectMake(x, y, spotWH, spotWH)];
            
            spot.player = 0;
            
            // add view
            [self.view addSubview:spot];
            
            // add view to array
            [spots addObject:spot];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // how many fingers are touching the screen at the time
    UITouch * touch = [touches allObjects][0];
    
    int spotWH = 80;
    
    for (TTTTouchSpot * spot in spots)
    {
        CGPoint location = [touch locationInView:spot];
        
        if (location.x >= 0 && location.y >=0)
            if (location.x <= spotWH && location.y <= spotWH)
            {
                if (spot.player == 0)
                {
                    spot.player = (player1Turn) ? 1 : 2;
                    player1Turn = !player1Turn;
                    
                    [self checkForWinner];
                }
            }
    }
}

- (void)checkForWinner
{
    NSArray * possibilities = @[
                                @[@0, @1, @2],
                                @[@3, @4, @5],
                                @[@6, @7, @8],
                                @[@0, @3, @6],
                                @[@1, @4, @7],
                                @[@2, @5, @8],
                                @[@0, @4, @8],
                                @[@2, @4, @6]
                                ];
    
    BOOL winner = NO;
    
    for (NSArray * possibility in possibilities)
    {
        TTTTouchSpot * spot0 = spots[ [possibility[0] intValue]];
        TTTTouchSpot * spot1 = spots[ [possibility[1] intValue]];
        TTTTouchSpot * spot2 = spots[ [possibility[2] intValue]];
        
        if (spot0.player == spot1.player && spot1.player == spot2.player && spot0.player != 0)
        {
            winner = YES;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Winner" message:[NSString stringWithFormat:@"Player %d Won", spot0.player] delegate:self cancelButtonTitle:@"Start Over" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    int emptySpots = 0;
    
    for (TTTTouchSpot * spot in spots)
        if (spot.player == 0)
            emptySpots++;
    
    if (emptySpots == 0 && !winner)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Draw" message:  @"No player won." delegate:self cancelButtonTitle:@"Start Over" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    for (TTTTouchSpot * spot in spots)
    {
        spot.player = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
