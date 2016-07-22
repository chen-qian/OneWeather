//
//  WeatherForecastModel.h
//  晴天
//
//  Created by mac on 16/6/9.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherForecastModel : NSObject

/** for dailyForecast */
//日期
@property (nonatomic, copy) NSString *date;
//天气
@property (nonatomic, copy) NSString *txt;
//天气图标
@property (nonatomic, copy) NSString *code;
//最高温度
@property (nonatomic, copy) NSString *max;
//最低温度
@property (nonatomic, copy) NSString *min;
//日间天气
@property (nonatomic, copy) NSString *txt_d;
//夜间天气
@property (nonatomic, copy) NSString *txt_n;
//日出时间
@property (nonatomic, copy) NSString *sunrise;
//日落时间
@property (nonatomic, copy) NSString *sunset;
//降雨概率
@property (nonatomic, copy) NSString *pop;
//风向
@property (nonatomic, copy) NSString *dir;
//风力
@property (nonatomic, copy) NSString *sc;

/** for hourlyForecast */
//小时
@property (nonatomic, copy) NSString *hour;
//温度
@property (nonatomic, copy) NSString *tmp;

@end
