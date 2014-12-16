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
#import "Theme.h"
#import "Subtheme.h"
#import "Set.h"
#import <UIKit/UIKit.h>

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
                     [self arrayOfThemesHandler:dictionary[@"ArrayOfThemes"][@"themes"]];
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

// hanldes alll themes for master view
- (void) arrayOfThemesHandler:(NSDictionary *)dictionary {
    
    NSMutableArray *allThemes = [[NSMutableArray alloc] init];
    
    for (NSDictionary *d in dictionary) {
        Theme *theme = [[Theme alloc] initWithDictionary:d];
        [allThemes addObject:theme];
    }
    
    
    [DataStore sharedStore].themes = [NSMutableArray arrayWithArray:allThemes];
    
    //post the notif
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ThemesDidLoad"
     object:nil];
}

// handles set instructions
- (void) arrayOfInstructionsHandler:(NSDictionary *)dictionary {
    // reset the url
    [DataStore sharedStore].currentInstructionsURL = [[NSMutableString alloc] initWithString:@""];
    
    if (dictionary[@"instructions"] && [dictionary[@"instructions"] isKindOfClass:[NSArray class]]) {
        [DataStore sharedStore].currentInstructionsURL = [dictionary[@"instructions"] objectAtIndex:0][@"URL"];
    } else if ([dictionary[@"instructions"][@"URL"] isKindOfClass:[NSString class]]) {
        [DataStore sharedStore].currentInstructionsURL = dictionary[@"instructions"][@"URL"];
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
        for (NSDictionary *s in dictionary[@"ArrayOfSets"][@"sets"]) {
            Set *set = [[Set alloc] initWithDictionary:s];
            
            Subtheme *newSubtheme;

            BOOL subthemeExists = FALSE;
            NSNumber *subthemeIndex;
            
            // adds the initial subtheme
            if ([DataStore sharedStore].subThemes.count == 0 || [DataStore sharedStore].subThemes == nil) {
                newSubtheme = [[Subtheme alloc] init];
                newSubtheme.name = set.theme;
                subthemeIndex = 0;
                
                [[DataStore sharedStore].subThemes addObject:newSubtheme];
            } else {
                // checks if subtheme already exists
                for (int i = 0; i < [DataStore sharedStore].subThemes.count; i++) {
                    Subtheme *subtheme = [[DataStore sharedStore].subThemes objectAtIndex:i];
                    
                    if([set.theme isEqualToString:subtheme.name]){
                        subthemeExists = TRUE;
                        subthemeIndex = [[NSNumber alloc] initWithInt:i];
                        break;
                    }
                }
                
                // adds the new subtheme if needed
                if(subthemeExists == FALSE){
                    newSubtheme = [[Subtheme alloc] init];
                    newSubtheme.name = set.theme;
                    
                    [[DataStore sharedStore].subThemes addObject:newSubtheme];
                    subthemeIndex = [[NSNumber alloc] initWithInt:[DataStore sharedStore].subThemes.count - 1];
                }
            }

            // add the set
            [[[[DataStore sharedStore].subThemes objectAtIndex:[subthemeIndex intValue]] arrayOfSets] addObject:set];
            
        } //end for set in dictionary
    } else {
        // if not an array (only one set), handle it as a signle item
        Set *set = [[Set alloc] initWithDictionary:dictionary[@"ArrayOfSets"][@"sets"]];
        
        Subtheme *newSubtheme = [[Subtheme alloc] init];
        NSMutableArray *newArray = [NSMutableArray array];
        [newSubtheme.arrayOfSets addObject:newArray];
        newSubtheme.name = set.theme;
        
        [[DataStore sharedStore].subThemes addObject:newSubtheme];
        
        [[[[DataStore sharedStore].subThemes objectAtIndex:0] arrayOfSets] addObject:set];
    }
    
    //post the notif
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SubThemesDidLoad"
     object:nil];
}


@end
