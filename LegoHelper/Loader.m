//
//  Loader.m
//  LegoHelper
//
//  Created by Student on 11/20/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "Loader.h"
#import "DataStore.h"
#import <UIKit/UIKit.h>

// Cubiculus
NSString *CUBICULUS_API_KEY = @"c6KLoXImuUmshxX5k9C8tPbTeMaKp18hau6jsnZn58ihe9I4Aj";
NSString *CUBICULUS_API_SINGLESET_URL = @"https://cubiculussets.p.mashape.com/lego-set/10l1g6blg76coa1o20deb7aa93q8a2ak6ad7m0k7viis14tjsnddbco24obnckb9/";

// Brickset
NSString *BRICKSET_API_KEY = @"llWF-mCRi-MhQV";
NSString *BRICKSET_API_URL = @"http://brickset.com/api/v2.asmx/";

@implementation Loader

NSMutableArray *_data;
NSURLSession *_session;

NSMutableArray *_themes;

// for XML Parsing
NSString *currentElement;
NSMutableString *_elementValue;

- (instancetype) init {
    self = [super init];
    if (self) {
        [self loadAllThemes];
        // [self loadSet:@"10187"];
    }
    return self;
}


// download the data via NSURLSession
- (void) loadAllThemes {
    
    // initialize themes
    _themes = [NSMutableArray array];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    // create new session
    _session = [NSURLSession sessionWithConfiguration:config];
    
    // show the activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // the url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@getThemes?apiKey=%@",BRICKSET_API_URL, BRICKSET_API_KEY]];
    
    
    // build request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // request resource
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){[self completionHandler:data :response :error :FALSE];}];
    
    // resume dataTask
    [dataTask resume];
    
}

// download the data via NSURLSession
- (void) loadSet:(NSString *)setID {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    // add API KEY
    config.HTTPAdditionalHeaders = @{@"X-Mashape-Key": CUBICULUS_API_KEY};
    
    
    // create new session
    _session = [NSURLSession sessionWithConfiguration:config];

    // show the activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // the url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CUBICULUS_API_SINGLESET_URL,setID]];
    
    // build request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    // request resource
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){[self completionHandler:data :response :error :TRUE];}];
    
    // resume dataTask
    [dataTask resume];
    
}

// Handles the completion and response
- (void) completionHandler:(NSData *)data :(NSURLResponse *)response :(NSError *)error :(BOOL)isJSON {
    // NSLog(@"response: %@", response);
    
    // remove Network Activity Indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
        
        if (isJSON) {
            // convert to JSON
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        
            if (!jsonError) {
                // start parsing
                NSLog(@"json = %@", json);
            
            } // end !jsonError
        } else {
            // convert XML to JSON
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            xmlParser.delegate = self;
            [xmlParser parse];
        }
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


#pragma - mark NSXMLParser delegate

// parsing started
- (void) parserDidStartDocument:(NSXMLParser *)parser {
    // NSLog(@"PARSING FILE STARTED");
}

// parsing complete
- (void) parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"THEMES = %@", _themes);
    [DataStore sharedStore].allItems = _themes;
}

// sets current element
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    _elementValue = [[NSMutableString alloc] init];
    if ([elementName isEqualToString:@"theme"]) {
        currentElement = [elementName copy];
    }
}

// adds the value of the node to the array
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"theme"]) {
        [_themes addObject:_elementValue];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([currentElement isEqualToString:@"theme"]) {
        // add the trimmed theme name
        [_elementValue appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
}


@end
