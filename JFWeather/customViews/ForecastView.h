//
//  ForecastView.h
//  JFWeather
//
//  Created by ramborange on 16/8/2.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastView : UIView

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *srLabel;
@property (nonatomic, strong) UILabel *ssLabel;

@property (nonatomic, strong) UIImageView *codeDayImg;
@property (nonatomic, strong) UIImageView *codeNightImg;

@property (nonatomic, strong) UILabel *txtDayLabel;
@property (nonatomic, strong) UILabel *txtNightLabel;

@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *minLabel;

@property (nonatomic, strong) UILabel *weekdayLabel;
- (void)realodDataWithDaliyModel:(DailyForecastModel *)dailyModel;
@end
