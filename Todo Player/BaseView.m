//
//  BaseView.m
//  Task Bracket
//
//  Created by Marc Cuva on 8/6/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "BaseView.h"
#import "UIImage+blur.h"

@implementation BaseView

- (UIColor *)color{
    if(!_color){
        _color = [UIColor greenColor];
    }
    
    return _color;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    
    [roundedRect addClip];
    
    NSArray *colors = [self getColorRange];
    
    NSUInteger randomIndex = arc4random() % [colors count];
    [[colors objectAtIndex:randomIndex] setFill];
    UIRectFill(self.bounds);
    
    UIImage *image = [self generateImageWithSize:rect andColors:colors];
    
    [image drawInRect:rect blendMode:kCGBlendModeOverlay alpha:1];
    
}

/**
 Generates array of colors similar to self.color
 @param None
 @return Array of UIColors
 */
- (NSArray *)getColorRange{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for(float i = 100; i > 0; i -= 1){
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [colors addObject:color];
        
    }
    return colors;
}

/**
 Returns an image to be used as background for view
 @param rect The rect that is the size of the returned image
 @param colors Colors that the image will contain
 @return Blurred image
 */
- (UIImage *)generateImageWithSize:(CGRect)rect andColors:(NSArray *)colors{
    
    UIGraphicsBeginImageContext(rect.size);
    
    for(int i = 50; i > 0; i--){
        NSUInteger randomColorIndex = arc4random() % [colors count];
        UIColor *color = [colors objectAtIndex:randomColorIndex];
        [color setFill];
        
        NSUInteger width = arc4random() % (int)rect.size.width / 2;
        NSUInteger height = arc4random() % (int)rect.size.height / 2;
        NSUInteger x = arc4random() % (int)rect.size.width;
        NSUInteger y = arc4random() % (int)rect.size.height;
        UIRectFill(CGRectMake(x, y, width, height));
    }
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [viewImage applyDarkEffect];
    
}

@end









