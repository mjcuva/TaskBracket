//
//  UIColor+random.m
//  Task Bracket
//
//  Created by Marc Cuva on 8/31/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "UIColor+random.h"

@implementation UIColor (random)

+ (UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end

