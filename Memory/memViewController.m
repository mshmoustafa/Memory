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
    NSLog(@"%@",self.view.subviews);
    [self createGame];
    buttons = [NSArray arrayWithObjects:
               [self button1],
               [self button2],
               [self button3],
               [self button4],
               [self button5],
               [self button6],
               [self button7],
               [self button8],
               [self button9],
               [self button10],
               [self button11],
               [self button12],
               [self button13],
               [self button14],
               [self button15],
               [self button16],
               [self button17],
               [self button18],
               [self button19],
               [self button20],
               [self button21],
               [self button22],
               [self button23],
               [self button24],
               Nil
               ];
    
    //1 is yellow, 2 is red
    //@1 is short for [NSNumber numberWithInt:1]
    //    cards = @{@"1" : @1,
    //              @"2" : @1,
    //              @"3" : @2,
    //              @"4" : @2,
    //              };
    
    
//    cards = [NSArray arrayWithObjects:
//             [UIColor redColor],
//             [UIColor redColor],
//             [UIColor yellowColor],
//             [UIColor yellowColor],
//             Nil];
    
    //    secondCard = @"0";
    
}

//implemented UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self createGame];
    }
}

- (void)createGame
{
    for (UIButton *button in buttons) {
        [button setBackgroundColor:[UIColor clearColor]];
        [button setEnabled:YES];
        [button setAlpha:(CGFloat)1.0];
    }
    [self initializeRandomPairs:12];
    [self setScore:0];
    moves = 0;
    firstCard = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeRandomPairs:(int)numberOfMatches
{
    NSMutableArray *randomPairs = [NSMutableArray arrayWithCapacity:(numberOfMatches * 2)];
    int numberRed = numberOfMatches / 2;
    int numberYellow = numberOfMatches / 2;
    int numberBlue = numberOfMatches / 2;
    int numberGreen = numberOfMatches / 2;
    
//    for (int i = 0; i < (numberOfMatches * 2); i++) {
        while ((numberRed != 0) || (numberYellow != 0) || (numberBlue != 0) || (numberGreen != 0)) {
            int random = (arc4random() % 4 + 1);
            NSLog(@"Random number: %d", random);
            if (random == 1 && numberRed != 0) {
                [randomPairs addObject:[UIColor redColor]];
                numberRed--;
            } else if (random == 2 && numberYellow != 0) {
                [randomPairs addObject:[UIColor yellowColor]];
                numberYellow--;
            } else if (random == 3 && numberBlue != 0) {
                [randomPairs addObject:[UIColor blueColor]];
                numberBlue--;
            } else if (random == 4 && numberGreen != 0) {
                [randomPairs addObject:[UIColor greenColor]];
                numberGreen--;
            }
        }
//        if (numberRed == 0 && numberYellow == 0 && numberBlue == 0 && numberGreen == 0) {
//            //this shouldn't happen, do something about it
//        } else if (numberRed == 0) {
//            [randomPairs addObject:[UIColor yellowColor]];
//            numberYellow--;
//        } else if (numberYellow == 0) {
//            [randomPairs addObject:[UIColor redColor]];
//            numberRed--;
//        } else {
//            if (random == 1) {
//                [randomPairs addObject:[UIColor redColor]];
//                numberRed--;
//            } else if (random == 2) {
//                [randomPairs addObject:[UIColor yellowColor]];
//                numberYellow--;
//            }
//        }
//    }
    
    cards = [randomPairs copy];
}

- (void)setScore:(NSInteger)scoreToSet
{
    score = scoreToSet;
    
    if (score == cards.count/2) {
        [self.scoreLabel setText:[NSString stringWithFormat:@"You win!  %d matches out of %d",scoreToSet,(cards.count)/2]];
        UIAlertView *win = [[UIAlertView alloc]
                            initWithTitle:@"You win!"
                            message:[NSString stringWithFormat:@"You won in %d moves (the least number of moves to win is 12.)",moves]
                            delegate:self
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:@"New game", nil];
        [win show];
    } else {
        [self.scoreLabel setText:[NSString stringWithFormat:@"%d matches out of %d",scoreToSet,(cards.count)/2]];
    }
}

- (void)whichCardClicked:(UIButton *)cardNumber
{
    if (firstCard == nil) {
        
        firstCard = cardNumber;
        NSLog(@"First card is %d.", [firstCard tag]);
        
    } else if (firstCard == cardNumber) {
        
        //do nothing - this means you clicked the first card again.
        NSLog(@"You clicked on the same card!");
        
    } else {
        
        NSLog(@"Second card is %d.", [cardNumber tag]);
        
        if ([self checkIf:[firstCard tag] Matches:[cardNumber tag]] == YES) {
            
            NSLog(@"Match!");
            
            [self setScore:(++score)];
            moves++;
            
            [firstCard setEnabled:NO];
            [firstCard setAlpha:(CGFloat)0.5];
            [cardNumber setEnabled:NO];
            [cardNumber setAlpha:(CGFloat)0.5];
            
            firstCard = nil;
        } else {
            
            NSLog(@"No match...");
            
            moves++;
            
            [UIView animateWithDuration:1 animations:^{
                firstCard.backgroundColor = [UIColor clearColor];
            }];
            
            [UIView animateWithDuration:1 animations:^{
                cardNumber.backgroundColor = [UIColor clearColor];
            }];
            
            firstCard = nil;
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

- (IBAction)newGame:(id)sender
{
    [self createGame];
}

- (IBAction)cardPress:(id)sender {
    //    [[self buttonOne] setBackgroundColor:(UIColor *)[UIColor redColor]];
    [UIView animateWithDuration:0.15 animations:^{
        ((UIButton *) sender).backgroundColor = cards[((UIButton *) sender).tag];
    }];
    
    [self whichCardClicked:(UIButton *)sender];
}

@end
