//
//  JFHomeViewController.m
//  JFWeather
//
//  Created by ramborange on 16/8/1.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "JFHomeViewController.h"
#import "JFBaseViewController.h"
#import "JFDetailViewController.h"
#import "CityManagerViewController.h"
#import "WeatherViewCell.h"
#import "UIButton+LXMImagePosition.h"
@interface JFHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentIndex;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *cityTableview;

@end

@implementation JFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCity)];
    leftItem.tintColor = themeColor;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 24, 24);
    [btn addTarget:self action:@selector(managerMyCities) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"manager"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    rightItem.tintColor = themeColor;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *navTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navTitleBtn.frame = CGRectMake(0, 0, screenWidth-160, 44);
    [navTitleBtn setTitleColor:themeColor forState:UIControlStateNormal];
    navTitleBtn.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20];
    navTitleBtn.tag = 987;
    [navTitleBtn setImage:[UIImage imageNamed:@"more_down"] forState:UIControlStateSelected];
    [navTitleBtn addTarget:self action:@selector(quickSelectCity:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = navTitleBtn;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[WeatherViewCell class] forCellWithReuseIdentifier:@"collectionviewcellId"];

    UIControl *dismissControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    dismissControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    dismissControl.tag = 988;
    dismissControl.alpha = 0.0;
    [dismissControl addTarget:self action:@selector(hideCitySelectView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissControl];

    _cityTableview = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth/2-80, -300, 160, 300) style:UITableViewStylePlain];
    _cityTableview.showsVerticalScrollIndicator = NO;
    [_cityTableview.layer setBorderColor:RGBA(232, 232, 232, 1).CGColor];
    [_cityTableview.layer setBorderWidth:1.0];
    _cityTableview.delegate = self;
    _cityTableview.dataSource = self;
    [self.view addSubview:_cityTableview];
   
    
    
    NSArray *myAddedCity = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities];
    if (!myAddedCity.count) {
        [SVProgressHUD showInfoWithStatus:@"请先添加城市"];
    }else {
        CityModel *model = [myAddedCity firstObject];
       [navTitleBtn setTitle:model.city forState:UIControlStateNormal];
        [navTitleBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [navTitleBtn setImagePosition:LXMImagePositionRight spacing:10.0];

        [self performSelector:@selector(initFirstCellData) withObject:nil afterDelay:1.0];
    }

}

- (void)initCellData {
    NSArray *cities = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities];
    if (cities.count) {
        for (CityModel *model in cities) {
            [self requestDataWithCityId:model.cityId];
        }
    }else {
        UIButton *navtitleBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:987];
        [navtitleBtn setTitle:@"" forState:UIControlStateNormal];
        [navtitleBtn setImage:nil forState:UIControlStateNormal];
    }
    
}

- (void)requestDataWithCityId:(NSString *)cityId {
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[cityId,weatherKey] forKeys:@[@"cityid",@"key"]];
    [JFHttpRequestManager getDataWithURL:apiCityURL param:dic requestType:@"cityWeather" successed:^(NSString *type, NSDictionary *response) {
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
            aqi.cityId = cityId;
            [[JFDataSaveManager shareJFDataSaveManager] addAqi:aqi];
            
            //daily
            [[JFDataSaveManager shareJFDataSaveManager] removeAllDailyForecastWithId:cityId];
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
                dailyForecast.cityId = cityId;
                [[JFDataSaveManager shareJFDataSaveManager] addDailyForecast:dailyForecast];
            }
            
            //hourly
            [[JFDataSaveManager shareJFDataSaveManager] removeAllHourlyForecastWithId:cityId];
            for (NSDictionary *dic in hourlyForecastes) {
                HourlyForecast *hourlyForecast = [[HourlyForecast alloc] init];
                hourlyForecast.cityId = cityId;
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
            now.cityId = cityId;
            now.updateLoc = resultDic[@"basic"][@"update"][@"loc"];
            [[JFDataSaveManager shareJFDataSaveManager] addNow:now];
            
            //suggestion
            NSDictionary *comf = suggestion[@"comf"];
            Suggestion *comfS = [[Suggestion alloc] init];
            comfS.cityId = cityId;
            comfS.title = @"舒适指数";
            comfS.brf = comf[@"brf"];
            comfS.txt = comf[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:comfS];
            
            NSDictionary *cw = suggestion[@"cw"];
            Suggestion *cwS = [[Suggestion alloc] init];
            cwS.cityId = cityId;
            cwS.title = @"洗车指数";
            cwS.brf = cw[@"brf"];
            cwS.txt = cw[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:cwS];
            
            NSDictionary *drsg = suggestion[@"drsg"];
            Suggestion *drsgS = [[Suggestion alloc] init];
            drsgS.cityId = cityId;
            drsgS.title = @"穿衣指数";
            drsgS.brf = drsg[@"brf"];
            drsgS.txt = drsg[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:drsgS];
            
            NSDictionary *flu = suggestion[@"flu"];
            Suggestion *fluS = [[Suggestion alloc] init];
            fluS.cityId = cityId;
            fluS.title = @"感冒指数";
            fluS.brf = flu[@"brf"];
            fluS.txt = flu[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:fluS];
            
            NSDictionary *sport = suggestion[@"sport"];
            Suggestion *sportS = [[Suggestion alloc] init];
            sportS.cityId = cityId;
            sportS.title = @"运动指数";
            sportS.brf = sport[@"brf"];
            sportS.txt = sport[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:sportS];
            
            NSDictionary *trav = suggestion[@"trav"];
            Suggestion *travS = [[Suggestion alloc] init];
            travS.cityId = cityId;
            travS.title = @"旅游指数";
            travS.brf = trav[@"brf"];
            travS.txt = trav[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:travS];
            
            NSDictionary *uv = suggestion[@"uv"];
            Suggestion *uvS = [[Suggestion alloc] init];
            uvS.cityId = cityId;
            uvS.title = @"紫外线指数";
            uvS.brf = uv[@"brf"];
            uvS.txt = uv[@"txt"];
            [[JFDataSaveManager shareJFDataSaveManager] addSuggestion:uvS];
        }
        [_collectionView reloadData];
    } failed:^(NSString *type, NSError *error) {
        JFLog(self, error);
    }];
}

