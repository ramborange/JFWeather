//
//  JFDataSaveManager.m
//  JFWeather
//
//  Created by ramborange on 16/7/27.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "JFDataSaveManager.h"

#define STOREPATH   [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/sqlite1"]
static JFDataSaveManager *dataSaveManager = nil;
@implementation JFDataSaveManager
@synthesize context,results;

- (id)init {
    self = [super init];
    if (self) {
        [self initCoreData];
    }
    return self;
}

-(void)dealloc {
    self.results.delegate = nil;
    
}

+ (JFDataSaveManager *)shareJFDataSaveManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSaveManager = [[JFDataSaveManager alloc] init];
    });
    return dataSaveManager;
}

//初始化CoreData“Documents/chat1.sqlite”
- (void)initCoreData {
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:STOREPATH];
    //    NSLog(@"url path:%@",url.path);
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    //搜索工程中所有的.xcdatamodeld文件，并加载所有的实体到一个managedObjectModel实例中
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 创建持久化数据存储协调器
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    // 创建一个SQLite数据库作为数据存储
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:optionsDictionary error:&error]) {
        //        NSLog(@"Error: %@",[error localizedDescription]);
    }else{
        NSLog(@"successful...");
        // 创建托管对象上下文
        self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _persistentStoreCoordinator = persistentStoreCoordinator;
        [self.context setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
}

#pragma mark - Condition
//condition
- (void)addConditon:(Condition *)con {
    ConditionModel *model = [self getConditonWithCode:con.code];
    if (model!=nil) {
        [self removeCondition:model];
    }
    ConditionModel *conModel = (ConditionModel *)[NSEntityDescription insertNewObjectForEntityForName:@"ConditionModel" inManagedObjectContext:self.context];
    conModel.code = [NSNumber numberWithInteger:con.code];
    conModel.icon = con.icon;
    conModel.txt = con.txt;
    conModel.txt_en = con.txt_en;
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
}

- (ConditionModel *)getConditonWithCode:(NSInteger)code {
    ConditionModel *result;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ConditionModel" inManagedObjectContext:self.context]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"code" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code == %d",code];
    fetchRequest.predicate = predicate;
    
    NSError *error;
    self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.results.delegate = self;
    if (![[self results] performFetch:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    if (!self.results.fetchedObjects.count) {
        //        NSLog(@"has no results...");
        return nil;
    }else if([self.results.fetchedObjects count] > 1){
        
    }
    
    result = [self.results.fetchedObjects objectAtIndex:0];
    
    return result;
}

- (NSArray *)getAllConditions {
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    self.results = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ConditionModel" inManagedObjectContext:self.context]];
    
    //增加一个筛选条件
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"code" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code > 0"];
    
    fetchRequest.predicate = predicate;
    
    //设置结果集
    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:11 userInfo:nil];
    self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:self.context
                                                         sectionNameKeyPath:nil cacheName:@"Root"];
    self.results.delegate = self;
    //FIXME:经常在此崩溃
    if (![[self results] performFetch:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    if (!self.results.fetchedObjects.count) {
        //        NSLog(@"has no results...");
        return nil;
    }else{
        NSArray *returnArray =self.results.fetchedObjects;
        self.results = nil;
        return returnArray;
    }
}

- (void)removeCondition:(ConditionModel *)conModel {
    //删除
    [self.context deleteObject:conModel];
    
    //保存
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"error :%@",[error localizedDescription]);
    }
}

- (void)removeAllConditions {
    NSArray *allCons = [self getAllConditions];
    for (ConditionModel *model in allCons) {
        [self removeCondition:model];
    }
}

