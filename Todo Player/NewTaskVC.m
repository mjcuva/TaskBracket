//
//  NewTaskVC.m
//  Todo Player
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "NewTaskVC.h"

@interface NewTaskVC ()
@property (strong, nonatomic) UINavigationBar *navBar;
@end

@implementation NewTaskVC

- (void)viewDidLoad{
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    UINavigationItem *navBarItem = [[UINavigationItem alloc] initWithTitle:@"New Task"];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    navBarItem.leftBarButtonItem = cancel;
    navBarItem.rightBarButtonItem = done;

    self.navBar.items = @[navBarItem];
    
    [self.view addSubview:self.navBar];
    
    
}

- (void)cancel{
    [self.delegate modalViewWasCanceled];
}

- (void)done{
    // TODO: Create and save task
    [self.delegate modalViewWasCompleted];
    
}

@end
