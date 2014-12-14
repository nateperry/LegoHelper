//
//  SetsCollectionViewController.m
//  LegoHelper
//
//  Created by Student on 12/13/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "SetsCollectionViewController.h"
#import "SetsCollectionCellVC.h"
#import "DataStore.h"

@interface SetsCollectionViewController ()

@end

@implementation SetsCollectionViewController

int _currentSectionIndex;
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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
    _currentSectionIndex = section;
    NSDictionary *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:section];
    
    NSString *subThemeName = [[subtheme allKeys] objectAtIndex:0];
    
    return [subtheme[subThemeName] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SetsCollectionCellVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SetCell" forIndexPath:indexPath];
    
    NSDictionary *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:_currentSectionIndex];
    
    NSString *subThemeName = [[subtheme allKeys] objectAtIndex:0];
    
    NSMutableArray *arrayOfSets = subtheme[subThemeName];
    
    NSDictionary *currentSet;

    
    if ([arrayOfSets count] > 0) {
        NSLog(@"row = %i", indexPath.row);
        currentSet = [arrayOfSets objectAtIndex:indexPath.row];
        
        // load the template
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SetsCellTemplate" ofType:@"html"];
        NSString *template = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSMutableString *html = [NSMutableString stringWithString:template];
        
        // make substitutions
        NSString *thumbnailPath = ! [currentSet[@"largeThumbnailURL"] isEqualToString:@""] ? currentSet[@"largeThumbnailURL"] : @"http://3.bp.blogspot.com/-fXcS1HZUQ3c/UauO7EeKzKI/AAAAAAAAU_U/mzwFdnFfpyo/s1600/pitr_LEGO_smiley_--_sad.png";
        [html replaceOccurrencesOfString:@"[[[thumbnail]]]" withString:thumbnailPath options:NSLiteralSearch range:NSMakeRange(0, html.length)];
        
        CGRect frame = [cell.webView frame];
        frame.size.height = 200;
        frame.size.width = 200;
        [cell.webView setFrame:frame];
        
        // load html string into webView
        [cell.webView loadHTMLString:html baseURL:nil];
        
        cell.label.text = currentSet[@"name"];
    }
    
    // Configure the cell
    cell.backgroundColor = [UIColor redColor];
    
    
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


@end
