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
@property (strong, nonatomic) UIColor *color;

/**
 Abstract
 
 Returns the ideal height of the view.
 */
- (CGFloat)idealHeight;
@end
