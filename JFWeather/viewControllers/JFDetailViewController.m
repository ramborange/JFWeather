//
//  JFDetailViewController.m
//  JFWeather
//
//  Created by ramborange on 16/7/27.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "JFDetailViewController.h"
#import "ForecastView.h"
#import "SuggestionView.h"
@interface JFDetailViewController ()
{
    dispatch_source_t _timer;
}
@property (nonatomic, strong) UIScrollView *weatherScrollview;

@property (nonatomic, copy) NSString *cityId;
@end

@implementation JFDetailViewController
-(void)dealloc {
    for (UIView *v in [_weatherScrollview subviews]) {
        [v removeFromSuperview];
    }
    dispatch_source_cancel(_timer);
    [_weatherScrollview removeFromSuperview];
    _weatherScrollview = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = RGBA(236, 236, 236, 1);
    self.view.backgroundColor = [UIColor whiteColor];
    
    _weatherScrollview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _weatherScrollview.showsVerticalScrollIndicator = NO;
    [_weatherScrollview setContentSize:CGSizeMake(screenWidth, 1500)];
    [self.view addSubview:_weatherScrollview];

    NSArray *mycityArray = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities];
    CityModel *model = mycityArray[self.dataIndex];
    self.cityId = model.cityId;
    _weatherScrollview.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    NSArray *images = @[[UIImage imageNamed:@"fengche0"],[UIImage imageNamed:@"fengche1"],[UIImage imageNamed:@"fengche2"],[UIImage imageNamed:@"fengche3"]];
    [(MJRefreshGifHeader *)_weatherScrollview.mj_header setImages:images duration:0.1 forState:MJRefreshStateRefreshing];
    [(MJRefreshGifHeader *)_weatherScrollview.mj_header setImages:images duration:0.1 forState:MJRefreshStateIdle];
    [_weatherScrollview.mj_header beginRefreshing];
    

    [self setUPWeatherUI];
}

