//
//  WheelView.m
//  Roulette
//
//  Created by Ev Bogdanov on 03/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "WheelView.h"
#import "../Geometry/Geometry.h"

@implementation WheelView

- (int)numberForIndex:(int)index {
    static const int numbers[WHEEL_NUMBER_OF_POCKETS] = {
        0,
        32,  15,  19,   4,  21,   2,
        25,  17,  34,   6,  27,  13,
        36,  11,  30,   8,  23,  10,
         5,  24,  16,  33,   1,  20,
        14,  31,   9,  22,  18,  29,
         7,  28,  12,  35,   3,  26
    };

    return numbers[index];
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
    return [self wheelRadius] * WHEEL_POCKET_TOP_MARGIN_RATIO;
}

- (CGFloat)pocketFontSize {
    return [self wheelRadius] * WHEEL_POCKET_FONT_SIZE_RATIO;
}

- (void)drawPocketWithIndex:(int)index {
    UIBezierPath *pocket = [[UIBezierPath alloc] init];
    
    // Pocket starts at the center
    CGPoint center = CGPointMake(0, 0);
    [pocket moveToPoint:center];
    
    // Add arc
    [pocket addArcWithCenter:center
                      radius:[self wheelRadius]
                  startAngle:RADIANS_FROM_DEGREES(-90-WHEEL_POCKET_DEGREES_HALF)
                    endAngle:RADIANS_FROM_DEGREES(-90+WHEEL_POCKET_DEGREES_HALF)
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
    
    NSString *numberStr = [NSString stringWithFormat:@"%i", [self numberForIndex:index]];
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
    
    for (int index = 0; index < WHEEL_NUMBER_OF_POCKETS; index += 1) {
        [self drawPocketWithIndex:index];
        CGContextRotateCTM(context, RADIANS_FROM_DEGREES(WHEEL_POCKET_DEGREES));
    }
    
    CGContextRestoreGState(context);
}

- (void)drawPocketsBorder {
    UIBezierPath *pocketsBorder = [[UIBezierPath alloc] init];

    [pocketsBorder addArcWithCenter:[self wheelCenter]
                             radius:[self wheelRadius]*WHEEL_POCKETS_BORDER_RATIO
                         startAngle:RADIANS_FROM_DEGREES(0.0)
                           endAngle:RADIANS_FROM_DEGREES(360.0)
                          clockwise:YES];

    [[UIColor whiteColor] setStroke];
    [pocketsBorder setLineWidth:1];
    [pocketsBorder stroke];
}

- (void)drawCenter {
    UIBezierPath *center = [[UIBezierPath alloc] init];

    [center addArcWithCenter:[self wheelCenter]
                      radius:[self wheelRadius]*WHEEL_CENTER_RATIO
                  startAngle:RADIANS_FROM_DEGREES(0.0)
                    endAngle:RADIANS_FROM_DEGREES(360.0)
                   clockwise:YES];

    [[UIColor whiteColor] setStroke];
    [center setLineWidth:1];
    [center stroke];

    [[self darkGreenColor] setFill];
    [center fill];
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
}

- (void)awakeFromNib {
    [super awakeFromNib];

    // Get rid of background
    self.backgroundColor = nil;
    self.opaque = NO;
}



@end
