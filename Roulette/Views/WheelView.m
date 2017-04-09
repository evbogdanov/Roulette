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
static const CGFloat POCKET_DEGREES_HALF = POCKET_DEGREES / 2;

// Wheel radius is 4/4
static const CGFloat CENTER_RATIO = 1.0 / 2;
static const CGFloat POCKET_HEIGHT_RATIO = 1.0 / 4;
static const CGFloat POCKET_TOP_MARGIN_RATIO = POCKET_HEIGHT_RATIO / 3;
static const CGFloat POCKET_FONT_SIZE_RATIO = POCKET_TOP_MARGIN_RATIO;
static const CGFloat POCKETS_BORDER_RATIO = 3.0 / 4;
static const CGFloat BALL_TOP_MARGIN_RATIO = 3.0 / 8;
static const CGFloat BALL_RADIUS_RATIO = 1.0 / 12;

// Index => Number
static int NUMBERS[NUMBER_OF_POCKETS] = {
    0,
    32,  15,  19,   4,  21,   2,
    25,  17,  34,   6,  27,  13,
    36,  11,  30,   8,  23,  10,
     5,  24,  16,  33,   1,  20,
    14,  31,   9,  22,  18,  29,
     7,  28,  12,  35,   3,  26
};

- (CGPoint)ballCenter {
    return CGPointMake(self.bounds.size.width / 2,
                       [self wheelRadius] * BALL_TOP_MARGIN_RATIO);
}

- (CGFloat)ballRadius {
    return [self wheelRadius] * BALL_RADIUS_RATIO;
}

- (CGPoint)wheelCenter {
    return CGPointMake(self.bounds.size.width / 2,
                       self.bounds.size.height / 2);
}

- (UIColor *)lightGreenColor {
    return [UIColor colorWithRed:0.26 green:0.84 blue:0.32 alpha:1.0];
}

- (UIColor *)darkGreenColor {
    return [UIColor colorWithRed:0.09 green:0.52 blue:0.08 alpha:1.0];
}

- (CGFloat)wheelRadius {
    CGPoint center = [self wheelCenter];
    return center.x;
}

- (CGFloat)pocketTopMargin {
    return [self wheelRadius] * POCKET_TOP_MARGIN_RATIO;
}

- (CGFloat)pocketFontSize {
    return [self wheelRadius] * POCKET_FONT_SIZE_RATIO;
}

- (void)drawPocketWithIndex:(int)index {
    UIBezierPath *pocket = [[UIBezierPath alloc] init];
    
    // Pocket starts at the center
    CGPoint center = CGPointMake(0, 0);
    [pocket moveToPoint:center];
    
    // Add arc
    [pocket addArcWithCenter:center
                      radius:[self wheelRadius]
                  startAngle:[self radiansFromDegrees:-90-POCKET_DEGREES_HALF]
                    endAngle:[self radiansFromDegrees:-90+POCKET_DEGREES_HALF]
                   clockwise:YES];
    
    // Pocket path is ready
    [pocket closePath];
    
    // Paint it black! (or red, or green)
    if (index == 0)
        [[self lightGreenColor] setFill];
    else if (index % 2)
        [[UIColor redColor] setFill];
    else
        [[UIColor blackColor] setFill];
    
    [pocket fill];

    // Pocket borders
    [[UIColor whiteColor] setStroke];
    [pocket setLineWidth:1];
    [pocket stroke];
    
    // Pocket has a number
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSString *numberStr = [NSString stringWithFormat:@"%i", NUMBERS[index]];
    NSDictionary *numberAttrs = @{
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSFontAttributeName: [UIFont systemFontOfSize:[self pocketFontSize]]
                                  };
    NSAttributedString *numberAttrStr = [[NSAttributedString alloc] initWithString:numberStr
                                                                        attributes:numberAttrs];

    CGRect numberBounds;
    numberBounds.origin.x = [pocket bounds].origin.x;
    numberBounds.origin.y = [pocket bounds].origin.y + [self pocketTopMargin];
    numberBounds.size = [pocket bounds].size;
    [numberAttrStr drawInRect:numberBounds];
}

- (void)drawPockets {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, [self wheelCenter].x, [self wheelCenter].y);
    
    for (int index = 0; index < NUMBER_OF_POCKETS; index += 1) {
        [self drawPocketWithIndex:index];
        CGContextRotateCTM(context, [self radiansFromDegrees:POCKET_DEGREES]);
    }
    
    CGContextRestoreGState(context);
}

- (void)drawPocketsBorder {
    UIBezierPath *pocketsBorder = [[UIBezierPath alloc] init];

    [pocketsBorder addArcWithCenter:[self wheelCenter]
                             radius:[self wheelRadius]*POCKETS_BORDER_RATIO
                         startAngle:[self radiansFromDegrees:0]
                           endAngle:[self radiansFromDegrees:360]
                          clockwise:YES];

    [[UIColor whiteColor] setStroke];
    [pocketsBorder setLineWidth:1];
    [pocketsBorder stroke];
}

- (void)drawCenter {
    UIBezierPath *center = [[UIBezierPath alloc] init];

    [center addArcWithCenter:[self wheelCenter]
                      radius:[self wheelRadius]*CENTER_RATIO
                  startAngle:[self radiansFromDegrees:0]
                    endAngle:[self radiansFromDegrees:360]
                   clockwise:YES];

    [[UIColor whiteColor] setStroke];
    [center setLineWidth:1];
    [center stroke];

    [[self darkGreenColor] setFill];
    [center fill];
}

- (void)drawBall {
    UIBezierPath *ball = [[UIBezierPath alloc] init];

    [ball addArcWithCenter:[self ballCenter]
                    radius:[self ballRadius]
                startAngle:[self radiansFromDegrees:0]
                  endAngle:[self radiansFromDegrees:360]
                 clockwise:YES];

    [[UIColor whiteColor] setFill];
    [ball fill];
}

- (void)drawRect:(CGRect)rect {
    // Draw wheel foundation
    UIBezierPath *wheel = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                      cornerRadius:self.bounds.size.width];
    [wheel addClip];

    // Draw pockets on the wheel
    [self drawPockets];

    // Draw pockets' border
    [self drawPocketsBorder];
    
    // Draw the center
    [self drawCenter];

    // Draw the ball
    [self drawBall];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    // Get rid of background
    self.backgroundColor = nil;
    self.opaque = NO;
}

- (CGFloat)radiansFromDegrees:(CGFloat)degrees {
    return degrees * M_PI / 180.0f;
}

@end
