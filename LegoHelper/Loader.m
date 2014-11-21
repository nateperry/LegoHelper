//
//  Loader.m
//  LegoHelper
//
//  Created by Student on 11/20/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "Loader.h"
#import <UIKit/UIKit.h>

// Cubiculus
NSString * API_KEY = @"c6KLoXImuUmshxX5k9C8tPbTeMaKp18hau6jsnZn58ihe9I4Aj";
NSString * API_URL = @"https://cubiculussets.p.mashape.com/lego-set/10l1g6blg76coa1o20deb7aa93q8a2ak6ad7m0k7viis14tjsnddbco24obnckb9/10187";

@implementation Loader

NSMutableArray *_data;
NSURLSession *_session;

- (instancetype)initWithData {
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

// download the data via NSURLSession
- (void) loadData {
    
    /**
     *
     *
     * SEE: http://stackoverflow.com/questions/19099448/send-post-request-using-nsurlsession
     * TODO: Attach headers to request
     * - Need to send API KEY with request
     *
     *
     */
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    // create new session
    _session = [NSURLSession sessionWithConfiguration:config];
    
    // show the activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // the url
    NSURL *url = [NSURL URLWithString:API_URL];
    
    // request resource
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){[self completionHandler:data :response :error];}];
    
    // resume dataTask
    [dataTask resume];
    
}

// Handles the completion and response
- (void) completionHandler:(NSData *)data :(NSURLResponse *)response :(NSError *)error {
    NSLog(@"COMPLETIONHANDLER: %@", data);
    
    // handle any errors
    if (error) {
        [self onLoadError:error];
        return;
    }
    
    // interpret the response
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
    
    // check for status code 200
    if ([self checkStatusCode:httpResp]) {
        NSError *jsonError;
        
        // convert to JSON
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if (!jsonError) {
            // start parsing
            NSLog(@"json = %@", json);
            
        } // end !jsonError
    }
    
}

// handles the response error
- (void) onLoadError:(NSError *)error {
    NSLog(@"ERROR:%@", error);
}

// determines if statusCode is valid
- (BOOL) checkStatusCode:(NSHTTPURLResponse *)httpResp {
    if (httpResp.statusCode == 200)
        return TRUE;
    else
        NSLog(@"STATUSCODE = %i", httpResp.statusCode);
        return FALSE;
}

@end
