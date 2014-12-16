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
#import "Loader.h"
#import "Subtheme.h"
#import "Set.h"
#import "DataStore.h"

@interface SetsCollectionViewController ()

@end

@implementation SetsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = NO;
    
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
    Subtheme *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:section];

    return [subtheme.arrayOfSets count];
}

// Creates the actual cells

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SetsCollectionCellVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SetCell" forIndexPath:indexPath];
    
    Subtheme *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:indexPath.section];
    
    NSDictionary *currentSet;
    
    if ([subtheme.arrayOfSets count] > 0) {
        currentSet = [subtheme.arrayOfSets objectAtIndex:indexPath.row];
        
        // create the cell with helper method
        cell = [cell buildCellWithSet:currentSet];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];

    Subtheme *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:indexPath.section];
    
    Set *selectedSet = [subtheme.arrayOfSets objectAtIndex:indexPath.row];
    
    Loader *loader = [[Loader alloc] init];
    [loader loadSetInstructions:selectedSet.setID];
    
    [self performSegueWithIdentifier:@"ShowInstructions" sender:self];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:(131.0/255.0) green:(183.0/255.0) blue:(212.0/255.0) alpha:1.0];
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
    Subtheme *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:indexPath.section];
    
    header.label.text = subtheme.name;
}


@end
