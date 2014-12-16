//
//  Subtheme.m
//  LegoHelper
//
//  Created by Student on 12/15/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "Subtheme.h"

@implementation Subtheme
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrayOfSets = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
