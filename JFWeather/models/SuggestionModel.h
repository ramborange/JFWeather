//
//  SuggestionModel.h
//  JFWeather
//
//  Created by ramborange on 16/8/1.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SuggestionModel : NSManagedObject
@property (nonatomic, copy) NSString *brf;
@property (nonatomic, copy) NSString *txt;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *title;

@end
