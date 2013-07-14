//
//  UIPlaceHolderTextView.h
//  Todo Player
//
//  Created by Marc Cuva on 7/13/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, strong) NSString *placeHolder;

- (void)textChanged:(NSNotification *)notification;
@end
