//
//  City.m
//  JFWeather
//
//  Created by ramborange on 16/7/27.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "City.h"

@implementation City

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.cityId = value;
    }
//    JFLog(self, key);
}

@end
