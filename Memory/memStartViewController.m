//
//  memStartViewController.m
//  Memory
//
//  Created by Muhammad-Sharif Moustafa on 6/4/14.
//  Copyright (c) 2014 Muhammad-Sharif Moustafa. All rights reserved.
//

#import "memStartViewController.h"

@interface memStartViewController ()

@property (nonatomic) BOOL shouldCycleColors;
@property (strong, nonatomic) NSArray *colors;

@end

@implementation memStartViewController

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
    
    self.colors = @[[UIColor blueColor],
                    [UIColor greenColor],
                    [UIColor yellowColor],
                    [UIColor redColor],
                    [UIColor orangeColor],
                    [UIColor purpleColor],
                    [UIColor cyanColor],
                    [UIColor colorWithRed:0.0 green:0.51 blue:0.15 alpha:1.0]
                    ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.shouldCycleColors = YES;
    [self cycleBackgroundColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.shouldCycleColors = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cycleBackgroundColor
{
    static int randomNumber = 0;
    
    randomNumber = arc4random_uniform((int)self.colors.count);
    
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        while (self.view.backgroundColor == self.colors[randomNumber]) {
            //NSLog(@"Same color!");
            randomNumber = arc4random_uniform((int)self.colors.count);
            
        }
        
        self.view.backgroundColor = self.colors[randomNumber];
        
    }completion:^(BOOL finished){
        if (self.shouldCycleColors) {
            [self cycleBackgroundColor];
        } else {
            //do nothing
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}

- (IBAction)levelButtonTapped:(UIButton *)sender {
    
    if (NSClassFromString(@"UIAlertController")) {
        
        void (^actionBlock)(UIAlertAction *action) = ^(UIAlertAction *action){
            if ([action.title isEqualToString:@"Kids"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"kids" forKey:@"level"];
                [self.levelButton setTitle:@"Level: Kids" forState:UIControlStateNormal];
            } else if ([action.title isEqualToString:@"Easy"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"easy" forKey:@"level"];
                [self.levelButton setTitle:@"Level: Easy" forState:UIControlStateNormal];
            } else if ([action.title isEqualToString:@"Medium"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"medium" forKey:@"level"];
                [self.levelButton setTitle:@"Level: Medium" forState:UIControlStateNormal];
            } else if ([action.title isEqualToString:@"Hard"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"hard" forKey:@"level"];
                [self.levelButton setTitle:@"Level: Hard" forState:UIControlStateNormal];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:@"easy" forKey:@"level"];
                [self.levelButton setTitle:@"Level: Easy" forState:UIControlStateNormal];
            }
        };
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Level" message:@"Select a level" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Kids" style:UIAlertActionStyleDefault handler:actionBlock]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Easy" style:UIAlertActionStyleDefault handler:actionBlock]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Medium" style:UIAlertActionStyleDefault handler:actionBlock]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Hard" style:UIAlertActionStyleDefault handler:actionBlock]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
    }
    
}
@end
