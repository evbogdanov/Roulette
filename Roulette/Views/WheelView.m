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

// Wheel radius is 4/4
static const CGFloat WHITE_IN_THE_MIDDLE_RATIO = 3.0 / 4;
static const CGFloat POCKET_HEIGHT_RATIO = 1.0 / 4;
static const CGFloat POCKET_TOP_MARGIN_RATIO = POCKET_HEIGHT_RATIO / 3;
static const CGFloat POCKET_FONT_SIZE_RATIO = POCKET_TOP_MARGIN_RATIO;

// Quick fix for a better number aligning
static const CGFloat POCKET_WIDTH_FIX_RATIO = 17.0 / 20;

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

- (CGPoint)wheelCenter {
    return CGPointMake(self.bounds.size.width / 2,
                       self.bounds.size.height / 2);
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
                  startAngle:[self radiansFromDegrees:-90]
                    endAngle:[self radiansFromDegrees:POCKET_DEGREES-90]
                   clockwise:YES];
    
    // Pocket path is ready
    [pocket closePath];
    
    // Paint it black! (or red, or green)
    if (index == 0)
        [[UIColor greenColor] setFill];
    else if (index % 2)
        [[UIColor redColor] setFill];
    else
        [[UIColor blackColor] setFill];
    
    [pocket fill];
    
    // Pocket has a number
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSString *numberStr = [NSString stringWithFormat:@"%i", NUMBERS[index]];
    NSDictionary *numberAttrs = @{
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSFontAttributeName: [UIFont italicSystemFontOfSize:[self pocketFontSize]]
                                  };
    NSAttributedString *numberAttrStr = [[NSAttributedString alloc] initWithString:numberStr
                                                                        attributes:numberAttrs];
    
    CGRect numberBounds;
    
    // Default coordinates
    // numberBounds.origin = [pocket bounds].origin;
    // numberBounds.size = [pocket bounds].size;
    
    // Better coordinates
    numberBounds.origin.x = [pocket bounds].origin.x;
    numberBounds.origin.y = [pocket bounds].origin.y + [self pocketTopMargin];
    numberBounds.size.width = [pocket bounds].size.width * POCKET_WIDTH_FIX_RATIO;
    numberBounds.size.height = [pocket bounds].size.height;
    
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
