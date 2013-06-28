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
#import <CoreData/CoreData.h>

@interface TaskCollectionVC () <UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout,
                                UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;
@end

@implementation TaskCollectionVC

#define COLLECTION_VIEW_CELL_PADDING 20
#define COLLECTION_VIEW_NAVBAR_OFFSET 44
#define COLLECTION_VIEW_STATUSBAR_OFFSET 20
#define COLLECTION_VIEW_OFFSET 10

- (void)viewDidLoad{
    self.collectionView.dataSource = self;
    [self useDocument];
    [self setCollectionViewCellSize];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self setCollectionViewCellSize];
    [self.collectionView reloadData];
}

- (void)setCollectionViewCellSize{
    CGFloat size = self.view.frame.size.width / 2 - COLLECTION_VIEW_CELL_PADDING;
    self.flowLayout.itemSize = CGSizeMake(size, size);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(COLLECTION_VIEW_NAVBAR_OFFSET + COLLECTION_VIEW_OFFSET + COLLECTION_VIEW_STATUSBAR_OFFSET, COLLECTION_VIEW_OFFSET, 44, COLLECTION_VIEW_OFFSET);
}

- (void)reloadCollectionView{
    [self createTaskList];
    [self.collectionView reloadData];
}

#pragma mark - Core Data

- (void)useDocument{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Task Data"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if(success){
                self.context = document.managedObjectContext;
            }
        }];
    }else if(document.documentState == UIDocumentStateClosed){
        [document openWithCompletionHandler:^(BOOL success){
            if(success){
                self.context = document.managedObjectContext;
            }
        }];
    }else{
        self.context = document.managedObjectContext;
    }
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
        
        // Reload CollectionView
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

- (void) createTaskList{
    // Setup Request
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = nil; // all
    
    // Perform Fetch
    NSError *err;
    self.taskLists = [self.context executeFetchRequest:request error:&err];
    
    if(err)
        NSLog(@"%@", [err description]);
    else
        NSLog(@"New Task List Created");
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

@end
    