#pragma mark - setUp UI
- (void)setUPWeatherUI {
    UIImageView *condImg = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2-30, 40, 60, 60)];
    condImg.tag = 100;
    [_weatherScrollview addSubview:condImg];
    
    UILabel *pm25Label = [Utility GetLabelWithFrame:CGRectMake(15, 100, 200, 40) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:13] textAlig:0 textColor:themeColor];
    pm25Label.tag = 99;
    [_weatherScrollview addSubview:pm25Label];
    
    UILabel *condTxtLabel = [Utility GetLabelWithFrame:CGRectMake(0, 100, screenWidth, 40) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:24] textAlig:1 textColor:themeColor];
    condTxtLabel.tag = 101;
    [_weatherScrollview addSubview:condTxtLabel];
    
    UILabel *updateLabel = [Utility GetLabelWithFrame:CGRectMake(screenWidth-200, 30, 185, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:13] textAlig:2 textColor:themeColor];
    updateLabel.tag = 102;
    [_weatherScrollview addSubview:updateLabel];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(15, 150, screenWidth-30, 0.5);
    layer.backgroundColor = themeColor.CGColor;
    [_weatherScrollview.layer addSublayer:layer];
    
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(screenWidth/2, 160, 0.5, 100);
    layer2.backgroundColor = themeColor.CGColor;
    [_weatherScrollview.layer addSublayer:layer2];
    
    CALayer *layer3 = [CALayer layer];
    layer3.frame = CGRectMake(15, 320, screenWidth-30, 0.5);
    layer3.backgroundColor = themeColor.CGColor;
    [_weatherScrollview.layer addSublayer:layer3];
    
    CALayer *layer4 = [CALayer layer];
    layer4.frame = CGRectMake(15, 780, screenWidth-30, 0.5);
    layer4.backgroundColor = themeColor.CGColor;
    [_weatherScrollview.layer addSublayer:layer4];
    
    UILabel *flLabel = [Utility GetLabelWithFrame:CGRectMake(0, 160, screenWidth/2, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:1 textColor:themeColor];
    flLabel.tag = 103;
    [_weatherScrollview addSubview:flLabel];
    
    UILabel *humLabel = [Utility GetLabelWithFrame:CGRectMake(0, 200, screenWidth/2, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:1 textColor:themeColor];
    humLabel.tag = 104;
    [_weatherScrollview addSubview:humLabel];
    
    UILabel *tmpLabel = [Utility GetLabelWithFrame:CGRectMake(0, 180, screenWidth/2, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:1 textColor:themeColor];
    tmpLabel.tag = 105;
    [_weatherScrollview addSubview:tmpLabel];
    
    UILabel *presLabel = [Utility GetLabelWithFrame:CGRectMake(0, 220, screenWidth/2, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:1 textColor:themeColor];
    presLabel.tag = 106;
    [_weatherScrollview addSubview:presLabel];
    
    UILabel *visLabel = [Utility GetLabelWithFrame:CGRectMake(0, 240, screenWidth/2, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:1 textColor:themeColor];
    visLabel.tag = 107;
    [_weatherScrollview addSubview:visLabel];
    
    UIImageView *fengCheImg = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2+(screenWidth/4-15), 170, 30, 30)];
    [fengCheImg setImage:[UIImage imageNamed:@"fengche"]];
    fengCheImg.tag = 108;
    [_weatherScrollview addSubview:fengCheImg];
    
    __weak __typeof(fengCheImg)weakImg = fengCheImg;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        weakImg.transform = CGAffineTransformRotate(weakImg.transform, 0.05);
    });
    _timer = timer;
    dispatch_resume(timer);
    
    UILabel *windLabel = [Utility GetLabelWithFrame:CGRectMake(screenWidth/2, 210, screenWidth/2, 40) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:1 textColor:themeColor];
    windLabel.tag = 109;
    [_weatherScrollview addSubview:windLabel];
    
    UILabel *titleLabel = [Utility GetLabelWithFrame:CGRectMake(20, 300, screenWidth, 20) text:@"未来七天天气预报" font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:0 textColor:[UIColor darkGrayColor]];
    [_weatherScrollview addSubview:titleLabel];
   
    for (int i=0; i<7; i++) {
        ForecastView *view = [[ForecastView alloc] initWithFrame:CGRectMake(0, 330+(40+20)*i, screenWidth, 40)];
        view.tag = 200+i;
        [_weatherScrollview addSubview:view];
    }
    
    UILabel *titleLabel2 = [Utility GetLabelWithFrame:CGRectMake(20, 760, screenWidth, 20) text:@"生活建议小贴士" font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:0 textColor:[UIColor darkGrayColor]];
    [_weatherScrollview addSubview:titleLabel2];
    
    for (int i=0; i<7; i++) {
        SuggestionView *view = [[SuggestionView alloc] initWithFrame:CGRectMake(0, 790+(90)*i, screenWidth, 80)];
        view.tag = 300+i;
        [_weatherScrollview addSubview:view];
    }
    [self refreshWeaherView];
}

#pragma mark - 刷新视图
- (void)refreshWeaherView {
    NowModel *nowModel = [[JFDataSaveManager shareJFDataSaveManager] getNowWithId:self.cityId];
    AQIModel *aqiModel = [[JFDataSaveManager shareJFDataSaveManager] getAqiWithId:self.cityId];
        
    ConditionModel *condModel = [[JFDataSaveManager shareJFDataSaveManager] getConditonWithCode:[nowModel.code integerValue]];
    
    UIImageView *condImg = (UIImageView *)[_weatherScrollview viewWithTag:100];
    UILabel *condTxtLabel = (UILabel *)[_weatherScrollview viewWithTag:101];
    UILabel *updateLabel = (UILabel *)[_weatherScrollview viewWithTag:102];
    UILabel *flLabel = (UILabel *)[_weatherScrollview viewWithTag:103];
    UILabel *humLabel = (UILabel *)[_weatherScrollview viewWithTag:104];
    UILabel *tmpLabel = (UILabel *)[_weatherScrollview viewWithTag:105];
    UILabel *presLabel = (UILabel *)[_weatherScrollview viewWithTag:106];
    UILabel *visLabel = (UILabel *)[_weatherScrollview viewWithTag:107];
    UILabel *pm25Label = (UILabel *)[_weatherScrollview viewWithTag:99];
    UILabel *windLabel = (UILabel *)[_weatherScrollview viewWithTag:109];

    [condImg sd_setImageWithURL:[NSURL URLWithString:condModel.icon]];
    condTxtLabel.text = condModel.txt;
    updateLabel.text = [Utility getDateStringWithTimeString:nowModel.updateLoc];
    flLabel.text = [NSString stringWithFormat:@"体感温度：%@℃",nowModel.fl];
    humLabel.text = [NSString stringWithFormat:@"湿度：%@％",nowModel.hum];
    tmpLabel.text = [NSString stringWithFormat:@"气温：%@℃",nowModel.tmp];
    presLabel.text = [NSString stringWithFormat:@"大气压：%@Pa",nowModel.pres];
    visLabel.text = [NSString stringWithFormat:@"能见度：%@Km",nowModel.vis];
    if (aqiModel.aqi!=nil) {
        pm25Label.text = [NSString stringWithFormat:@"AQI：%@\n%@",aqiModel.aqi,aqiModel.qlty];
    }
    windLabel.text = [NSString stringWithFormat:@"%@\n%@级",nowModel.dir,nowModel.sc];
    
//    NSArray *hourlyArray = [[JFDataSaveManager shareJFDataSaveManager] getAllHourlyForecastWithId:self.cityId];
 
    NSArray *dailyWeatherArray = [[JFDataSaveManager shareJFDataSaveManager] getAllDailyForecastWithId:self.cityId];

    for (int i=0; i<7; i++) {
        ForecastView *view = (ForecastView *)[_weatherScrollview viewWithTag:i+200];
        [view realodDataWithDaliyModel:dailyWeatherArray[i]];
    }
    
    NSArray *suggestions = [[JFDataSaveManager shareJFDataSaveManager] getAllSugesstionWithId:self.cityId];
    for ( int i=0; i<7; i++) {
        SuggestionView *view = (SuggestionView *)[_weatherScrollview viewWithTag:300+i];
        [view reloadDataWithSuggestion:suggestions[i]];
    }
}


