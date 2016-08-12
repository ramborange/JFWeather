//
//  Condition.h
//  JFWeather
//
//  Created by ramborange on 16/7/27.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Condition : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *txt;
@property (nonatomic, copy) NSString *txt_en;

@end
