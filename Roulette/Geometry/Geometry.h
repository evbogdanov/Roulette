//
//  Geometry.h
//  Roulette
//
//  Created by Ev Bogdanov on 12/04/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#ifndef Geometry_h
#define Geometry_h

//
// Wheel
//
#define WHEEL_NUMBER_OF_POCKETS 37
#define WHEEL_POCKET_DEGREES 360.0 / WHEEL_NUMBER_OF_POCKETS
#define WHEEL_POCKET_DEGREES_HALF WHEEL_POCKET_DEGREES / 2
#define WHEEL_CENTER_RATIO 1.0 / 2
#define WHEEL_POCKET_HEIGHT_RATIO 1.0 / 4
#define WHEEL_POCKET_TOP_MARGIN_RATIO WHEEL_POCKET_HEIGHT_RATIO / 3
#define WHEEL_POCKET_FONT_SIZE_RATIO WHEEL_POCKET_HEIGHT_RATIO / 3
#define WHEEL_POCKETS_BORDER_RATIO 3.0 / 4

//
// Ball
//
#define BALL_TOP_MARGIN_RATIO 3.0 / 8
#define BALL_RADIUS_RATIO 1.0 / 12
#define BALL_CENTER self.bounds.size.width / 2

//
// Misc
//
#define RADIANS_FROM_DEGREES(degrees) (degrees) * M_PI / 180.0

#endif /* Geometry_h */
