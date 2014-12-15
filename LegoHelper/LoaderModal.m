//
//  LoaderModal.m
//  LegoHelper
//
//  Created by Student on 12/4/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "LoaderModal.h"

@interface LoaderModal ()

@end

@implementation LoaderModal

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // load the template
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LoaderModalTemplate" ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *html = [NSMutableString stringWithString:template];
    // allows use of local files
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:bundlePath];
    
    [self.webView loadHTMLString:html baseURL:baseURL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
