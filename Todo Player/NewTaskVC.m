//
//  NewTaskVC.m
//  Todo Player
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "NewTaskVC.h"
#import "UIPlaceHolderTextView.h"

@interface NewTaskVC () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *descriptionView;
@property (weak, nonatomic) IBOutlet UITextField *titleView;
@property (strong, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@end

@implementation NewTaskVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.descriptionView.placeHolder = @"Description";
    self.descriptionView.font = [UIFont systemFontOfSize:16];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
}

#pragma mark - IBActions
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    // TODO: Create and save task
    NSLog(@"%@", self.titleView.text);
    NSLog(@"%@", self.descriptionView.text);
    NSLog(@"%ul", [self.picker selectedRowInComponent:0]);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 60;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld", (long)row];
}

@end
