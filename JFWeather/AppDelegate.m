//
//  AppDelegate.m
//  JFWeather
//
//  Created by ramborange on 16/7/22.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.rootViewController = [[JFHomeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = nav;
    
    [self checkInitcofig];
    
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [SVProgressHUD showInfoWithStatus:@"无网络连接"];
        }else if (status == AFNetworkReachabilityStatusUnknown){
        }else {
            [self checkInitcofig];
        }
    }];
    
    [self.window makeKeyAndVisible];
    
    sleep(1);
    return YES;
}

- (void)checkInitcofig {
    if ([Utility CheckIsFirstWithKey:@"condition"]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[@"allcond",weatherKey] forKeys:@[@"search",@"key"]];
        [JFHttpRequestManager getDataWithURL:condition param:dic requestType:@"condition" successed:^(NSString *type, NSDictionary *response) {
            //            NSLog(@"%@",response);
            if ([response[@"status"] isEqualToString:@"ok"]) {
                NSArray *condArray = response[@"cond_info"];
                for (NSDictionary *dic in condArray) {
                    Condition *cond = [[Condition alloc] init];
                    [cond setValuesForKeysWithDictionary:dic];
                    JFDataSaveManager *saveManager = [JFDataSaveManager shareJFDataSaveManager];
                    [saveManager addConditon:cond];
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"condition"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        } failed:^(NSString *type, NSError *error) {
            JFLog(self, error);
        }];
    }
    
    if ([Utility CheckIsFirstWithKey:@"cityList"]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[@"allchina",weatherKey] forKeys:@[@"search",@"key"]];
        [JFHttpRequestManager getDataWithURL:cityList param:dic requestType:@"cityList" successed:^(NSString *type, NSDictionary *response) {
            //            NSLog(@"%@",response);
            if ([response[@"status"] isEqualToString:@"ok"]) {
                NSArray *citiesArray = response[@"city_info"];
                for (NSDictionary *dic in citiesArray) {
                    City *city = [[City alloc] init];
                    [city setValuesForKeysWithDictionary:dic];
                    JFDataSaveManager *manager = [JFDataSaveManager shareJFDataSaveManager];
                    [manager addCity:city];
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"cityList"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        } failed:^(NSString *type, NSError *error) {
            JFLog(self, error);
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
