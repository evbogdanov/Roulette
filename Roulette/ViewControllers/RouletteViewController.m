//
//  RouletteViewController.m
//  Roulette
//
//  Created by Ev Bogdanov on 03/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "RouletteViewController.h"
#import "BallView.h"

@interface RouletteViewController ()

@property (weak, nonatomic) IBOutlet BallView *ballView;

@end

@implementation RouletteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)spin:(UIButton *)sender {
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGFloat angle = 12.0 / 37 * M_PI;
                         self.ballView.transform = CGAffineTransformRotate(self.ballView.transform, angle);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished: %i", finished);
                     }];
}

@end
