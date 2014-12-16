//
//  Theme.h
//  LegoHelper
//
//  Created by Student on 12/15/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject

@property NSString *name;

- (instancetype) initWithDictionary:(NSDictionary *)d;
@end
