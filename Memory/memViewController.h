//
//  memViewController.h
//  Memory
//
//  Created by Muhammad-Sharif Moustafa on 1/24/14.
//  Copyright (c) 2014 Muhammad-Sharif Moustafa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface memViewController : UIViewController <UIAlertViewDelegate>
{
    int score;
    int moves;
    int minMoves;
    
    int numcols;
    int numrows;
    int numcards;
    
    //still need to implement
//    NSArray *scores;
    
    NSArray *colors;
    
    NSArray *buttons;
    
    NSArray *cards;
    UIButton *firstCard;
//    NSString *secondCard;
    
    UIView *buttonsView;
    UIView *movesLabel;
}

@property (weak, nonatomic) IBOutlet UIButton *createGameButton;
@property (strong, nonatomic) UIAlertView *createGameConfirmation;

- (void)createGame;

- (void)initializeRandomPairs:(int)numberOfMatches;

- (void)setScore:(int)scoreToSet;

//still need to implement
//- (NSArray *)readScoresFromFile;
//- (void)writeScoresToFile:(NSArray *)scoresToWrite;

- (void)whichCardClicked:(UIButton *)cardNumber;

- (BOOL)checkIf:(int)card1 Matches:(int)card2;


- (IBAction)newGame:(id)sender;
- (IBAction)cardPress:(id)sender;

@end
