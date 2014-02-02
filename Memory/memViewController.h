//
//  memViewController.h
//  Memory
//
//  Created by Muhammad-Sharif Moustafa on 1/24/14.
//  Copyright (c) 2014 Muhammad-Sharif Moustafa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface memViewController : UIViewController
{
    NSDictionary *buttons;
    
    NSDictionary *cards;
    NSString *firstCard;
//    NSString *secondCard;
}

- (void)whichCardClicked:(NSString *)cardNumber;
- (BOOL)checkIf:(NSString *)card1 Matches:(NSString *)card2;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
- (IBAction)buttonOnePress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
- (IBAction)buttonTwoPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
- (IBAction)buttonThreePress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
- (IBAction)buttonFourPress:(id)sender;

@end
