//
//  NewTaskVC.m
//  Todo Player
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "NewTaskVC.h"

@interface NewTaskVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UINavigationBar *navBar;
@end

@implementation NewTaskVC

#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    return nil;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"Test";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if(cell == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    cell.textLabel.text = @"Test";
//    return cell;
//}



#pragma mark - IBActions
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    // TODO: Create and save task
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
