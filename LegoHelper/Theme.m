//
//  Theme.m
//  LegoHelper
//
//  Created by Student on 12/15/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "Theme.h"

@implementation Theme

- (instancetype)initWithDictionary:(NSDictionary *)d {
    self = [super init];
    if (self) {
        _name = d[@"theme"];
    }
    return self;
}
@end
