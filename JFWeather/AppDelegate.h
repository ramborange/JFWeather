//
//  AppDelegate.h
//  JFWeather
//
//  Created by ramborange on 16/7/22.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFHomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) JFHomeViewController *rootViewController;

@end

