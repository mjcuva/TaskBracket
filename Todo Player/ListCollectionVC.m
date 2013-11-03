//
//  ListCollectionVC.m
//  Task Bracket
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "ListCollectionVC.h"
#import "ItemList+Description.h"
#import "ItemList+colors.h"
#import "CollectionCell.h"
#import "ListView.h"
#import "UIColor+random.h"

@interface ListCollectionVC () <UIActionSheetDelegate>
@property (strong, nonatomic) UIActionSheet *actionSheet;

// Cell pressed to bring up action sheet
@property (strong, nonatomic) CollectionCell *pressedCell;

@end

#define COLLECTION_VIEW_CELL_PADDING 20
#define COLLECTION_VIEW_NAVBAR_OFFSET 44
#define COLLECTION_VIEW_STATUSBAR_OFFSET 20
#define COLLECTION_VIEW_OFFSET 10

#define ALERT_VIEW_CREATE_TAG 1
#define ALERT_VIEW_EDIT_TAG 2

@implementation ListCollectionVC

#pragma mark - Abstract Methods

- (NSUInteger)numCollections{
    NSLog(@"%@", [self.objectList description]);
    return [self.objectList count];
}

- (NSString *)reuseID{
    return @"listCell";
}

- (void)loadViewList{
    [self.viewList removeAllObjects];
    for(ItemList *iList in self.objectList){
        ListView *view = (ListView *)[self cellView];
        NSLog(@"Text: %@", iList.description);
        view.text = iList.description;
        view.color = [iList color];
        
        [self.viewList addObject:view];
    }
}

- (void)updateCell:(UICollectionViewCell *)cell{
    if([cell isKindOfClass:[CollectionCell class]]){
        CollectionCell *colCell = (CollectionCell *)cell;
            
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet:)];
        [colCell addGestureRecognizer:lp];
    }
}

- (void)setCollectionViewCellSize{
    CGFloat size = self.view.frame.size.width / 2 - COLLECTION_VIEW_CELL_PADDING;
    self.flowLayout.itemSize = CGSizeMake(size, size);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(COLLECTION_VIEW_NAVBAR_OFFSET + COLLECTION_VIEW_OFFSET + COLLECTION_VIEW_STATUSBAR_OFFSET, COLLECTION_VIEW_OFFSET, 44, COLLECTION_VIEW_OFFSET);
}

- (id)objectAtIndex:(NSUInteger)index{
    return self.objectList[index];
}

- (NSString *)entityName{
    return @"ItemList";
}


- (void) createObjectList{
    // Setup Request
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = nil; // all
    
    // Perform Fetch
    NSError *err;
    self.objectList = [self.context executeFetchRequest:request error:&err];
    
    if(err)
        NSLog(@"%@", [err description]);
    else
        NSLog(@"New Task List Created");
}

# pragma mark - Add Item

