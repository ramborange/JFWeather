//
//  ForecastView.m
//  JFWeather
//
//  Created by ramborange on 16/8/2.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "ForecastView.h"
#import "NSDate+Extension.h"
@implementation ForecastView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dateLabel = [Utility GetLabelWithFrame:CGRectMake(0, 5, frame.size.width/4, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:17] textAlig:1 textColor:[UIColor blackColor]];
        [self addSubview:_dateLabel];
        
        _weekdayLabel = [Utility GetLabelWithFrame:CGRectMake(0, 30, frame.size.width/4, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:1 textColor:[UIColor blackColor]];
        [self addSubview:_weekdayLabel];
        
        _codeDayImg = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/4, 5, 20, 20)];
        [self addSubview:_codeDayImg];
        
        _txtDayLabel = [Utility GetLabelWithFrame:CGRectMake(frame.size.width/4, 30, frame.size.width/4, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:0 textColor:themeColor];
        [self addSubview:_txtDayLabel];
        
        _maxLabel = [Utility GetLabelWithFrame:CGRectMake(frame.size.width/4+30, 5, frame.size.width/4-40, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:0 textColor:[UIColor orangeColor]];
        [self addSubview:_maxLabel];
        
        _codeNightImg = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2, 5, 20, 20)];
        [self addSubview:_codeNightImg];
        
        _txtNightLabel = [Utility GetLabelWithFrame:CGRectMake(frame.size.width/2, 30, frame.size.width/4, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:0 textColor:themeColor];
        [self addSubview:_txtNightLabel];
        
        _minLabel = [Utility GetLabelWithFrame:CGRectMake(frame.size.width/2+30, 5, frame.size.width/4-40, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:0 textColor:themeColor];
        [self addSubview:_minLabel];
        
        _srLabel = [Utility GetLabelWithFrame:CGRectMake(frame.size.width*3/4, 5, frame.size.width/4, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:0 textColor:[UIColor orangeColor]];
        [self addSubview:_srLabel];
        
        _ssLabel = [Utility GetLabelWithFrame:CGRectMake(frame.size.width*3/4, 30, frame.size.width/2, 20) text:nil font:[UIFont fontWithName:@"GillSans-Light" size:15] textAlig:0 textColor:themeColor];
        [self addSubview:_ssLabel];
    }
    [self.layer setBorderColor:RGBA(232, 232, 232, 1).CGColor];
    [self.layer setBorderWidth:1.0];
    [self.layer setShadowColor:RGBA(220, 220, 220, 1).CGColor];
    [self.layer setShadowRadius:1.0];
    [self.layer setShadowOpacity:1.0];
    [self.layer setShadowOffset:CGSizeMake(1, 1)];
    return self;
}

- (void)realodDataWithDaliyModel:(DailyForecastModel *)dailyModel {
    ConditionModel *condDay = [[JFDataSaveManager shareJFDataSaveManager] getConditonWithCode:[dailyModel.code_d integerValue]];
    ConditionModel *conNight = [[JFDataSaveManager shareJFDataSaveManager] getConditonWithCode:[dailyModel.code_n integerValue]];
    
    NSDate *date = [self getDateWithDateString:dailyModel.date];
    BOOL isToday = date.isToday;
    _dateLabel.text = isToday?@"今天":[NSString stringWithFormat:@"%@-%@",[dailyModel.date componentsSeparatedByString:@"-"][1],[dailyModel.date componentsSeparatedByString:@"-"][2]];
    _weekdayLabel.text = [date dayFromWeekday];
    [_codeDayImg sd_setImageWithURL:[NSURL URLWithString:condDay.icon]];
    [_codeNightImg sd_setImageWithURL:[NSURL URLWithString:conNight.icon]];
    _maxLabel.text = [NSString stringWithFormat:@"%@℃",dailyModel.max];
    _minLabel.text = [NSString stringWithFormat:@"%@℃",dailyModel.min];
    _txtDayLabel.text = condDay.txt;
    _txtNightLabel.text = conNight.txt;
    _srLabel.text = [NSString stringWithFormat:@"日出：%@",dailyModel.sr];
    _ssLabel.text = [NSString stringWithFormat:@"日落：%@",dailyModel.ss];
    
}

- (NSDate *)getDateWithDateString:(NSString *)dateString {
    NSDateFormatter *formatter = [Utility shareDateFormatter];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

@end
