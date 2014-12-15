//
//  Loader.m
//  LegoHelper
//
//  Created by Student on 11/20/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "Loader.h"
#import "DataStore.h"
// XMLConveter Source: https://github.com/rsoldatenko/XMLConverter
#import "XMLConverter.h"
#import <UIKit/UIKit.h>

// Cubiculus
NSString *CUBICULUS_API_KEY = @"c6KLoXImuUmshxX5k9C8tPbTeMaKp18hau6jsnZn58ihe9I4Aj";
NSString *CUBICULUS_API_SINGLESET_URL = @"https://cubiculussets.p.mashape.com/lego-set/10l1g6blg76coa1o20deb7aa93q8a2ak6ad7m0k7viis14tjsnddbco24obnckb9/";
NSString *CUBICULUS_API_SINGLESET_INSTRUCTIONS_URL = @"http://www.cubiculus.com/api-rest/building-instruction/";

// Brickset
NSString *BRICKSET_API_KEY = @"llWF-mCRi-MhQV";
NSString *BRICKSET_API_URL = @"http://brickset.com/api/v2.asmx/";
NSString *BRICKSET_API_BS = @"&userHash=&query=&subtheme=&setNumber=&year=&owned=&wanted=&orderBy=&pageSize=&pageNumber=&userName=";

@implementation Loader

NSMutableArray *_data;
NSURLSession *_session;

NSMutableArray *_themes;
NSMutableArray *_subThemes;

// for XML Parsing
NSString *currentElement;
NSMutableString *_elementValue;

bool _isSubThemeRequest = FALSE;

// DataTask
NSURLSessionDataTask *_dataTask;

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
    _dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){[self completionHandler:data :response :error :FALSE];}];
    
    // resume dataTask
    [_dataTask resume];
}

- (void) loadSubThemes:(id)theme {
    //init sub themes
    _subThemes = [NSMutableArray array];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    //create new session
    _session = [NSURLSession sessionWithConfiguration:config];
    
    //show the activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //the url
    NSString *string = [NSString stringWithFormat:@"%@getSubthemes?apiKey=%@&Theme=%@", BRICKSET_API_URL, BRICKSET_API_KEY, theme];
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding : NSUTF8StringEncoding]];
    
    //build request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //request resource
    _dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){[self completionHandler:data :response :error :FALSE];}];
    
    //resume dataTask
    [_dataTask resume];
}

// download all sets in a theme
- (void) loadSets:(NSString *)themeName {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    //create new session
    _session = [NSURLSession sessionWithConfiguration:config];
    
    //show the activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //the url
    NSString *string = [NSString stringWithFormat:@"%@getSets?apiKey=%@&theme=%@%@", BRICKSET_API_URL, BRICKSET_API_KEY, themeName, BRICKSET_API_BS];
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding : NSUTF8StringEncoding]];
    
    //build request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //request resource
    _dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){[self completionHandler:data :response :error :FALSE];}];
    
    //resume dataTask
    [_dataTask resume];
    
}

// download the data via NSURLSession
- (void) loadSetInstructions:(NSString *)setID {

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    //create new session
    _session = [NSURLSession sessionWithConfiguration:config];
    
    //show the activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //the url
    NSString *string = [NSString stringWithFormat:@"%@getInstructions?apiKey=%@&setID=%@", BRICKSET_API_URL, BRICKSET_API_KEY, setID];
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding : NSUTF8StringEncoding]];
    
    //build request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //request resource
    _dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){[self completionHandler:data :response :error :FALSE];}];
    
    //resume dataTask
    [_dataTask resume];
    
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
    NSString *string = [NSString stringWithFormat:@"%@%@",CUBICULUS_API_SINGLESET_URL,setID];
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding : NSUTF8StringEncoding]];
    
    // build request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    // request resource
    _dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){[self completionHandler:data :response :error :TRUE];}];
    
    // resume dataTask
    [_dataTask resume];
    
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
            [XMLConverter convertXMLData:data completion:^(BOOL success, NSDictionary *dictionary, NSError *error)
             {                 
                 if (dictionary[@"ArrayOfThemes"]) {
                     [DataStore sharedStore].themes = dictionary[@"ArrayOfThemes"][@"themes"];

                     //post the notif
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"ThemesDidLoad"
                      object:nil];
                 }
                 
                 if (dictionary[@"ArrayOfSets"]) {
                     [self arrayOfSetsHandler:dictionary];
                     
                 } //end if arrayofsets
                 
                 if (dictionary[@"ArrayOfInstructions"]) {
                     [self arrayOfInstructionsHandler:dictionary[@"ArrayOfInstructions"]];
                 }
                
             }];
        } //end else
    } // end if statuscode
}

