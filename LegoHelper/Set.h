//
//  Set.h
//  LegoHelper
//
//  Created by Student on 12/16/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Set : NSObject

@property NSString *name;
@property NSString *setID;
@property NSString *thumbnailURL;
@property NSString *theme;

- (instancetype) initWithDictionary:(NSDictionary *)d;
@end
