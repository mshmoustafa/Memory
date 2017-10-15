//
//  memViewController.m
//  Memory
//
//  Created by Muhammad-Sharif Moustafa on 1/24/14.
//  Copyright (c) 2014 Muhammad-Sharif Moustafa. All rights reserved.
//

#import "memViewController.h"
#import "ILTranslucentView.h"

@interface memViewController ()

@end

@implementation memViewController

int BUTTONSVIEW = 1000;
int STATUSVIEW = 2000;
int MOVESLABEL = 3000;
NSString* BUTTONTITLE = @"✪";
//◉✪●◎
CGFloat BUTTONFONTSIZE = 20.0;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    buttonsView = [self.view viewWithTag:BUTTONSVIEW];
    
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
        [button setTitle:BUTTONTITLE forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:BUTTONFONTSIZE]];
        button.tag = i;
        button.frame = CGRectMake(x, y, buttonSize.width, buttonSize.height);
        
        if (((i+1) % numcols) == 0 && i != 0) {
            x = 0;
            y += buttonSize.height;
        } else {
            x += buttonSize.width;
        }
        
        [tempButtons addObject:button];
        [buttonsView addSubview:button];
    }
    
    buttons = tempButtons;
    [self.view bringSubviewToFront:[self.view viewWithTag:MOVESLABEL]];
    
    [self createGame];

    UIAlertView *start = [[UIAlertView alloc] initWithTitle:@"Get Ready!" message:@"Tap on the stars to reveal the colors and make matches. \n\n Try to match all the colors in the lowest number of moves you can! \n\n Ready? \n\n Tip: shake the device at any time to start a new game." delegate:nil cancelButtonTitle:@"Let's Go!" otherButtonTitles:nil];
    
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
            [button setTitle:BUTTONTITLE forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:BUTTONFONTSIZE]];
            
        }completion:nil];

    }
    [self initializeRandomPairs:(numcards / 2)];
    moves = 0;
    minMoves = (int)(cards.count / 2);
    [self updateMovesLabel:0];
    [self setScore:0];
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
        numberOfColors[i] = numberOfMatches / (colors.count / 2);
    }
    
    int random = 0;
    BOOL someColorsRemain = YES;
    
    do {
        
        random = (arc4random_uniform((int)colors.count));
        
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
    
    cards = [randomPairs copy];
}

- (void)setScore:(int)scoreToSet
{
    score = scoreToSet;
    
    if (score == cards.count/2) {
        
        UIAlertView *win = [[UIAlertView alloc]
                            initWithTitle:@"You win!"
                            message:[NSString stringWithFormat:@"You won in %d moves (the lowest number of moves to win is %lu.)",moves,cards.count / 2]
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
    } else if (firstCard == cardNumber) {
        
        //do nothing - this means you clicked the first card again.
        //NSLog(@"You clicked on the same card!");
        
    } else {
        
        if ([self checkIf:(int)[firstCard tag] Matches:(int)[cardNumber tag]] == YES) {
            
            [self incrementMoves];
            [self updateMovesLabel:moves];
            [self setScore:(++score)];
            
            [firstCard setEnabled:NO];
            
            [buttonsView bringSubviewToFront:firstCard];
            
            [UIView animateWithDuration:0.1 animations:^{
                firstCard.transform = CGAffineTransformScale(firstCard.transform, 1.2, 1.2);
            }completion:^(BOOL finished){
                [UIView animateWithDuration:0.1 animations:^{
                    firstCard.transform = CGAffineTransformScale(firstCard.transform, 1/1.2, 1/1.2);
                } completion:^(BOOL finished) {
                    firstCard = nil;
                }];
            }];
            
            [cardNumber setEnabled:NO];
            
            [buttonsView bringSubviewToFront:cardNumber];
            
            [UIView animateWithDuration:0.1 animations:^{
                cardNumber.transform = CGAffineTransformScale(cardNumber.transform, 1.2, 1.2);
            }completion:^(BOOL finished){
                [UIView animateWithDuration:0.1 animations:^{
                    cardNumber.transform = CGAffineTransformScale(cardNumber.transform, 1/1.2, 1/1.2);
                }];
            }];
            
        } else {
            [self incrementMoves];
            [self updateMovesLabel:moves];
            [UIView transitionWithView:firstCard duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                firstCard.backgroundColor = [UIColor clearColor];
                [firstCard setTitle:BUTTONTITLE forState:UIControlStateNormal];
                [firstCard.titleLabel setFont:[UIFont systemFontOfSize:BUTTONFONTSIZE]];
                
            } completion:nil];
            
            [UIView transitionWithView:cardNumber duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent animations:^{
                
                cardNumber.backgroundColor = [UIColor clearColor];
                [cardNumber setTitle:BUTTONTITLE forState:UIControlStateNormal];
                [cardNumber.titleLabel setFont:[UIFont systemFontOfSize:BUTTONFONTSIZE]];
            }completion:nil];
            
            firstCard = nil;
        }
    }
}

- (BOOL)checkIf:(int)card1 Matches:(int)card2
{
    BOOL isMatch = NO;
    
    if ([cards[card1] isEqual:cards[card2]]) {
        isMatch = YES;
    }
    
    return isMatch;
}

- (void)updateMovesLabel:(int)move {
    UILabel* movesLabel = [self.view viewWithTag:MOVESLABEL];
    movesLabel.text = [NSString stringWithFormat:@"%d / %d", move, minMoves];
}

- (void)incrementMoves {
    moves = moves + 1;
}

- (IBAction)newGame:(id)sender
{
    [self.createGameConfirmation show];
}

- (IBAction)cardPress:(id)sender {
    [UIView transitionWithView:sender duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        ((UIButton *) sender).backgroundColor = cards[((UIButton *) sender).tag];
        
    }completion:^(BOOL finished) {
        [self whichCardClicked:(UIButton *)sender];
    }];
    
    [((UIButton *) sender) setTitle:@"" forState:UIControlStateNormal];
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
