//
//  Suggestion.h
//  JFWeather
//
//  Created by ramborange on 16/8/1.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Suggestion : NSObject

@property (nonatomic, copy) NSString *brf;
@property (nonatomic, copy) NSString *txt;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *cityId;

@end
