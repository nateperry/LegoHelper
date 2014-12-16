
//
//  SetsCollectionCellVC.m
//  LegoHelper
//
//  Created by Student on 12/13/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "SetsCollectionCellVC.h"
#import "Set.h"
#import "DataStore.h"

@implementation SetsCollectionCellVC

// creates the cell to be displayed
- (SetsCollectionCellVC *)buildCellWithSet:(Set *)currentSet {
    
    self.layer.cornerRadius = 6.0;
    
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    // load the template
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SetsCellTemplate" ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *html = [NSMutableString stringWithString:template];
        
    // make substitutions
    [html replaceOccurrencesOfString:@"[[[thumbnail]]]" withString:currentSet.thumbnailURL options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    
    // load html string into webView
    [self.webView loadHTMLString:html baseURL:nil];
        
    self.label.text = currentSet.name;

    return self;
}

@end
