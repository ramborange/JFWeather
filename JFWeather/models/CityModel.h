//
//  CityModel.h
//  JFWeather
//
//  Created by ramborange on 16/7/27.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CityModel : NSManagedObject

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *prov;
@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, strong) NSNumber *isAdd;

@property (nonatomic, strong) NSNumber *listIndex;

@end
