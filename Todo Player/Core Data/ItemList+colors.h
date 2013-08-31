//
//  ItemList+colors.h
//  Task Bracket
//
//  Created by Marc Cuva on 8/31/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "ItemList.h"

@interface ItemList (colors)

/** Sets the color using a UIColor object
 @param UIColor color
 @return None
*/
- (void)setColor:(UIColor *)color;

/** Returns UIColor version of color
 @param None
 @return UIColor
*/
- (UIColor *)color;

@end
