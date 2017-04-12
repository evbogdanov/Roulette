//
//  RouletteViewController.m
//  Roulette
//
//  Created by Ev Bogdanov on 03/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "RouletteViewController.h"
#import "BallView.h"
#import "../Geometry/Geometry.h"

@interface RouletteViewController ()

@property (nonatomic) BOOL canSpin;
@property (weak, nonatomic) IBOutlet BallView *ballView;

@end

@implementation RouletteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canSpin = YES;
}

- (IBAction)spin:(UIButton *)sender {
    // One spinning at a time
    if (!self.canSpin)
        return;

    self.canSpin = NO;

    NSTimeInterval duration = 0.3;
    NSTimeInterval delay = 0.0;
    CGFloat angle = M_PI;
    CGFloat finalAngle = M_PI;

    int randomPocket = arc4random_uniform(WHEEL_NUMBER_OF_POCKETS) + 1;
    CGFloat randomAngle = WHEEL_POCKET_DEGREES * randomPocket;

    // Number of rotations:
    // 3 full wheel rotations + x rotations for random pocket
    int rotations = 6;
    if (randomAngle >= 360.0) {
        rotations += 2;
    }
    else if (randomAngle > 180.0 && randomAngle < 360.0) {
        rotations += 2;
        finalAngle = RADIANS_FROM_DEGREES(randomAngle-180.0);
    }
    else {
        rotations += 1;
        finalAngle = RADIANS_FROM_DEGREES(randomAngle);
    }

    // Animate each rotations
    for (int i = 1; i <= rotations; i += 1) {
        UIViewAnimationOptions options;
        if (i == 1) {
            options = UIViewAnimationOptionCurveEaseIn;
        }
        else if (i == rotations) {
            options = UIViewAnimationOptionCurveEaseOut;
            angle = finalAngle;
        }
        else {
            options = UIViewAnimationOptionCurveLinear;
        }

        [UIView animateWithDuration:duration
                              delay:delay
                            options:options
                         animations:^{
                             self.ballView.transform = CGAffineTransformRotate(self.ballView.transform, angle);
                         }
                         completion:^(BOOL finished) {
                             if (i == rotations)
                                 self.canSpin = YES;
                         }];

        delay += duration;
    }
}

@end
