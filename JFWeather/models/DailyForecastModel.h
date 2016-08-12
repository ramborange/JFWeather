//
//  DailyForecastModel.h
//  JFWeather
//
//  Created by ramborange on 16/8/1.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DailyForecastModel : NSManagedObject
@property (nonatomic, copy) NSString *sr;//日出
@property (nonatomic, copy) NSString *ss;//日落

@property (nonatomic, copy) NSString *code_d;
@property (nonatomic, copy) NSString *code_n;
@property (nonatomic, copy) NSString *txt_d;
@property (nonatomic, copy) NSString *txt_n;

@property (nonatomic, copy) NSString* hum;
@property (nonatomic, copy) NSString* pcpn;
@property (nonatomic, copy) NSString* pop;
@property (nonatomic, copy) NSString* pres;
@property (nonatomic, copy) NSString* vis;
@property (nonatomic, copy) NSString *date;

//tmp
@property (nonatomic, copy) NSString* max;
@property (nonatomic, copy) NSString* min;

//wind
@property (nonatomic, copy) NSString* deg;//风向
@property (nonatomic, copy) NSString *dir;
@property (nonatomic, copy) NSString *sc;
@property (nonatomic, copy) NSString* spd;

@property (nonatomic, copy) NSString *cityId;
@end
