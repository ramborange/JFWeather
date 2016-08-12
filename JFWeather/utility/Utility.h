//
//  Utility.h
//  JFWeather
//
//  Created by ramborange on 16/7/27.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (BOOL)CheckIsFirstWithKey:(NSString *)key;

+ (UILabel *)GetLabelWithFrame:(CGRect)rect text:(NSString *)text font:(UIFont *)font textAlig:(NSInteger)textAligment textColor:(UIColor *)textColor;

+ (UIButton *)GetButtonWithFrame:(CGRect)rect text:(NSString *)text font:(UIFont *)font bgImg:(UIImage *)img bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor;

+ (NSString *)getDateStringWithTimeString:(NSString *)dateString;

+ (Utility *)shareUtility;
+ (NSDateFormatter *)shareDateFormatter;
@end
