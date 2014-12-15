
//
//  SetsCollectionCellVC.m
//  LegoHelper
//
//  Created by Student on 12/13/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "SetsCollectionCellVC.h"
#import "DataStore.h"

@implementation SetsCollectionCellVC

// creates the cell to be displayed
- (SetsCollectionCellVC *)buildCellWithSet:(NSDictionary *)currentSet {
    
    // load the template
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SetsCellTemplate" ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *html = [NSMutableString stringWithString:template];
        
    // make substitutions
    NSString *thumbnailPath = (! [currentSet[@"largeThumbnailURL"] isEqualToString:@""] && [currentSet objectForKey:@"largeThumbnailURL"]) ? currentSet[@"largeThumbnailURL"] : @"http://3.bp.blogspot.com/-fXcS1HZUQ3c/UauO7EeKzKI/AAAAAAAAU_U/mzwFdnFfpyo/s1600/pitr_LEGO_smiley_--_sad.png";
    [html replaceOccurrencesOfString:@"[[[thumbnail]]]" withString:thumbnailPath options:NSLiteralSearch range:NSMakeRange(0, html.length)];
    
    // resize webview
    CGRect frame = [self.webView frame];
    frame.size.height = 200;
    frame.size.width = 200;
    [self.webView setFrame:frame];
        
    // load html string into webView
    [self.webView loadHTMLString:html baseURL:nil];
        
    self.label.text = currentSet[@"name"];

    return self;
}

@end
