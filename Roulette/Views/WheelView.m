//
//  WheelView.m
//  Roulette
//
//  Created by Ev Bogdanov on 03/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "WheelView.h"

@implementation WheelView

- (void)drawRect:(CGRect)rect {
     UIBezierPath *wheel = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width];
    
    [wheel addClip];
    
    [[UIColor redColor] setFill];
    UIRectFill(self.bounds);
}

@end
