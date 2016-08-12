//
//  HourlyForecastModel.h
//  JFWeather
//
//  Created by ramborange on 16/8/1.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface HourlyForecastModel : NSManagedObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString* hum;
@property (nonatomic, copy) NSString* pop;
@property (nonatomic, copy) NSString* tmp;
@property (nonatomic, copy) NSString *pres;
//wind
@property (nonatomic, copy) NSString* deg;
@property (nonatomic, copy) NSString *dir;
@property (nonatomic, copy) NSString *sc;
@property (nonatomic, copy) NSString* spd;

@property (nonatomic, copy) NSString *cityId;
@end