#pragma mark - Response Helpers

// handles the response error
- (void) onLoadError:(NSError *)error {
    NSLog(@"ERROR:%@", error);
}

// determines if statusCode is valid
- (BOOL) checkStatusCode:(NSHTTPURLResponse *)httpResp {
    if (httpResp.statusCode == 200)
        return TRUE;
    else
        NSLog(@"STATUSCODE = %i, response = %@", httpResp.statusCode, httpResp);
        return FALSE;
}

#pragma mark - Response Handlers

- (void) arrayOfInstructionsHandler:(NSDictionary *)dictionary {
    if (dictionary[@"instructions"] && [dictionary[@"instructions"] isKindOfClass:[NSString class]]) {
        [DataStore sharedStore].currentInstructionsURL = dictionary[@"instructions"][@"URL"];
    } else if ([dictionary[@"instructions"] isKindOfClass:[NSArray class]]) {
        [DataStore sharedStore].currentInstructionsURL = [dictionary[@"instructions"] objectAtIndex:0][@"URL"];
    }
    
    //post the notif
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"InstructionsURLDidLoad"
     object:nil];
}

// Sanitizes and sorts all sets from a theme
// and builds groupings for subthemes
- (void) arrayOfSetsHandler:(NSDictionary *)dictionary {
    
    [[DataStore sharedStore].subThemes removeAllObjects]; // reset the array
    
    // checks for case of only one set (eg. The Simpsons)
    if ([dictionary[@"ArrayOfSets"][@"sets"] isKindOfClass:[NSArray class]]) {
        // if its an array, go through it all
        for (NSDictionary *set in dictionary[@"ArrayOfSets"][@"sets"]) {
            NSString *setsThemeName = ([set[@"subtheme"] isEqualToString:@""]) ? set[@"theme"] : set[@"subtheme"];
            NSMutableDictionary *newSubtheme;
            NSMutableArray *newArray;
            BOOL subthemeExists = FALSE;
            NSNumber *subthemeIndex;
            
            // adds the initial subtheme
            if ([DataStore sharedStore].subThemes.count == 0 || [DataStore sharedStore].subThemes == nil) {
                newSubtheme = [[NSMutableDictionary alloc] init];
                newArray = [NSMutableArray array];
                [newSubtheme setObject:newArray forKey:setsThemeName];
                
                [[DataStore sharedStore].subThemes addObject:newSubtheme];
            } else {
                // checks if subtheme already exists
                for (int i = 0; i < [DataStore sharedStore].subThemes.count; i++) {
                    NSDictionary *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:i];
                    NSString *subThemeName = [[subtheme allKeys] objectAtIndex:0];
                    
                    if([setsThemeName isEqualToString:subThemeName]){
                        subthemeExists = TRUE;
                        subthemeIndex = [[NSNumber alloc] initWithInt:i];
                        break;
                    }
                }
                
                // adds the new subtheme if needed
                if(subthemeExists == FALSE){
                    newSubtheme = [[NSMutableDictionary alloc] init];
                    newArray = [NSMutableArray array];
                    [newSubtheme setObject:newArray forKey:setsThemeName];
                    
                    [[DataStore sharedStore].subThemes addObject:newSubtheme];
                    subthemeIndex = [[NSNumber alloc] initWithInt:[DataStore sharedStore].subThemes.count - 1];
                }
            }
            
            // add the set
            [[[DataStore sharedStore].subThemes objectAtIndex:[subthemeIndex intValue]][setsThemeName] addObject:set];
            
        } //end for set in dictionary
    } else {
        // if not an array (only one set), handle it as a signle item
        NSDictionary *set = dictionary[@"ArrayOfSets"][@"sets"];
        NSString *setsThemeName = ([set[@"subtheme"] isEqualToString:@""]) ? set[@"theme"] : set[@"subtheme"];
        
        NSMutableDictionary *newSubtheme = [[NSMutableDictionary alloc] init];
        NSMutableArray *newArray = [NSMutableArray array];
        [newSubtheme setObject:newArray forKey:setsThemeName];
        
        [[DataStore sharedStore].subThemes addObject:newSubtheme];
        
        [[[DataStore sharedStore].subThemes objectAtIndex:0][setsThemeName] addObject:set];
    }
    
    //post the notif
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SubThemesDidLoad"
     object:nil];
}


@end