- (void)initFirstCellData {
    WeatherViewCell *cell = [[_collectionView visibleCells] firstObject];
    [cell.weatherScrollview.mj_header beginRefreshing];
}

#pragma mark - UITableview Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell== nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"Gillsans-Light" size:17];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Gillsans-Light" size:14];
    CityModel *model = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities][indexPath.row];
    cell.textLabel.text = model.city;
    cell.detailTextLabel.text = model.prov;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    CityModel *model = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities][indexPath.row];
    UIButton *navtitleBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:987];
    [navtitleBtn setTitle:model.city forState:UIControlStateNormal];
    [navtitleBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [navtitleBtn setImagePosition:LXMImagePositionRight spacing:10.0];
    
    [self hideCitySelectView];
}

- (void)quickSelectCity:(UIButton *)btn {
    if (![[[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities] count]) {
        return;
    }
    if (!btn.isSelected) {
        [self showCitySelectView];
        [btn setSelected:YES];
    }else {
        [self hideCitySelectView];
        [btn setSelected:NO];
    }
}

- (void)showCitySelectView {
    UIControl *dismissControl = (UIControl *)[self.view viewWithTag:988];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _cityTableview.frame = CGRectMake(screenWidth/2-80, 6, 160, 300);
        dismissControl.alpha = 1.0;
    } completion:nil];
}

- (void)hideCitySelectView {
    UIButton *navtitleBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:987];
    [navtitleBtn setSelected:NO];
    UIControl *dismissControl = (UIControl *)[self.view viewWithTag:988];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _cityTableview.frame = CGRectMake(screenWidth/2-80, -300, 160, 300);
        dismissControl.alpha = 0.0;
    } completion:nil];
}

- (void)addCity {
    JFBaseViewController *vc = [[JFBaseViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)managerMyCities {
    CityManagerViewController *vc = [[CityManagerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];

}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities] count];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(screenWidth, screenHeight-64);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeatherViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionviewcellId" forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    [cell refreshWeaherView];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_collectionView reloadData];
    [_cityTableview reloadData];
    
    [self performSelector:@selector(initCellData) withObject:nil afterDelay:0.0];
    
    UIButton *navtitleBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:987];
    if (navtitleBtn.titleLabel.text==nil) {
        NSArray *myAddedCity = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities];
        if (myAddedCity.count) {
            CityModel *model = [myAddedCity firstObject];
            [navtitleBtn setTitle:model.city forState:UIControlStateNormal];
            [navtitleBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
            [navtitleBtn setImagePosition:LXMImagePositionRight spacing:10.0];
        }
    }else {
        NSArray *myAddedCity = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities];
        if (myAddedCity.count) {
            CityModel *model = myAddedCity[currentIndex];
            [navtitleBtn setTitle:model.city forState:UIControlStateNormal];
            [navtitleBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
            [navtitleBtn setImagePosition:LXMImagePositionRight spacing:10.0];
        }
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger idx = scrollView.contentOffset.x/screenWidth;
    currentIndex = idx;
    NSArray *mycityArray = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities];
    CityModel *model = mycityArray[idx];
//    self.navigationItem.title = model.city;
    UIButton *navtitleBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:987];
    [navtitleBtn setTitle:model.city forState:UIControlStateNormal];
    [navtitleBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [navtitleBtn setImagePosition:LXMImagePositionRight spacing:10.0];
}

-(void)dealloc {
    [_collectionView removeFromSuperview];
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    _collectionView = nil;
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
