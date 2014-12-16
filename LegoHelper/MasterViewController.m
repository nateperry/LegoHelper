//
//  MasterViewController.m
//  LegoHelper
//
//  Created by Student on 11/20/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "DataStore.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // subscribe to ThemeDidLoad notificaiton
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(themesDidLoad:)
     name:@"ThemesDidLoad" object:nil];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.filteredArray = [NSMutableArray arrayWithCapacity:[[DataStore sharedStore].themes count]];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Handles selection of theme
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *newTheme;
    
    // Checks if the item clicked is part of search results
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        newTheme = [[_filteredArray objectAtIndex:indexPath.row] name];
    } else {
        newTheme = [[[DataStore sharedStore].themes objectAtIndex:indexPath.row] name];
    }
    
    self.detailViewController.detailItem = newTheme;

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredArray count];
    } else {
        return [DataStore sharedStore].themes.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ThemeCell"];
    
    NSString *themeName;
    
    // Check to see whether the normal table or search results table is being displayed
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        themeName = [[_filteredArray objectAtIndex:indexPath.row] name];
    } else {
        themeName = [[[DataStore sharedStore].themes objectAtIndex:indexPath.row] name];
    }

    cell.textLabel.text = themeName;
    
    // changes selection color
    UIView *cellBg = [[UIView alloc] init];
    /// rgb(231, 76, 60)
    cellBg.backgroundColor = [UIColor colorWithRed:(231.0/255.0) green:(76.0/255.0) blue:(60.0/255.0)     alpha:1.0]; // this RGB value for blue color
    cellBg.layer.masksToBounds = YES;
    cell.selectedBackgroundView = cellBg;
    
    return cell;
}

#pragma mark - Notifications

- (void)themesDidLoad:(NSNotification*)notification{
    //refreshes master view
    
    //reload the data on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark Content Filtering

// handles searching
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    _filteredArray = [NSMutableArray arrayWithArray:[[DataStore sharedStore].themes filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
@end