#pragma mark - City
//city
- (void)addCity:(City *)city {
    CityModel *model = [self getCityWithId:city.cityId];
    if (model!=nil) {
        [self removeCity:model];
    }
    CityModel *cityModel = (CityModel *)[NSEntityDescription insertNewObjectForEntityForName:@"CityModel" inManagedObjectContext:self.context];
    cityModel.city = city.city;
    cityModel.cityId = city.cityId;
    cityModel.prov = city.prov;
    cityModel.listIndex = @(0);
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (CityModel *)getCityWithId:(NSString *)cityId {
    CityModel *result;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"CityModel" inManagedObjectContext:self.context]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityId" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId = %@",cityId];
    fetchRequest.predicate = predicate;
    
    NSError *error;
    self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.results.delegate = self;
    if (![[self results] performFetch:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    if (!self.results.fetchedObjects.count) {
        //        NSLog(@"has no results...");
        return nil;
    }else if([self.results.fetchedObjects count] > 1){
        
    }
    
    result = [self.results.fetchedObjects objectAtIndex:0];
    
    return result;
}

- (NSArray *)getMyAddedCities {
    [NSFetchedResultsController deleteCacheWithName:@"Root2"];
    self.results = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"CityModel" inManagedObjectContext:self.context]];
    
    //增加一个筛选条件
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"listIndex" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isAdd == true"];
    
    fetchRequest.predicate = predicate;
    
    //设置结果集
    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:12 userInfo:nil];
    self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:self.context
                                                         sectionNameKeyPath:nil cacheName:@"Root2"];
    self.results.delegate = self;
    //FIXME:经常在此崩溃
    if (![[self results] performFetch:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    if (!self.results.fetchedObjects.count) {
        //        NSLog(@"has no results...");
        return nil;
    }else{
        NSArray *returnArray =self.results.fetchedObjects;
        self.results = nil;
        return returnArray;
    }
}

- (NSArray *)getAllCities {
    [NSFetchedResultsController deleteCacheWithName:@"Root2"];
    self.results = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"CityModel" inManagedObjectContext:self.context]];
    
    //增加一个筛选条件
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityId" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId BEGINSWITH 'CN'"];
    
    fetchRequest.predicate = predicate;
    
    //设置结果集
    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:12 userInfo:nil];
    self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:self.context
                                                         sectionNameKeyPath:nil cacheName:@"Root2"];
    self.results.delegate = self;
    //FIXME:经常在此崩溃
    if (![[self results] performFetch:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    if (!self.results.fetchedObjects.count) {
        //        NSLog(@"has no results...");
        return nil;
    }else{
        NSArray *returnArray =self.results.fetchedObjects;
        self.results = nil;
        return returnArray;
    }
}

- (void)removeCity:(CityModel *)cityModel {
    //删除
    [self.context deleteObject:cityModel];
    
    //保存
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"error :%@",[error localizedDescription]);
    }
}

- (void)removeAllCities {
    NSArray *allCities = [self getAllCities];
    for (CityModel *model in allCities) {
        [self removeCity:model];
    }
}


#pragma mark - AQI
//aqi
- (void)addAqi:(AQI *)aqi {
    AQIModel *aqiModel = [self getAqiWithId:aqi.cityId];
    if (aqiModel!=nil) {
        [self removeAqi:aqiModel];
    }
    AQIModel *model = (AQIModel *)[NSEntityDescription insertNewObjectForEntityForName:@"AQIModel" inManagedObjectContext:self.context];
    model.aqi = aqi.aqi;
    model.co = aqi.co;
    model.no2 = aqi.no2;
    model.o3 = aqi.o3;
    model.pm10 = aqi.pm10;
    model.pm25 = aqi.pm25;
    model.qlty = aqi.qlty;
    model.so2 = aqi.so2;
    model.cityId = aqi.cityId;
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (AQIModel *)getAqiWithId:(NSString *)cityId {
    AQIModel *result;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"AQIModel" inManagedObjectContext:self.context]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityId" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId = %@",cityId];
    fetchRequest.predicate = predicate;
    
    NSError *error;
    self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.results.delegate = self;
    if (![[self results] performFetch:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    if (!self.results.fetchedObjects.count) {
        //        NSLog(@"has no results...");
        return nil;
    }else if([self.results.fetchedObjects count] > 1){
        
    }
    
    result = [self.results.fetchedObjects objectAtIndex:0];
    
    return result;
}

- (void)removeAqi:(AQIModel *)aqiModel {
    //删除
    [self.context deleteObject:aqiModel];
    
    //保存
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"error :%@",[error localizedDescription]);
    }
}

