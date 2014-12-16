//
//  Loader.h
//  LegoHelper
//
//  Created by Student on 11/20/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Loader : NSObject<NSXMLParserDelegate>

// BrickSet API
- (void) loadAllThemes;
- (void) loadSubThemes:(id)theme;
- (void) loadSets:(NSString *)themeName;
- (void) loadSetInstructions:(NSString *)setID;
    
@end
