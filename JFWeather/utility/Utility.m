//
//  Utility.m
//  JFWeather
//
//  Created by ramborange on 16/7/27.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "Utility.h"

@implementation Utility
+ (Utility *)shareUtility {
    static Utility *u = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        u = [[Utility alloc] init];
    });
    return u;
}

+ (NSDateFormatter *)shareDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    return dateFormatter;
}

+ (BOOL)CheckIsFirstWithKey:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id obj = [ud objectForKey:key];
    if (obj!=nil) {
        return NO;
    }
    return YES;
}

+ (UILabel *)GetLabelWithFrame:(CGRect)rect text:(NSString *)text font:(UIFont *)font textAlig:(NSInteger)textAligment textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    if (text!=nil) {
        label.text = text;
    }
    label.font = font;
    label.textAlignment = textAligment;
    label.textColor = textColor;
    label.numberOfLines = 0;
    return label;
}

+ (UIButton *)GetButtonWithFrame:(CGRect)rect text:(NSString *)text font:(UIFont *)font bgImg:(UIImage *)img bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    if (text!=nil) {
        [btn setTitle:text forState:UIControlStateNormal];
    }
    btn.titleLabel.font = font;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    if (img!=nil) {
        [btn setBackgroundImage:img forState:UIControlStateNormal];
    }
    if (bgColor!=nil) {
        [btn setBackgroundColor:bgColor];
    }
    return btn;
}

+ (NSString *)getDateStringWithTimeString:(NSString *)dateString{
    NSDateFormatter *formatter;
    if (! formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSString *sysDateString = [formatter stringFromDate:[NSDate date]];
    NSArray *dateArray1 = [dateString componentsSeparatedByString:@" "];
    NSArray *dateArray2 = [sysDateString componentsSeparatedByString:@" "];
    
    NSArray *date1 = [[dateArray1 firstObject] componentsSeparatedByString:@"-"];
    NSArray *date2 = [[dateArray2 firstObject] componentsSeparatedByString:@"-"];
    if (![[date1 firstObject] isEqualToString:[date2 firstObject]]) {
        return [NSString stringWithFormat:@"%@-%@ %@",date1[1],date1[2],dateArray1[1]];
    }else {
        if (![date2[1] isEqualToString:date1[1]]) {
            return [NSString stringWithFormat:@"%@-%@ %@",date1[1],date1[2],dateArray1[1]];
        }else {
            if ([date1[2] isEqualToString:date2[2]]) {
                return [NSString stringWithFormat:@"今天%@",dateArray1[1]];
            }else if ([date2[2] integerValue]-[date1[2] integerValue]==1) {
                return [NSString stringWithFormat:@"昨天%@",dateArray1[1]];
            }else if ([date2[2] integerValue]-[date1[2] integerValue]==2) {
                return [NSString stringWithFormat:@"前天%@",dateArray1[1]];
            }else {
                return [NSString stringWithFormat:@"%@-%@ %@",date1[1],date1[2],dateArray1[1]];
            }
        }
    }
}


@end