#pragma mark - Daily Forecast
//daily forecast
- (void)addDailyForecast:(DailyForecast *)dailyForecast {
    DailyForecastModel *model = (DailyForecastModel *)[NSEntityDescription insertNewObjectForEntityForName:@"DailyForecastModel" inManagedObjectContext:self.context];
    model.sr = dailyForecast.sr;
    model.ss = dailyForecast.ss;
    model.code_d = dailyForecast.code_d;
    model.code_n = dailyForecast.code_n;
    model.txt_d = dailyForecast.txt_d;
    model.txt_n = dailyForecast.txt_n;
    model.hum = dailyForecast.hum;
    model.pcpn = dailyForecast.pcpn;
    model.pop = dailyForecast.pop;
    model.pres = dailyForecast.pres;
    model.vis = dailyForecast.vis;
    model.max = dailyForecast.max;
    model.min = dailyForecast.min;
    model.deg = dailyForecast.deg;
    model.dir = dailyForecast.dir;
    model.sc = dailyForecast.sc;
    model.spd = dailyForecast.spd;
    model.date = dailyForecast.date;
    model.cityId = dailyForecast.cityId;
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (NSArray *)getAllDailyForecastWithId:(NSString *)cityId {
    [NSFetchedResultsController deleteCacheWithName:@"Root3"];
    self.results = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"DailyForecastModel" inManagedObjectContext:self.context]];
    
    //增加一个筛选条件
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId == %@",cityId];
    
    fetchRequest.predicate = predicate;
    
    //设置结果集
    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:12 userInfo:nil];
    self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:self.context
                                                         sectionNameKeyPath:nil cacheName:@"Root3"];
    self.results.delegate = self;
    //FIXME:经常在此崩溃
    if (![[self results] performFetch:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    if (!self.results.fetchedObjects.count) {
        //        NSLog(@"has no results...");
        return nil;
    }else{
        NSArray *returnArray =self.results.fetchedObjects;
        self.results = nil;
        return returnArray;
    }
}

- (void)removeDailyForecast:(DailyForecastModel *)dailyForecastModel {
    //删除
    [self.context deleteObject:dailyForecastModel];
    
    //保存
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"error :%@",[error localizedDescription]);
    }
}

- (void)removeAllDailyForecastWithId:(NSString *)cityId {
    NSArray *dailyForecastes = [self getAllDailyForecastWithId:cityId];
    for (DailyForecastModel *model in dailyForecastes) {
        [self removeDailyForecast:model];
    }
}

#pragma mark - Hourly Forecast
//hourly forecast
- (void)addHourlyForecast:(HourlyForecast *)hourlyForecast {
    HourlyForecastModel *model = (HourlyForecastModel *)[NSEntityDescription insertNewObjectForEntityForName:@"HourlyForecastModel" inManagedObjectContext:self.context];
    model.date = hourlyForecast.date;
    model.hum = hourlyForecast.hum;
    model.pop = hourlyForecast.pop;
    model.tmp = hourlyForecast.tmp;
    model.deg = hourlyForecast.deg;
    model.dir = hourlyForecast.dir;
    model.sc = hourlyForecast.sc;
    model.spd = hourlyForecast.spd;
    model.pres = hourlyForecast.pres;
    model.cityId = hourlyForecast.cityId;
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (NSArray *)getAllHourlyForecastWithId:(NSString *)cityId {
    [NSFetchedResultsController deleteCacheWithName:@"Root4"];
    self.results = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"HourlyForecastModel" inManagedObjectContext:self.context]];
    
    //增加一个筛选条件
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId == %@",cityId];
    
    fetchRequest.predicate = predicate;
    
    //设置结果集
    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:12 userInfo:nil];
    self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:self.context
                                                         sectionNameKeyPath:nil cacheName:@"Root4"];
    self.results.delegate = self;
    //FIXME:经常在此崩溃
    if (![[self results] performFetch:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    if (!self.results.fetchedObjects.count) {
        //        NSLog(@"has no results...");
        return nil;
    }else{
        NSArray *returnArray =self.results.fetchedObjects;
        self.results = nil;
        return returnArray;
    }
}

- (void)removeHourlyForecast:(HourlyForecastModel *)hourlyForecastModel {
    //删除
    [self.context deleteObject:hourlyForecastModel];
    
    //保存
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"error :%@",[error localizedDescription]);
    }
}

