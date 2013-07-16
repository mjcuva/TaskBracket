//
//  TaskCollectionVC.m
//  Todo Player
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "TaskCollectionVC.h"
#import "CollectionCell.h"
#import "ListView.h"
#import "SharedManagedObjectContext.h"
#import <CoreData/CoreData.h>

@interface TaskCollectionVC () <UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout,
                                UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;
@end

@implementation TaskCollectionVC



- (void)viewDidLoad{
    self.collectionView.dataSource = self;
    [SharedManagedObjectContext getSharedContextWithCompletionHandler:^(NSManagedObjectContext *context){
        self.context = context;
    }];
    [self setCollectionViewCellSize];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self setCollectionViewCellSize];
    [self.collectionView reloadData];
}



- (void)reloadCollectionView{
    [self createTaskList];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self numCollections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self reuseID] forIndexPath:indexPath];
    if([cell isKindOfClass:[CollectionCell class]]){
        CollectionCell *collectionCell = (CollectionCell *)cell;
        if(!collectionCell.lcv){
            ListView *lv = [[ListView alloc] initWithFrame:CGRectMake(0, 0, self.flowLayout.itemSize.width, self.flowLayout.itemSize.height)];
            collectionCell.lcv = lv;
            [collectionCell addSubview:lv];
        }
        NSLog(@"Item Number: %ul", indexPath.item);
        id list = [self listAtIndex:indexPath.item];
        [self updateCell:collectionCell usingList:list];
    }
    return cell;
}

- (void)setContext:(NSManagedObjectContext *)context{
    _context = context;
    if(context){ 
        [self reloadCollectionView];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath:%@", [indexPath description]);
//    [self performSegueWithIdentifier:@"ShowList" sender:[self listAtIndex:indexPath.item]];
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


#pragma mark - Abstract

- (NSUInteger)numCollections{
    return 0;
}

- (NSString *)reuseID{
    return nil;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingList:(id)list{

}

- (id)listAtIndex:(NSUInteger)index{
    return nil;
}

- (NSString *)entityName{
    return nil;
}

- (id)createListWithTitle:(NSString *)title{
    return nil;
}

- (void)createTaskList{
    
}

- (void)setCollectionViewCellSize{
    
}

@end
    