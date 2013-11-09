//
//  NewTaskVC.m
//  Task Bracket
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "NewTaskVC.h"
#import "UIPlaceHolderTextView.h"
#import "SharedManagedObjectContext.h"
#import "Task.h"
#import "ItemList+Description.h"

@interface NewTaskVC () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *descriptionView;
@property (weak, nonatomic) IBOutlet UITextField *titleView;
@property (strong, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) UIToolbar *accesoryView;
@property (strong, nonatomic) UISegmentedControl *accesoryControl;
@end

@implementation NewTaskVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Set up title view
    [self.titleView becomeFirstResponder];
    self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = NO;
    [self.titleView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.titleView.delegate = self;
    self.titleView.inputAccessoryView = self.accesoryView;
    
    // Set up description view
    self.descriptionView.placeHolder = @"Description";
    self.descriptionView.font = [UIFont systemFontOfSize:16];
    self.descriptionView.delegate = self;
    self.descriptionView.inputAccessoryView = self.accesoryView;
    
    // Set up picker
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    // Get shared context
    [SharedManagedObjectContext getSharedContextWithCompletionHandler:^(NSManagedObjectContext *context){
        self.context = context;
    }];
    
    // Configure if editing vs creating task
    if(self.startingTask){
        self.titleView.text = self.startingTask.title;
        self.descriptionView.text = self.startingTask.task_description;
        [self.picker selectRow:[self.startingTask.duration integerValue] inComponent:0 animated:NO];
        
        self.navigationController.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(done:)];
        
        self.title = @"Edit Task";
    }

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.accesoryControl.tintColor = self.view.tintColor;
}

#pragma mark - Keyboard Control for Text Boxes

- (void)updateAccessoryWithTextBox:(int)index{
    if(index == 0){
        [self.accesoryControl setEnabled:NO forSegmentAtIndex:1];
        [self.accesoryControl setEnabled:YES forSegmentAtIndex:0];
        [self.descriptionView becomeFirstResponder];
    }else{
        [self.accesoryControl setEnabled:NO forSegmentAtIndex:0];
        [self.accesoryControl setEnabled:YES forSegmentAtIndex:1];
        [self.titleView becomeFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    
    [self updateAccessoryWithTextBox:1];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self updateAccessoryWithTextBox:0];
}

- (void)setListTitle:(NSString *)listTitle{
    _listTitle = listTitle;
}

- (UIToolbar *)accesoryView{
    
    if(!_accesoryView){
        _accesoryView = [[UIToolbar alloc] init];
        
        self.accesoryControl = [[UISegmentedControl alloc] initWithItems:@[@"Previous", @"Next"]];
        
        [self.accesoryControl addTarget:self action:@selector(changeRow:) forControlEvents:UIControlEventValueChanged];
        [self.accesoryControl setEnabled:NO forSegmentAtIndex:0];
        self.accesoryControl.momentary = YES;
        self.accesoryControl.highlighted = YES;
        
        UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithCustomView:self.accesoryControl];
        NSArray *items = @[next];
        
        [_accesoryView setItems:items];
        
        [_accesoryView sizeToFit];
    }
    
    return _accesoryView;
}

- (void)changeRow:(id)sender{
    
    int selected = [sender selectedSegmentIndex];
    if(selected == 0){
        [self updateAccessoryWithTextBox:1];
    }else{
        [self updateAccessoryWithTextBox:0];
    }
    
}

#pragma mark - Update confirm button
- (void)textFieldDidChange:(UITextField *)textField{
    if([textField.text length] > 0){
        self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - IBActions
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self.delagate taskCanceled];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    
    if(!self.startingTask){
        Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.context];
        task.title = self.titleView.text;
        task.task_description = self.descriptionView.text;
        task.duration = [NSNumber numberWithInt:[self.picker selectedRowInComponent:0]];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ItemList"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        NSLog(@"%@", self.listTitle);
        request.predicate = [NSPredicate predicateWithFormat:@"title=%@", self.listTitle];
        
        ItemList *list = [self.context executeFetchRequest:request error:NULL][0];
        
        task.list_location = [NSNumber numberWithInt:[list.tasks count]];
        
        NSError *err;
        [self.context save:&err];
        
        if(err){
            NSLog(@"%@", [err description]);
        }
        
        [list addTasksObject:task];
        
        NSLog(@"%@", self.titleView.text);
        NSLog(@"%@", self.descriptionView.text);
        NSLog(@"%ul", [self.picker selectedRowInComponent:0]);
        [self.delagate taskCreated];
    }else{
        self.startingTask.title = self.titleView.text;
        self.startingTask.task_description = self.descriptionView.text;
        self.startingTask.duration = [NSNumber numberWithInt:[self.picker selectedRowInComponent:0]];
        [self.delagate taskEdited:self.startingTask];
    }
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
