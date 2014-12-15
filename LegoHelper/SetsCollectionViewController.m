//
//  SetsCollectionViewController.m
//  LegoHelper
//
//  Created by Student on 12/13/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "SetsCollectionViewController.h"
#import "SetsCollectionCellVC.h"
#import "SectionHeaderCollectionReusableView.h"
#import "DataStore.h"

@interface SetsCollectionViewController ()

@end

@implementation SetsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self.navigationItem setHidesBackButton:YES];
    
    // Do any additional setup after loading the view.
    self.headerReferenceSize = CGSizeMake(200, 50);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [DataStore sharedStore].subThemes.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:section];
    
    NSString *subThemeName = [[subtheme allKeys] objectAtIndex:0];
    
    return [subtheme[subThemeName] count];
}

// Creates the actual cells

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SetsCollectionCellVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SetCell" forIndexPath:indexPath];
    
    NSDictionary *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:indexPath.section];
    
    NSString *subThemeName = [[subtheme allKeys] objectAtIndex:0];
    
    NSMutableArray *arrayOfSets = subtheme[subThemeName];
    
    NSDictionary *currentSet;
    
    if ([arrayOfSets count] > 0) {
        currentSet = [arrayOfSets objectAtIndex:indexPath.row];
        
        // create the cell with helper method
        cell = [cell buildCellWithSet:currentSet];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSLog(@"Collction Item Clicked");
}

#pragma mark – UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(200, 250);
    return retval;
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}


// adds section titles
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    
    SectionHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                   UICollectionElementKindSectionHeader withReuseIdentifier:@"SubthemeHeader" forIndexPath:indexPath];
    [self updateSectionHeader:headerView forIndexPath:indexPath];
    return headerView;
}

- (void)updateSectionHeader:(SectionHeaderCollectionReusableView *)header forIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:indexPath.section];
    
    NSString *subThemeName = [[subtheme allKeys] objectAtIndex:0];
    
    header.label.text = subThemeName;
}


@end
