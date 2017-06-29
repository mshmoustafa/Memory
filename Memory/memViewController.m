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
    
    //NSLog(@"%@",self.view.subviews);
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
#warning UIAlertView is deprecated
    self.createGameConfirmation = [[UIAlertView alloc] initWithTitle:@"Start a new game?" message:nil delegate:self cancelButtonTitle:@"No stop!" otherButtonTitles: @"Go to start screen", @"Yes, please!", nil];
    
    colors = @[[UIColor redColor],
               [UIColor yellowColor],
               [UIColor blueColor],
               [UIColor greenColor],
               [UIColor orangeColor],
               [UIColor purpleColor]];
    
    NSMutableArray *tempButtons = [[NSMutableArray alloc] init];
    
    float x = 0;
    float y = 0;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"level"] isEqualToString:@"kids"]) {
        numcols = 3;
        numrows = 4;
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"level"] isEqualToString:@"easy"]) {
        numcols = 4;
        numrows = 6;
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"level"] isEqualToString:@"medium"]) {
        numcols = 4;
        numrows = 9;
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"level"] isEqualToString:@"hard"]) {
        numcols = 6;
        numrows = 8;
    } else {
        numcols = 4;
        numrows = 6;
    }
    
    numcards = numcols * numrows;
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGSize buttonSize = CGSizeMake(screenSize.size.width / numcols, screenSize.size.height / numrows);
    
    for (int i = 0; i < numcards; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(cardPress:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"◎" forState:UIControlStateNormal];
        button.tag = i;
        button.frame = CGRectMake(x, y, buttonSize.width, buttonSize.height);
        
        if (((i+1) % numcols) == 0 && i != 0) {
            x = 0;
            y += buttonSize.height;
        } else {
            x += buttonSize.width;
        }
        
        [tempButtons addObject:button];
        [self.view addSubview:button];
    }
    
    buttons = tempButtons;
    
    
    [self createGame];
    
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

    UIAlertView *start = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Tap on the little blue dots to flip cards over and make matches. Ready? \n\n Tip: shake the device at any time to start a new game." delegate:nil cancelButtonTitle:@"Let's Go!" otherButtonTitles:nil];
    
    [start show];
    
}

//implemented UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 2) {
        [self createGame];
        [self.createGameButton setEnabled:NO];
    } else if (buttonIndex == 1) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)createGame
{
    for (UIButton *button in buttons) {
        
        [UIView transitionWithView:button duration:0.3 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            [button setBackgroundColor:[UIColor clearColor]];
            [button setEnabled:YES];
            [button setAlpha:(CGFloat)1.0];
            [button setTitle:@"◎" forState:UIControlStateNormal];
            
        }completion:nil];

    }
    [self initializeRandomPairs:(numcards / 2)];
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
    
    int numberOfColors[colors.count];
    
    for (int i = 0; i < colors.count; i++) {
//        numberOfMatches = numberOfMatches - numberOfMatches / 3;
        numberOfColors[i] = numberOfMatches / (colors.count / 2);
    }
    
//    int numberRed = numberOfMatches / 3;
//    int numberYellow = numberOfMatches / 3;
//    int numberBlue = numberOfMatches / 3;
//    int numberGreen = numberOfMatches / 3;
//    int numberOrange = numberOfMatches / 3;
//    int numberPurple = numberOfMatches / 3;
    
    int random = 0;
    BOOL someColorsRemain = YES;
    
//    for (int i = 0; i < (numberOfMatches * 2); i++) {
        do {
            
            random = (arc4random_uniform((int)colors.count));
//            NSLog(@"Random number: %d", random);
            
            if (numberOfColors[random] != 0) {
                [randomPairs addObject:colors[random]];
                numberOfColors[random]--;
            }
            
            someColorsRemain = NO;
            
            for (int i = 0; i < colors.count; i++) {
                if (numberOfColors[i] != 0) {
                    someColorsRemain = YES;
                    break;
                }
            }
            
        } while (someColorsRemain);
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

