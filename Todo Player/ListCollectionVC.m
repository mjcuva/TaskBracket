//
//  ListCollectionVC.m
//  Task Bracket
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "ListCollectionVC.h"
#import "ItemList+Description.h"
#import "CollectionCell.h"

@interface ListCollectionVC ()
@end

#define COLLECTION_VIEW_CELL_PADDING 20
#define COLLECTION_VIEW_NAVBAR_OFFSET 44
#define COLLECTION_VIEW_STATUSBAR_OFFSET 20
#define COLLECTION_VIEW_OFFSET 10

@implementation ListCollectionVC

#pragma mark - Abstract Methods

- (NSUInteger)numCollections{
    NSLog(@"%@", [self.objectList description]);
    return [self.objectList count];
}

- (NSString *)reuseID{
    return @"listCell";
}

- (void)updateCell:(UICollectionViewCell *)cell usingObject:(id)object{
    if([cell isKindOfClass:[CollectionCell class]]){
        if([object isKindOfClass:[ItemList class]]){
            CollectionCell *colCell = (CollectionCell *)cell;
            ItemList *iList = (ItemList *)object;
            colCell.lcv.description = iList.description;
            [colCell.lcv setNeedsDisplay];
        }
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
    newListTitleAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[newListTitleAlert textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [newListTitleAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"NewListPush"]){
        NSString *title;
        if([sender respondsToSelector:@selector(title)]){
            title = [sender performSelector:@selector(title)];
        }
        [segue.destinationViewController setTitle:title];
    }else if ([segue.identifier isEqualToString:@"CollectionCellPush"]){
        if([sender isKindOfClass:[CollectionCell class]]){
            CollectionCell *cell = (CollectionCell *)sender;
            [segue.destinationViewController setTitle:cell.lcv.title];
        }
    }
}

- (id)createListWithTitle:(NSString *)title{
    ItemList *list = [NSEntityDescription insertNewObjectForEntityForName:@"ItemList" inManagedObjectContext:self.context];
    list.title = title;
    return list;
}

@end
