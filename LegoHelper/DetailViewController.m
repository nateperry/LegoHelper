//
//  DetailViewController.m
//  LegoHelper
//
//  Created by Student on 11/20/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "DetailViewController.h"
#import "Loader.h"
#import "DataStore.h"

@interface DetailViewController () <UITableViewDelegate>

@property IBOutlet UITableView *tableView;

@end

@implementation DetailViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // subscribe to SubThemeDidLoad notificaiton
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(subThemesDidLoad:)
     name:@"SubThemesDidLoad" object:nil];
    
}

- (void)subThemesDidLoad:(NSNotification*)notification{
    //refresh master view
    // TODO: Look into this running twice
    // NSLog(@"subthemes loaded");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showSubthemeList" sender:self];
    });
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        NSLog(@"Clicked %@", _detailItem);
        
        Loader *loader = [[Loader alloc] init];
        [loader loadSubThemes:_detailItem];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //not sure what we need here yet - may just have a default view to tell the user what to do.
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataStore sharedStore].subThemes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSLog(@"CELL = %@", [[DataStore sharedStore].subThemes objectAtIndex:indexPath.row]);
    cell.textLabel.text = [[DataStore sharedStore].subThemes objectAtIndex:indexPath.row];
    return cell;
}

@end
