//
//  CityWeatherModel.m
//  晴天
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "CityWeatherModel.h"
#import "CityCell.h"
#import "WeatherForecastModel.h"

@implementation CityWeatherModel

//初始化时创建一个dailyForecast 否则会为空
- (instancetype)init {
    NSMutableArray *dailyForecast = [[NSMutableArray array] init];
    self.dailyForecast = dailyForecast;
    NSMutableArray *hourlyForecast = [[NSMutableArray array] init];
    self.hourlyForecast = hourlyForecast;
    return self;
}
- (void)setLoc:(NSString *)loc {
    NSString *locTime = [loc substringFromIndex:11]; //从"2016-08-05 12:34"截取"12:34";
    _loc = [NSString stringWithFormat:@"发布于%@", locTime];
}

-(void)setTmp:(NSString *)tmp {
    _tmp = [NSString stringWithFormat:@"%@°", tmp]; //加摄氏度"°"符号
}


-(void)setHum:(NSString *)hum {
    _hum = [NSString stringWithFormat:@"湿度 %@%@", hum, @"%"]; //加"湿度 %"
}

- (void)setTxt:(NSString *)txt_unicode {
    _txt = [self replaceUnicode:txt_unicode];
}

//Unicode转中文
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

@end

