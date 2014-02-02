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
    
    buttons = @{@"1" : [self buttonOne],
                @"2" : [self buttonTwo],
                @"3" : [self buttonThree],
                @"4" : [self buttonFour],
                };
    
    //1 is yellow, 2 is red
    //@1 is short for [NSNumber numberWithInt:1]
    cards = @{@"1" : @1,
              @"2" : @1,
              @"3" : @2,
              @"4" : @2,
              };
    
    firstCard = @"0";
//    secondCard = @"0";
    
    [[self buttonOne] setBackgroundColor:Nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)whichCardClicked:(NSString *)cardNumber
{
    if ([firstCard  isEqual: @"0"]) {
        firstCard = cardNumber;
        NSLog(@"First card is %@.", firstCard);
    } else if ([firstCard isEqual: cardNumber]) {
        //do nothing - this means you clicked the first card again.
        NSLog(@"You clicked on the same card!");
    } else {
        NSLog(@"Second card is %@.", cardNumber);
        if ([self checkIf:firstCard Matches:cardNumber]) {
            NSLog(@"Match!");
            [[buttons objectForKey:firstCard] setEnabled:NO];
            [[buttons objectForKey:firstCard] setAlpha:(CGFloat)0.5];
            [[buttons objectForKey:cardNumber] setEnabled:NO];
            [[buttons objectForKey:cardNumber] setAlpha:(CGFloat)0.5];
            
            firstCard = @"0";
        } else {
            NSLog(@"No match...");
            [[buttons objectForKey:firstCard] setBackgroundColor:nil];
            [[buttons objectForKey:cardNumber] setBackgroundColor:nil];
            
            [self reloadInputViews];
            
            firstCard = @"0";
        }
    }
}

- (BOOL)checkIf:(NSString *)card1 Matches:(NSString *)card2
{
    BOOL isMatch = NO;

    if ([[cards valueForKey:card1] isEqual:[cards valueForKey:card2]]) {
        isMatch = YES;
    }
    
    return isMatch;
}

- (IBAction)buttonOnePress:(id)sender {
    [[self buttonOne] setBackgroundColor:(UIColor *)[UIColor redColor]];
    [self whichCardClicked:@"1"];
}

- (IBAction)buttonTwoPress:(id)sender {
    [[self buttonTwo] setBackgroundColor:(UIColor *)[UIColor redColor]];
    [self whichCardClicked:@"2"];
}

- (IBAction)buttonThreePress:(id)sender {
    [[self buttonThree] setBackgroundColor:(UIColor *)[UIColor yellowColor]];
    [[self buttonThree] setNeedsDisplay];
    [NSThread sleepForTimeInterval:(NSTimeInterval)2];
    [self whichCardClicked:@"3"];
}

- (IBAction)buttonFourPress:(id)sender {
    [[self buttonFour] setBackgroundColor:(UIColor *)[UIColor yellowColor]];
    [self whichCardClicked:@"4"];
}
@end
