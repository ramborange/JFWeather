//
//  WeatherViewCell.h
//  JFWeather
//
//  Created by ramborange on 16/8/11.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForecastView.h"
#import "SuggestionView.h"
@interface WeatherViewCell : UICollectionViewCell
@property (nonatomic, strong) UIScrollView *weatherScrollview;

@property (nonatomic, strong) UIImageView *condImg;
@property (nonatomic, strong) UILabel *pm25Label;
@property (nonatomic, strong) UILabel *condTxtLabel;
@property (nonatomic, strong) UILabel *updateLabel;
@property (nonatomic, strong) UILabel *flLabel;
@property (nonatomic, strong) UILabel *humLabel;
@property (nonatomic, strong) UILabel *tmpLabel;
@property (nonatomic, strong) UILabel *presLabel;
@property (nonatomic, strong) UILabel *visLabel;
@property (nonatomic, strong) UILabel *windLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)requestData;
- (void)refreshWeaherView;
@end
