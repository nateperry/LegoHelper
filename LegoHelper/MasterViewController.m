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

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Handles selection of theme
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *newTheme = [[DataStore sharedStore].themes objectAtIndex:indexPath.row][@"theme"];
    
    if (![newTheme isEqualToString:self.detailViewController.detailItem]) {
        self.detailViewController.detailItem = newTheme;
        NSLog(@"different theme selected");
    } else {
        NSLog(@"same theme selected");
    }
}

#pragma mark - Segues

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = [[DataStore sharedStore].allItems objectAtIndex:indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}
*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataStore sharedStore].themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [[DataStore sharedStore].themes objectAtIndex:indexPath.row][@"theme"];
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
@end
