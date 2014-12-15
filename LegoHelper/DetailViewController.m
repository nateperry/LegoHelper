//
//  DetailViewController.m
//  LegoHelper
//
//  Created by Student on 11/20/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "DetailViewController.h"
#import "Loader.h"
#import "LoaderModal.h"
#import "DataStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

LoaderModal *_loaderModal;
bool _themesLoaded = FALSE;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (!_themesLoaded) {
        // subscribe to ThemeDidLoad notificaiton
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(themesDidLoad:)
         name:@"ThemesDidLoad" object:nil];
    }
    
    // subscribe to SubThemeDidLoad notificaiton
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(subThemesDidLoad:)
     name:@"SubThemesDidLoad" object:nil];

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
        
        [self showModal];
        
        Loader *loader = [[Loader alloc] init];
        [loader loadSets:_detailItem];
    }
    // makes sure button exists on detail page
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItem.title = @"Themes";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _setCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SetCollectionView"];
    
    // initially show modal while themes load in detail view
    _loaderModal = [self.storyboard instantiateViewControllerWithIdentifier:@"LoaderModal"];
    [self.view addSubview:_loaderModal.view];
    [_loaderModal.view.window setRootViewController:self.view.window.rootViewController];
    
    
    if (!_themesLoaded) {
        [self showModal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifications

- (void)themesDidLoad:(NSNotification*)notification {
    [self hideModal];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _themesLoaded = TRUE;
}

- (void)subThemesDidLoad:(NSNotification*)notification {
    // TODO: Look into this running twice
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showSubthemeList" sender:self];
        [self hideModal];
    });
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Modal

- (void)showModal {
    // NSLog(@"%s", __func__);
    //[self performSegueWithIdentifier:@"ShowLoader" sender:self];
    [self presentViewController:_loaderModal animated:YES completion:nil];
}

- (void)hideModal {
    // NSLog(@"%s", __func__);
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
