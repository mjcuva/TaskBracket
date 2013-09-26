//
//  BaseView.m
//  Task Bracket
//
//  Created by Marc Cuva on 8/6/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "BaseView.h"
#import "UIImage+blur.h"

@interface BaseView()
@property (strong, nonatomic) UIImage *image;
@end

@implementation BaseView

@synthesize color = _color;

- (UIColor *)color{
    if(!_color){
        _color = [UIColor redColor];
    }
    
    return _color;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    self.image = nil;
}

- (UIImage *)image{
    return _image;
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
    
    [self.color setFill];
    UIRectFill(rect);
    
    if (!self.image) {
        self.image = [self generateImageWithSize:rect andColors:colors];
    }
    
    [self.image drawInRect:rect blendMode:kCGBlendModeNormal alpha:.7];
    
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
//    return @[[UIColor whiteColor]];
    return colors;
}

/**
 Returns an image to be used as background for view
 @param rect The rect that is the size of the returned image
 @param colors Colors that the image will contain
 @return Blurred image
 */
- (UIImage *)generateImageWithSize:(CGRect)rect andColors:(NSArray *)colors{
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    for(int i = 200; i > 0; i--){
        NSUInteger randomColorIndex = arc4random() % [colors count];
        UIColor *color = [colors objectAtIndex:randomColorIndex];
        [color setFill];
        
        NSUInteger width = arc4random() % (int)rect.size.width / 4;
        NSUInteger height = arc4random() % (int)rect.size.height / 4;
        NSUInteger x = arc4random() % (int)rect.size.width;
        NSUInteger y = arc4random() % (int)rect.size.height;
        UIRectFill(CGRectMake(x, y, width, height));
    }
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [viewImage applyDarkEffect];
//    return viewImage;
    
}

@end









