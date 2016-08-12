//
//  JFBaseViewController.m
//  JFWeather
//
//  Created by ramborange on 16/7/22.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFBaseViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSArray *dataArray;
    NSArray *filterData;
}
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;

@end

@implementation JFBaseViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:themeColor,NSFontAttributeName:[UIFont fontWithName:@"GillSans-Light" size:20]}];
    self.navigationItem.title = @"添加城市";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 24, 24);
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(back)];
    rightBtn.tintColor = themeColor;
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    dataArray = [[JFDataSaveManager shareJFDataSaveManager] getAllCities];
    
    if (!dataArray.count) {
        [SVProgressHUD showWithStatus:@"加载中"];
        [self performSelector:@selector(reloadTableview) withObject:nil afterDelay:5.0];
    }
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    _searchBar.placeholder = @"搜索想要添加的城市";
    _searchBar.showsScopeBar = YES;
    _searchBar.tintColor = themeColor;
//    [self.view addSubview:_searchBar];
    
    _searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplay.searchResultsDelegate = self;
    _searchDisplay.searchResultsDataSource = self;
    
    _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
//    _tableview.sectionIndexColor = themeColor;
    [self.view addSubview:_tableview];
    _tableview.tableHeaderView  =  _searchBar;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadTableview {
    [SVProgressHUD dismiss];
    dataArray = [[JFDataSaveManager shareJFDataSaveManager] getAllCities];
    [_tableview reloadData];
}


#pragma mark - UITableview Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tableview) {
        return [dataArray count];
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city contains %@",_searchDisplay.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[dataArray filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
}

//索引
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if (tableView == _tableview) {
//        return souyinArray;
//    }
//    return nil;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    NSLog(@"%@  %ld",title,index);
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
//     atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    return index;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    CityModel *cityModel;
    if (tableView==_tableview) {
        cityModel = dataArray[indexPath.row];
    }else {
        cityModel = filterData[indexPath.row];
    }
    cell.textLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20];
    cell.detailTextLabel.font = [UIFont fontWithName:@"GillSans-Light" size:13];
    
    cell.textLabel.text  = cityModel.city;
    cell.detailTextLabel.text = cityModel.prov;
    if (!cityModel.isAdd.boolValue) {
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.textLabel.textColor = themeColor;
        cell.detailTextLabel.textColor = themeColor;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityModel *cityModel;
    if (tableView == _tableview) {
        cityModel = dataArray[indexPath.row];
    }else {
        cityModel = filterData[indexPath.row];
    }
    
    if (!cityModel.isAdd.boolValue) {
        NSInteger totalNum = [[[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities] count];
        CityModel *modifyModel = [[JFDataSaveManager shareJFDataSaveManager] getCityWithId:cityModel.cityId];
        modifyModel.isAdd = @(YES);
        modifyModel.listIndex = @(totalNum);
        [[JFDataSaveManager shareJFDataSaveManager] saveUpdate];
    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = themeColor;
        cell.detailTextLabel.textColor = themeColor;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //
    JFLog(self.class, @"didReceiveMemoryWarning");
}


@end
