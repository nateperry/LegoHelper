//
//  Set.m
//  LegoHelper
//
//  Created by Student on 12/16/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import "Set.h"

@implementation Set

- (instancetype)initWithDictionary:(NSDictionary *)d
{
    self = [super init];
    if (self) {
        _name = d[@"name"];
        _theme = ([d[@"subtheme"] isEqualToString:@""]) ? d[@"theme"] : d[@"subtheme"];
        _setID = d[@"setID"];
        
        
        _thumbnailURL = (! [d[@"largeThumbnailURL"] isEqualToString:@""] && [d objectForKey:@"largeThumbnailURL"]) ? d[@"largeThumbnailURL"] : @"http://3.bp.blogspot.com/-fXcS1HZUQ3c/UauO7EeKzKI/AAAAAAAAU_U/mzwFdnFfpyo/s1600/pitr_LEGO_smiley_--_sad.png";;
    }
    return self;
}

@end
