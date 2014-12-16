//
//  InstructionsVC.m
//  LegoHelper
//
//  Created by Student on 12/14/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "InstructionsVC.h"
#import "DataStore.h"

#define WEBVIEW_ERROR_PAGE @"http://3.bp.blogspot.com/-fXcS1HZUQ3c/UauO7EeKzKI/AAAAAAAAU_U/mzwFdnFfpyo/s1600/pitr_LEGO_smiley_--_sad.png"

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
    NSURL *url;
    BOOL showingError = false;
    if ([[DataStore sharedStore].currentInstructionsURL length] != 0) {
        url = [[NSURL alloc] initWithString:[DataStore sharedStore].currentInstructionsURL];
    } else {
        url = [[NSURL alloc] initWithString:WEBVIEW_ERROR_PAGE];
        showingError = true;
    }
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
