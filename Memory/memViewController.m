//
//  memViewController.m
//  Memory
//
//  Created by Muhammad-Sharif Moustafa on 1/24/14.
//  Copyright (c) 2014 Muhammad-Sharif Moustafa. All rights reserved.
//

#import "memViewController.h"

@interface memViewController ()

@end

@implementation memViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    buttons = [NSArray arrayWithObjects:
               [self buttonOne],
               [self buttonTwo],
               [self buttonThree],
               [self buttonFour],
               Nil
                ];
    
    //1 is yellow, 2 is red
    //@1 is short for [NSNumber numberWithInt:1]
//    cards = @{@"1" : @1,
//              @"2" : @1,
//              @"3" : @2,
//              @"4" : @2,
//              };
    cards = [NSArray arrayWithObjects:
             @1,
             @1,
             @2,
             @2,
             Nil];
    
    firstCard = @-1;
//    secondCard = @"0";
    
    [[self buttonOne] setBackgroundColor:Nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)whichCardClicked:(NSNumber *)cardNumber
{
    if ([firstCard  isEqual: @-1]) {
        firstCard = cardNumber;
        NSLog(@"First card is %@.", firstCard);
    } else if ([firstCard isEqual: cardNumber]) {
        //do nothing - this means you clicked the first card again.
        NSLog(@"You clicked on the same card!");
    } else {
        NSLog(@"Second card is %@.", cardNumber);
        if ([self checkIf:(int)[firstCard integerValue] Matches:(int)[cardNumber integerValue]]) {
            NSLog(@"Match!");
            [[buttons objectAtIndex:[firstCard integerValue]] setEnabled:NO];
            [[buttons objectAtIndex:[firstCard integerValue]] setAlpha:(CGFloat)0.5];
            [[buttons objectAtIndex:[cardNumber integerValue]] setEnabled:NO];
            [[buttons objectAtIndex:[cardNumber integerValue]] setAlpha:(CGFloat)0.5];
            
            firstCard = @-1;
        } else {
            NSLog(@"No match...");
            [UIView animateWithDuration:1 animations:^{
                ((UIButton *)[buttons objectAtIndex:[firstCard integerValue]]).backgroundColor = [UIColor clearColor];
            }];
            [UIView animateWithDuration:1 animations:^{
                ((UIButton *)[buttons objectAtIndex:[cardNumber integerValue]]).backgroundColor = [UIColor clearColor];
            }];
            
            [self reloadInputViews];
            
            firstCard = @-1;
        }
    }
}

- (BOOL)checkIf:(int)card1 Matches:(int)card2
{
    BOOL isMatch = NO;
    
//    NSNumber *color1 = [cards objectAtIndex:[card1 intValue]];

    if ([cards[card1] isEqual:cards[card2]]) {
        isMatch = YES;
    }
    
    return isMatch;
}

- (IBAction)buttonOnePress:(id)sender {
//    [[self buttonOne] setBackgroundColor:(UIColor *)[UIColor redColor]];
    [UIView animateWithDuration:0.15 animations:^{
        [self buttonOne].backgroundColor = [UIColor redColor];
    }];
    [self whichCardClicked:@0];
}

- (IBAction)buttonTwoPress:(id)sender {
//    [[self buttonTwo] setBackgroundColor:(UIColor *)[UIColor redColor]];
    [UIView animateWithDuration:0.15 animations:^{
        [self buttonTwo].backgroundColor = [UIColor redColor];
    }];
    [self whichCardClicked:@1];
}

- (IBAction)buttonThreePress:(id)sender {
//    [[self buttonThree] setBackgroundColor:(UIColor *)[UIColor yellowColor]];
    [UIView animateWithDuration:0.15 animations:^{
        [self buttonThree].backgroundColor = [UIColor yellowColor];
    }];
    [self whichCardClicked:@2];
}

- (IBAction)buttonFourPress:(id)sender {
//    [[self buttonFour] setBackgroundColor:(UIColor *)[UIColor yellowColor]];
    [UIView animateWithDuration:0.15 animations:^{
        [self buttonFour].backgroundColor = [UIColor yellowColor];
    }];
    [self whichCardClicked:@3];
}
@end