- (void)requestData {
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [_weatherScrollview.mj_header endRefreshing];
    }
    NSArray *mycityArray = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities];
    CityModel *model = mycityArray[self.dataIndex];
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(model)weakModel = model;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[model.cityId,weatherKey] forKeys:@[@"cityid",@"key"]];
    [JFHttpRequestManager getDataWithURL:apiCityURL param:dic requestType:@"cityWeather" successed:^(NSString *type, NSDictionary *response) {
        [_weatherScrollview.mj_header endRefreshing];
//        JFLog(self, response);
        NSDictionary *resultDic = [response[@"HeWeather data service 3.0"] firstObject];
        if ([resultDic[@"status"] isEqualToString:@"ok"]) {
            NSDictionary *aqiDic = resultDic[@"aqi"];
            NSArray *dailyForecastes = resultDic[@"daily_forecast"];
            NSArray *hourlyForecastes = resultDic[@"hourly_forecast"];
            NSDictionary *nowDic = resultDic[@"now"];
            NSDictionary *suggestion = resultDic[@"suggestion"];
            
            //aqi
            NSDictionary *aqiCityDic = aqiDic[@"city"];
            AQI *aqi = [[AQI alloc] init];
            [aqi setValuesForKeysWithDictionary:aqiCityDic];
            aqi.cityId = model.cityId;
            [[JFDataSaveManager shareJFDataSaveManager] addAqi:aqi];
            
            //daily
            [[JFDataSaveManager shareJFDataSaveManager] removeAllDailyForecastWithId:model.cityId];
            for (NSDictionary *dic in dailyForecastes) {
                DailyForecast *dailyForecast = [[DailyForecast alloc] init];
                dailyForecast.sr = dic[@"astro"][@"sr"];
                dailyForecast.ss = dic[@"astro"][@"ss"];
                dailyForecast.code_d = dic[@"cond"][@"code_d"];
                dailyForecast.code_n = dic[@"cond"][@"code_n"];
                dailyForecast.txt_d = dic[@"cond"][@"txt_d"];
                dailyForecast.txt_n = dic[@"cond"][@"txt_n"];
                dailyForecast.date = dic[@"date"];
                dailyForecast.hum = dic[@"hum"];
                dailyForecast.pcpn = dic[@"pcpn"];
                dailyForecast.pop = dic[@"pop"];
                dailyForecast.pres = dic[@"pres"];
                dailyForecast.max = dic[@"tmp"][@"max"];
                dailyForecast.min = dic[@"tmp"][@"min"];
                dailyForecast.vis = dic[@"vis"];
                dailyForecast.deg = dic[@"wind"][@"deg"];
                dailyForecast.dir = dic[@"wind"][@"dir"];
                dailyForecast.sc = dic[@"wind"][@"sc"];
                dailyForecast.spd = dic[@"wind"][@"spd"];
                dailyForecast.cityId = weakModel.cityId;
                [[JFDataSaveManager shareJFDataSaveManager] addDailyForecast:dailyForecast];
            }
            
            //hourly
            [[JFDataSaveManager shareJFDataSaveManager] removeAllHourlyForecastWithId:model.cityId];
            for (NSDictionary *dic in hourlyForecastes) {
                HourlyForecast *hourlyForecast = [[HourlyForecast alloc] init];
                hourlyForecast.cityId = weakModel.cityId;
                hourlyForecast.date = dic[@"date"];
                hourlyForecast.hum = dic[@"hum"];
                hourlyForecast.pop = dic[@"pop"];
                hourlyForecast.pres = dic[@"pres"];
                hourlyForecast.tmp = dic[@"tmp"];
                hourlyForecast.deg = dic[@"wind"][@"deg"];
                hourlyForecast.dir = dic[@"wind"][@"dir"];
                hourlyForecast.sc = dic[@"wind"][@"sc"];
                hourlyForecast.spd = dic[@"wind"][@"spd"];
                [[JFDataSaveManager shareJFDataSaveManager] addHourlyForecast:hourlyForecast];
            }
            
            //now
            Now *now = [[Now alloc] init];
            now.code = nowDic[@"cond"][@"code"];
            now.txt = nowDic[@"cond"][@"txt"];
            now.fl = nowDic[@"fl"];
            now.hum = nowDic[@"hum"];
            now.pcpn = nowDic[@"pcpn"];
            now.pres = nowDic[@"pres"];
            now.tmp = nowDic[@"tmp"];
            now.vis = nowDic[@"vis"];
            now.deg = nowDic[@"wind"][@"deg"];
            now.dir = nowDic[@"wind"][@"dir"];
            now.sc = nowDic[@"wind"][@"sc"];
            now.spd = nowDic[@"wind"][@"spd"];
            now.cityId = weakModel.cityId;
            now.updateLoc = resultDic[@"basic"][@"update"][@"loc"];
            [[JFDataSaveManager shareJFDataSaveManager] addNow:now];
            
            //suggestion
            NSDictionary *comf = suggestion[@"comf"];
            Suggestion *comfS = [[Suggestion alloc] init];
            comfS.cityId = weakModel.cityId;
            comfS.title = @"舒适指数";
            comfS.brf = comf[@"brf"];
            comfS.txt = comf[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:comfS];
            
            NSDictionary *cw = suggestion[@"cw"];
            Suggestion *cwS = [[Suggestion alloc] init];
            cwS.cityId = weakModel.cityId;
            cwS.title = @"洗车指数";
            cwS.brf = cw[@"brf"];
            cwS.txt = cw[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:cwS];
            
            NSDictionary *drsg = suggestion[@"drsg"];
            Suggestion *drsgS = [[Suggestion alloc] init];
            drsgS.cityId = weakModel.cityId;
            drsgS.title = @"穿衣指数";
            drsgS.brf = drsg[@"brf"];
            drsgS.txt = drsg[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:drsgS];
            
            NSDictionary *flu = suggestion[@"flu"];
            Suggestion *fluS = [[Suggestion alloc] init];
            fluS.cityId = weakModel.cityId;
            fluS.title = @"感冒指数";
            fluS.brf = flu[@"brf"];
            fluS.txt = flu[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:fluS];
            
            NSDictionary *sport = suggestion[@"sport"];
            Suggestion *sportS = [[Suggestion alloc] init];
            sportS.cityId = weakModel.cityId;
            sportS.title = @"运动指数";
            sportS.brf = sport[@"brf"];
            sportS.txt = sport[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:sportS];
            
            NSDictionary *trav = suggestion[@"trav"];
            Suggestion *travS = [[Suggestion alloc] init];
            travS.cityId = weakModel.cityId;
            travS.title = @"旅游指数";
            travS.brf = trav[@"brf"];
            travS.txt = trav[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:travS];
            
            NSDictionary *uv = suggestion[@"uv"];
            Suggestion *uvS = [[Suggestion alloc] init];
            uvS.cityId = weakModel.cityId;
            uvS.title = @"紫外线指数";
            uvS.brf = uv[@"brf"];
            uvS.txt = uv[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:uvS];
            
            [weakSelf refreshWeaherView];
        }
        
    } failed:^(NSString *type, NSError *error) {
        JFLog(self, error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
