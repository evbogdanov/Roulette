//
//  BallView.m
//  Roulette
//
//  Created by Ev Bogdanov on 10/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "BallView.h"

@implementation BallView

#define BALL_TOP_MARGIN_RATIO 3.0 / 8
#define BALL_RADIUS_RATIO 1.0 / 12
#define CENTER self.bounds.size.width / 2

- (CGPoint)ballCenter {
    return CGPointMake(CENTER,
                       CENTER * BALL_TOP_MARGIN_RATIO);
}

- (CGFloat)ballRadius {
    return CENTER * BALL_RADIUS_RATIO;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *ball = [[UIBezierPath alloc] init];

    [ball addArcWithCenter:[self ballCenter]
                    radius:[self ballRadius]
                startAngle:0
                  endAngle:2*M_PI
                 clockwise:YES];

    [[UIColor whiteColor] setFill];
    [ball fill];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = nil;
    self.opaque = NO;
}

@end
