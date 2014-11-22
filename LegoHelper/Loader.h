//
//  Loader.h
//  LegoHelper
//
//  Created by Student on 11/20/14.
//  Copyright (c) 2014 Nate Perry and Nate Kierpiec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loader : NSObject<NSXMLParserDelegate>

@property (nonatomic, copy) NSMutableArray *themes;

@end
