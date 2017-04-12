//
//  BallView.m
//  Roulette
//
//  Created by Ev Bogdanov on 10/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "BallView.h"
#import "../Geometry/Geometry.h"

@implementation BallView

- (CGPoint)ballCenter {
    return CGPointMake(BALL_CENTER,
                       BALL_CENTER * BALL_TOP_MARGIN_RATIO);
}

- (CGFloat)ballRadius {
    return BALL_CENTER * BALL_RADIUS_RATIO;
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
