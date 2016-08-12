//
//  NowModel.h
//  JFWeather
//
//  Created by ramborange on 16/8/1.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NowModel : NSManagedObject
@property (nonatomic, copy) NSString* code;
@property (nonatomic, copy) NSString *txt;
@property (nonatomic, copy) NSString* fl;
@property (nonatomic, copy) NSString* hum;
@property (nonatomic, copy) NSString* pcpn;
@property (nonatomic, copy) NSString* pres;
@property (nonatomic, copy) NSString* tmp;
@property (nonatomic, copy) NSString* vis;

//wind
@property (nonatomic, copy) NSString* deg;
@property (nonatomic, copy) NSString *dir;
@property (nonatomic, copy) NSString *sc;
@property (nonatomic, copy) NSString *spd;
@property (nonatomic, copy) NSString *updateLoc;

@property (nonatomic, copy) NSString *cityId;
@end
