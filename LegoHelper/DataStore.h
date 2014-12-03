//
//  DataStore.h
//  LegoHelper
//
//  Created by Student on 11/22/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject
@property (nonatomic) NSMutableArray *themes;
@property (nonatomic) NSMutableArray *subThemes;

+ (instancetype) sharedStore;

@end
