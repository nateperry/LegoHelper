//
//  DataStore.m
//  LegoHelper
//
//  Created by Student on 11/22/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

+ (id)sharedStore {
    static DataStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[DataStore sharedStore]!" userInfo:nil];
    return nil;
}

-(instancetype)initPrivate {
    self = [super init];
    if (self) {
        self.allItems = [[NSMutableArray alloc] init];
    }
    return self;
}

@end