//
//  InstructionsVC.m
//  LegoHelper
//
//  Created by Student on 12/14/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "InstructionsVC.h"
#import "DataStore.h"

@interface InstructionsVC ()

@end

@implementation InstructionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // subscribe to "InstructionsURLDidLoad" notification
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(instructionsURLDidLoad:)
     name:@"InstructionsURLDidLoad" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadWebView {
    NSURL *url = [[NSURL alloc] initWithString:[DataStore sharedStore].currentInstructionsURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - Notifcations

- (void) instructionsURLDidLoad:(NSNotification*)notification {
    [self reloadWebView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