- (IBAction)addItem:(UIBarButtonItem *)sender {
    UIAlertView *newListTitleAlert = [[UIAlertView alloc] initWithTitle:@"Enter List Title" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    newListTitleAlert.tag = ALERT_VIEW_CREATE_TAG;
    newListTitleAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[newListTitleAlert textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [newListTitleAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == ALERT_VIEW_CREATE_TAG){
        if(buttonIndex == 1){
            
            NSFetchRequest *listRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
            listRequest.predicate = [NSPredicate predicateWithFormat:@"title = %@", [alertView textFieldAtIndex:0].text];
            NSArray *lists = [self.context executeFetchRequest:listRequest error:NULL];
            
            NSString *title = [alertView textFieldAtIndex:0].text;
            
            if([lists count] == 0 && [title length] > 0){
                id list = [self createListWithTitle:title];
                NSLog(@"Created List %@", [alertView textFieldAtIndex:0].text);
                [self reloadCollectionView];
                [self performSegueWithIdentifier:@"NewListPush" sender:list];
            }else if([lists count] == 1){
                // Go to existing list
                [self performSegueWithIdentifier:@"NewListPush" sender:[lists lastObject]];
            }
        }
    }else if(alertView.tag == ALERT_VIEW_EDIT_TAG){
        if(buttonIndex == 1){
            NSFetchRequest *listRequest = [NSFetchRequest fetchRequestWithEntityName:@"ItemList"];
            listRequest.predicate = [NSPredicate predicateWithFormat:@"title = %@", self.pressedCell.view.text];
            ItemList *list = [[self.context executeFetchRequest:listRequest error:NULL] lastObject];
            assert(list != nil);
            list.title = [alertView textFieldAtIndex:0].text;
            [self reloadCollectionView];
        }
    }
}

#pragma GCC diagnostic ignored "-Wundeclared-selector"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // TODO: Clean code
    if([segue.identifier isEqualToString:@"NewListPush"]){
        NSString *title;
        UIColor *color;
        if([sender respondsToSelector:@selector(title)]){
            title = [sender performSelector:@selector(title)];
            color = [sender performSelector:@selector(color)];
        }
        [segue.destinationViewController setTitle:title];
        [segue.destinationViewController performSelector:@selector(setViewColor:) withObject:color];
    }else if ([segue.identifier isEqualToString:@"CollectionCellPush"]){
        if([sender isKindOfClass:[CollectionCell class]]){
            CollectionCell *cell = (CollectionCell *)sender;
            [segue.destinationViewController setTitle:cell.view.text];
            [segue.destinationViewController performSelector:@selector(setViewColor:) withObject:cell.view.color];
        }
    }
}

- (id)createListWithTitle:(NSString *)title{
    ItemList *list = [NSEntityDescription insertNewObjectForEntityForName:@"ItemList" inManagedObjectContext:self.context];
    list.title = title;
    [list setColor:[UIColor randomColor]];
    return list;
}

# pragma mark - UIActionSheet

#define EDIT_BUTTON_TITLE @"Edit Title"
#define CANCEL_BUTTON_TITLE @"Cancel"
#define DELETE_BUTTON_TITLE @"Delete"

- (void)showActionSheet:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateRecognized){
        CGPoint loc = [sender locationInView:self.view];
        self.pressedCell = (CollectionCell *)[self.collectionView cellForItemAtIndexPath: [self.collectionView indexPathForItemAtPoint:loc]];
        NSLog(@"%@", self.pressedCell.view.text);
        
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:CANCEL_BUTTON_TITLE destructiveButtonTitle:DELETE_BUTTON_TITLE otherButtonTitles:EDIT_BUTTON_TITLE, nil];
        [self.actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:EDIT_BUTTON_TITLE]){
        UIAlertView *editAV = [[UIAlertView alloc] initWithTitle:@"Edit List Title" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        editAV.tag = ALERT_VIEW_EDIT_TAG;
        editAV.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[editAV textFieldAtIndex:0] setAutocapitalizationType: UITextAutocapitalizationTypeWords];
        [editAV textFieldAtIndex:0].text = self.pressedCell.view.text;
        [editAV show];
    }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:DELETE_BUTTON_TITLE]){
        
#warning Orphaned Core Data?
        
        NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"ItemList"];
        req.predicate = [NSPredicate predicateWithFormat:@"title = %@", self.pressedCell.view.text];
        ItemList *list = [[self.context executeFetchRequest:req error:NULL] lastObject];
        assert(list != nil);
        [self.context deleteObject:list];
        [UIView animateWithDuration:.25 animations:^{
            self.pressedCell.alpha = 0;
        } completion:^(BOOL success){
           [self reloadCollectionView];
        }];
    }
}

- (BaseView *)cellView{
    return [[ListView alloc] initWithFrame:CGRectMake([self viewX], 0, [self viewWidth], self.flowLayout.itemSize.height)];
}






@end
