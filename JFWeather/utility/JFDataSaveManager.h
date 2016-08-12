//
//  JFDataSaveManager.h
//  JFWeather
//
//  Created by ramborange on 16/7/27.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFDataSaveManager : NSObject<NSFetchedResultsControllerDelegate>
{
    NSManagedObjectContext *context;
    NSFetchedResultsController *results;
}
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSFetchedResultsController *results;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (JFDataSaveManager *)shareJFDataSaveManager;

//condition
- (void)addConditon:(Condition *)con;
- (ConditionModel *)getConditonWithCode:(NSInteger)code;
- (NSArray *)getAllConditions;
- (void)removeCondition:(ConditionModel *)conModel;
- (void)removeAllConditions;

//city
- (void)addCity:(City *)city;
- (CityModel *)getCityWithId:(NSString *)cityId;
- (NSArray *)getAllCities;
- (NSArray *)getMyAddedCities;
- (void)removeCity:(CityModel *)cityModel;
- (void)removeAllCities;

//aqi
- (void)addAqi:(AQI *)aqi;
- (AQIModel *)getAqiWithId:(NSString *)cityId;
- (void)removeAqi:(AQIModel *)aqiModel;

//daily forecast
- (void)addDailyForecast:(DailyForecast *)dailyForecast;
- (NSArray *)getAllDailyForecastWithId:(NSString *)cityId;
- (void)removeDailyForecast:(DailyForecastModel *)dailyForecastModel;
- (void)removeAllDailyForecastWithId:(NSString *)cityId;

//hourly forecast
- (void)addHourlyForecast:(HourlyForecast *)hourlyForecast;
- (NSArray *)getAllHourlyForecastWithId:(NSString *)cityId;
- (void)removeHourlyForecast:(HourlyForecastModel *)hourlyForecastModel;
- (void)removeAllHourlyForecastWithId:(NSString *)cityId;

//now
- (void)addNow:(Now *)now;
- (NowModel *)getNowWithId:(NSString *)cityId;
- (void)removeNow:(NowModel *)nowModel;

//suggestion
- (void)addSuggestion:(Suggestion *)suggestion;
- (NSArray *)getAllSugesstionWithId:(NSString *)cityId;
- (void)removeSuggestion:(SuggestionModel *)suggestionModel;
- (void)removeAllSuggestionsWithId:(NSString *)cityId;

#pragma mark - 保存数据
- (void)saveUpdate;

@end