- (void)setScore:(int)scoreToSet
{
    score = scoreToSet;
    
    if (score == cards.count/2) {
        
        UIAlertView *win = [[UIAlertView alloc]
                            initWithTitle:@"You win!"
                            message:[NSString stringWithFormat:@"You won in %d moves (the least number of moves to win is %lu.)",moves,cards.count / 2]
                            delegate:self
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:@"Go to start screen", @"New game", nil];
        [win show];
        
        [self.createGameButton setEnabled:YES];
        
    } else {

    }
}

- (void)whichCardClicked:(UIButton *)cardNumber
{
    if (firstCard == nil) {
        
        firstCard = cardNumber;
        //NSLog(@"First card is %d.", [firstCard tag]);
        
    } else if (firstCard == cardNumber) {
        
        //do nothing - this means you clicked the first card again.
        //NSLog(@"You clicked on the same card!");
        
    } else {
        
        //NSLog(@"Second card is %d.", [cardNumber tag]);
        
        if ([self checkIf:[firstCard tag] Matches:[cardNumber tag]] == YES) {
            
            //NSLog(@"Match!");
            
            [self setScore:(++score)];
            moves++;
            
            [firstCard setEnabled:NO];
            
            [self.view bringSubviewToFront:firstCard];
            
            [UIView animateWithDuration:0.1 animations:^{
                firstCard.transform = CGAffineTransformScale(firstCard.transform, 1.2, 1.2);
//                [firstCard setAlpha:(CGFloat)0.5];
            }completion:^(BOOL finished){
                [UIView animateWithDuration:0.1 animations:^{
                    firstCard.transform = CGAffineTransformScale(firstCard.transform, 1/1.2, 1/1.2);
                } completion:^(BOOL finished) {
                    firstCard = nil;
                }];
            }];
            
            [cardNumber setEnabled:NO];
            
            [self.view bringSubviewToFront:cardNumber];
            
            [UIView animateWithDuration:0.1 animations:^{
                cardNumber.transform = CGAffineTransformScale(cardNumber.transform, 1.2, 1.2);
                //                [firstCard setAlpha:(CGFloat)0.5];
            }completion:^(BOOL finished){
                [UIView animateWithDuration:0.1 animations:^{
                    cardNumber.transform = CGAffineTransformScale(cardNumber.transform, 1/1.2, 1/1.2);
                }];
            }];
            
//            [UIView transitionWithView:firstCard duration:0.2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
//                [cardNumber setEnabled:NO];
////                [cardNumber setAlpha:(CGFloat)0.5];
//            }completion:nil];
            
//            [firstCard setEnabled:NO];
//            [firstCard setAlpha:(CGFloat)0.5];
//            [cardNumber setEnabled:NO];
//            [cardNumber setAlpha:(CGFloat)0.5];
            
        } else {
            
            //NSLog(@"No match...");
            
            moves++;
            
//            [UIView animateWithDuration:1 animations:^{
//                firstCard.backgroundColor = [UIColor clearColor];
//                [firstCard setTitle:@"◎" forState:UIControlStateNormal];
//            }];
            [UIView transitionWithView:firstCard duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                firstCard.backgroundColor = [UIColor clearColor];
                [firstCard setTitle:@"◎" forState:UIControlStateNormal];
//                [firstCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            } completion:nil];
            
            [UIView transitionWithView:cardNumber duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent animations:^{
                
                cardNumber.backgroundColor = [UIColor clearColor];
                [cardNumber setTitle:@"◎" forState:UIControlStateNormal];
                
            }completion:nil];
            
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
    [self.createGameConfirmation show];
}

- (IBAction)cardPress:(id)sender {
    //    [[self buttonOne] setBackgroundColor:(UIColor *)[UIColor redColor]];
    
    [UIView transitionWithView:sender duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        ((UIButton *) sender).backgroundColor = cards[((UIButton *) sender).tag];
        
    }completion:^(BOOL finished) {
        [self whichCardClicked:(UIButton *)sender];
    }];
    
//    [UIView animateWithDuration:0.20 animations:^{
//        ((UIButton *) sender).backgroundColor = cards[((UIButton *) sender).tag];
//    }];
    
    [((UIButton *) sender) setTitle:@"" forState:UIControlStateNormal];
    
//    [self whichCardClicked:(UIButton *)sender];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self.createGameConfirmation show];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
