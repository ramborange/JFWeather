//
//  JFWeatherHeader.h
//  JFWeather
//
//  Created by ramborange on 16/7/22.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#ifndef JFWeatherHeader_h
#define JFWeatherHeader_h

//weather key
//天气API appKey
#define weatherKey          @"2a678202baf646758822ff282350d139"
//weather.com
#define weatherKey2         @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
//聚合数据天气API
#define juHeWeather         @"http://op.juhe.cn/onebox/weather/query"


//search
//城市列表类型	国内城市：allchina
#define chinaCity           @"allchina"
//热门城市：hotworld
#define hotCity             @"hotworld"
//全部城市：allworld
#define allCity             @"allworld"

//search
//景点列表类型	国内全部景点
#define allattractions      @"allattractions"

//url
//城市天气
#define apiCityURL          @"https://api.heweather.com/x3/weather"
//景点天气
#define apiAttractionURL    @"https://api.heweather.com/x3/attractions"
//城市或景点列表接口
#define cityList            @"https://api.heweather.com/x3/citylist"
//天气代码列表接口
#define condition           @"https://api.heweather.com/x3/condition"

#define themeColor      [UIColor colorWithRed:62/255.0 green:127/255.0 blue:172/255.0 alpha:1]

#define screenWidth     [UIScreen mainScreen].bounds.size.width
#define screenHeight    [UIScreen mainScreen].bounds.size.height

#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define JFLog(class,content)   NSLog(@"class:%@ content:%@",class,content)

#endif /* JFWeatherHeader_h */
