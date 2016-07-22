//
//  CityWeatherModel.h
//  晴天
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityCell.h"

@interface CityWeatherModel : NSObject

//发布时间
@property (nonatomic, copy) NSString *loc;
//城市名称
@property (nonatomic, copy) NSString *cityName;
//天气图标
@property (nonatomic, copy) NSString *icon;
//当前天气
@property (nonatomic, copy) NSString *txt;
//当前温度
@property (nonatomic, copy) NSString *tmp;
//当前湿度
@property (nonatomic, copy) NSString *hum;
//风向
@property (nonatomic, copy) NSString *dir;
//风力
@property (nonatomic, copy) NSString *sc;
//pm2.5
@property (nonatomic, copy) NSString *pm25;
//空气质量情况
@property (nonatomic, copy) NSString *qlty;

//未来几天
@property (nonatomic, strong) NSMutableArray *dailyForecast;
//未来几小时
@property (nonatomic, strong) NSMutableArray *hourlyForecast;

@end
