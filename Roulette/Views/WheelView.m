//
//  WheelView.m
//  Roulette
//
//  Created by Ev Bogdanov on 03/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "WheelView.h"

@implementation WheelView

static const int NUMBER_OF_POCKETS = 37;
static const CGFloat POCKET_DEGREES = 360.0 / NUMBER_OF_POCKETS;
static const CGFloat WHITE_IN_THE_MIDDLE_RATIO = 3.0 / 4.0;

- (CGPoint)wheelCenter {
    return CGPointMake(self.bounds.size.width / 2,
                       self.bounds.size.height / 2);
}

- (CGFloat)wheelRadius {
    CGPoint center = [self wheelCenter];
    return center.x;
}

- (void)drawPockets {
    for (int i = 1; i <= NUMBER_OF_POCKETS; i += 1) {
        UIBezierPath *pocket = [[UIBezierPath alloc] init];
        
        // Pocket starts at the center
        [pocket moveToPoint:[self wheelCenter]];
        
        // Add arc
        [pocket addArcWithCenter:[self wheelCenter]
                          radius:[self wheelRadius]
                      startAngle:[self radiansFromDegrees:(i-1)*POCKET_DEGREES]
                        endAngle:[self radiansFromDegrees:i*POCKET_DEGREES]
                       clockwise:YES];
        
        // Pocket is ready
        [pocket closePath];
        
        // Paint it black! (or red, or green)
        if (i == 1)
            [[UIColor greenColor] setFill];
        else if (i % 2)
            [[UIColor blackColor] setFill];
        else
            [[UIColor redColor] setFill];
        
        [pocket fill];
    }
}

- (void)drawSomeWhiteInTheMiddle {
    UIBezierPath *whiteInTheMiddle = [[UIBezierPath alloc] init];
    
    [whiteInTheMiddle addArcWithCenter:[self wheelCenter]
                                radius:[self wheelRadius]*WHITE_IN_THE_MIDDLE_RATIO
                            startAngle:[self radiansFromDegrees:0]
                              endAngle:[self radiansFromDegrees:360]
                             clockwise:YES];
    
    [[UIColor whiteColor] setFill];
    [whiteInTheMiddle fill];
}

- (void)drawRect:(CGRect)rect {
    // Draw wheel foundation
     UIBezierPath *wheel = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                      cornerRadius:self.bounds.size.width];
    [wheel addClip];
    
    // Draw pockets on the wheel
    [self drawPockets];
    
    // Draw some white in the middle
    [self drawSomeWhiteInTheMiddle];
}

- (CGFloat)radiansFromDegrees:(CGFloat)degrees {
    return degrees * M_PI / 180.0f;
}

@end
