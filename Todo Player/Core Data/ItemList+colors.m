//
//  ItemList+colors.m
//  Task Bracket
//
//  Created by Marc Cuva on 8/31/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "ItemList+colors.h"

@implementation ItemList (colors)


- (void)setColor:(UIColor *)color{
    float red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    self.red_color = [NSNumber numberWithFloat:red];
    self.green_color = [NSNumber numberWithFloat:green];
    self.blue_color = [NSNumber numberWithFloat:blue];
    
}

- (UIColor *)color{
    return [UIColor colorWithRed:[self.red_color floatValue] green:[self.blue_color floatValue] blue:[self.green_color floatValue] alpha:1];
}

@end
