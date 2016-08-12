//
//  AQI.h
//  JFWeather
//
//  Created by ramborange on 16/8/1.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQI : NSObject

@property (nonatomic, copy) NSString* aqi;
@property (nonatomic, copy) NSString* co;
@property (nonatomic, copy) NSString* no2;
@property (nonatomic, copy) NSString* o3;
@property (nonatomic, copy) NSString* pm10;
@property (nonatomic, copy) NSString* pm25;
@property (nonatomic, copy) NSString* qlty;
@property (nonatomic, copy) NSString* so2;

@property (nonatomic, copy) NSString *cityId;

@end