- (void)removeAllHourlyForecastWithId:(NSString *)cityId {
    NSArray *hourlyForecastes = [self getAllHourlyForecastWithId:cityId];
    for (HourlyForecastModel *model in hourlyForecastes) {
        [self removeHourlyForecast:model];
    }
}


#pragma mark - Now
//now
- (void)addNow:(Now *)now {
    NowModel *nowModel = [self getNowWithId:now.cityId];
    if (nowModel != nil) {
        [self removeNow:nowModel];
    }
    NowModel *model = (NowModel *)[NSEntityDescription insertNewObjectForEntityForName:@"NowModel" inManagedObjectContext:self.context];
    model.code = now.code;
    model.txt = now.txt;
    model.fl = now.fl;
    model.hum = now.hum;
    model.pcpn = now.pcpn;
    model.pres = now.pres;
    model.tmp = now.tmp;
    model.vis = now.vis;
    model.deg = now.deg;
    model.dir = now.dir;
    model.sc = now.sc;
    model.spd = now.spd;
    model.cityId = now.cityId;
    model.updateLoc = now.updateLoc;
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
    
}

- (NowModel *)getNowWithId:(NSString *)cityId {
    NowModel *result;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"NowModel" inManagedObjectContext:self.context]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityId" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId = %@",cityId];
    fetchRequest.predicate = predicate;
    
    NSError *error;
    self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.results.delegate = self;
    if (![[self results] performFetch:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    if (!self.results.fetchedObjects.count) {
        //        NSLog(@"has no results...");
        return nil;
    }else if([self.results.fetchedObjects count] > 1){
        
    }
    
    result = [self.results.fetchedObjects objectAtIndex:0];
    
    return result;
}

- (void)removeNow:(NowModel *)nowModel {
    [self.context deleteObject:nowModel];
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

//suggestion
- (void)addSuggestion:(Suggestion *)suggestion {
    SuggestionModel *model = (SuggestionModel *)[NSEntityDescription insertNewObjectForEntityForName:@"SuggestionModel" inManagedObjectContext:self.context];
    model.brf = suggestion.brf;
    model.txt = suggestion.txt;
    model.cityId = suggestion.cityId;
    model.title = suggestion.title;
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"%@",error);
    }
}

- (NSArray *)getAllSugesstionWithId:(NSString *)cityId {
    [NSFetchedResultsController deleteCacheWithName:@"Root5"];
    self.results = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"SuggestionModel" inManagedObjectContext:self.context]];
    
    //增加一个筛选条件
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityId" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId == %@",cityId];
    
    fetchRequest.predicate = predicate;
    
    //设置结果集
    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:12 userInfo:nil];
    self.results = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                       managedObjectContext:self.context
                                                         sectionNameKeyPath:nil cacheName:@"Root5"];
    self.results.delegate = self;
    //FIXME:经常在此崩溃
    if (![[self results] performFetch:&error]) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    if (!self.results.fetchedObjects.count) {
        //        NSLog(@"has no results...");
        return nil;
    }else{
        NSArray *returnArray =self.results.fetchedObjects;
        self.results = nil;
        return returnArray;
    }
}

- (void)removeSuggestion:(SuggestionModel *)suggestionModel {
    [self.context deleteObject:suggestionModel];
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"%@",error);
    }
}

- (void)removeAllSuggestionsWithId:(NSString *)cityId {
    NSArray *allSuggestions = [self getAllSugesstionWithId:cityId];
    for (SuggestionModel *model in allSuggestions) {
        [self removeSuggestion:model];
    }
}

#pragma mark - 保存信息
- (void)saveUpdate
{
    if (self.context != nil) {
        NSError *error = nil;
        if ([self.context hasChanges] && ![self.context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
}

@end
