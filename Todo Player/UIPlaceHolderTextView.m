//
//  UIPlaceHolderTextView.m
//  Task Bracket
//
//  Created by Marc Cuva on 7/13/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@interface UIPlaceHolderTextView()
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation UIPlaceHolderTextView

#define LABEL_TAG 999

- (void)setup{
    if(!self.placeHolder){
        [self setPlaceHolder:@""];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChanged:(NSNotification *)notification{
    if([[self placeHolder] length] == 0){
        return;
    }
    
    if([[self text] length] == 0){
        [[self viewWithTag:LABEL_TAG] setAlpha:1];
    }else{
        [[self viewWithTag:LABEL_TAG] setAlpha:0];
    }
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self textChanged:nil];
}


- (void)drawRect:(CGRect)rect
{
    if([[self placeHolder] length] > 0){
        if(_placeHolderLabel == nil){
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 8, self.bounds.size.width - 16, 0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = [UIColor lightGrayColor];
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = LABEL_TAG;
            [self addSubview:_placeHolderLabel];
        }
    }
    
    _placeHolderLabel.text = self.placeHolder;
    [_placeHolderLabel sizeToFit];
    [self sendSubviewToBack:_placeHolderLabel];
    
    if([[self text] length] == 0 && [[self placeHolder] length] > 0){
        [[self viewWithTag:LABEL_TAG] setAlpha:1];
    }
    
    [super drawRect:rect];
}


@end
