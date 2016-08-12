//
//  CityManagerViewController.m
//  JFWeather
//
//  Created by ramborange on 16/8/10.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "CityManagerViewController.h"

@interface CityManagerViewController ()

@end

@implementation CityManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:themeColor,NSFontAttributeName:[UIFont fontWithName:@"GillSans-Light" size:20]}];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"城市管理";
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = themeColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 24, 24);
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    // Configure the cell...
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    
    CityModel *model = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities][indexPath.row];
    cell.textLabel.text = model.city;
    cell.detailTextLabel.text = model.prov;
    cell.textLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20];
    cell.detailTextLabel.font = [UIFont fontWithName:@"GillSans-Light" size:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        CityModel *model = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities][indexPath.row];
        model.isAdd = @(NO);
        [[JFDataSaveManager shareJFDataSaveManager] saveUpdate];
        
        NSArray *allMyCities = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities];
       [allMyCities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           if (obj!=nil) {
               CityModel *model = (CityModel *)obj;
               model.listIndex = @(idx);
               [[JFDataSaveManager shareJFDataSaveManager] saveUpdate];
           }
       }];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSArray *myCities = [[JFDataSaveManager shareJFDataSaveManager] getMyAddedCities];
    [myCities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CityModel *model = (CityModel *)obj;
        if (model!=nil) {
            if (destinationIndexPath.row>sourceIndexPath.row) {
                if (idx>=sourceIndexPath.row&&idx<=destinationIndexPath.row) {
                    if (idx==sourceIndexPath.row) {
                        model.listIndex = @(destinationIndexPath.row);
                        [[JFDataSaveManager shareJFDataSaveManager] saveUpdate];
                    }else {
                        model.listIndex = @(model.listIndex.integerValue-1);
                        [[JFDataSaveManager shareJFDataSaveManager] saveUpdate];
                    }
                }
            }else if (destinationIndexPath.row<sourceIndexPath.row) {
                if (idx>=destinationIndexPath.row&&idx<=sourceIndexPath.row) {
                    if (idx==sourceIndexPath.row) {
                        model.listIndex = @(destinationIndexPath.row);
                        [[JFDataSaveManager shareJFDataSaveManager] saveUpdate];
                    }else {
                        model.listIndex = @(model.listIndex.integerValue+1);
                        [[JFDataSaveManager shareJFDataSaveManager] saveUpdate];
                    }
                }
            }
        }
        
    }];
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
