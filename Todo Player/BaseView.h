//
//  BaseView.h
//  Task Bracket
//
//  Created by Marc Cuva on 8/6/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView
@property (strong, nonatomic) NSString *text;

/**
 Color used for the background of the image. Defaults to [UIColor redColor]
 */
@property (strong, nonatomic) UIColor *color;

/**
  Image used for the styling of the background. If set manually, color still needs to be set, otherwise it will default to red.
 */
@property (strong, nonatomic) UIImage *image;

/**
 Abstract
 
 Returns the ideal height of the view.
 */
- (CGFloat)idealHeight;
@end
