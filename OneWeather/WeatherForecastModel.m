//
//  WeatherForecastModel.m
//  晴天
//
//  Created by mac on 16/6/9.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "WeatherForecastModel.h"

@implementation WeatherForecastModel

- (void)setDate:(NSString *)dateStr {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate * date = [dateFormatter dateFromString:dateStr];
    _date = [self calculateWeek:date];    
}

- (void)setHour:(NSString *)hour {
    //取时间整点
    _hour = [hour substringWithRange:NSMakeRange(11, 2)];
}
- (void)setTxt_d:(NSString *)txt_unicode {
    _txt_d = [self replaceUnicode:txt_unicode];
}
- (void)setTxt_n:(NSString *)txt_unicode {
    _txt_n = [self replaceUnicode:txt_unicode];
}
//日期转星期几
- (NSString *)calculateWeek:(NSDate *)date {
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSWeekdayCalendarUnit fromDate:date] weekday];
//    NSLog(@"week : %zd",week);
    switch (week) {
        case 1:
        {
            return @"周日";
        }
        case 2:
        {
            return @"周一";
        }
        case 3:
        {
            return @"周二";
        }
        case 4:
        {
            return @"周三";
        }
        case 5:
        {
            return @"周四";
        }
        case 6:
        {
            return @"周五";
        }
        case 7:
        {
            return @"周六";
        }
    }
    
    return @"";
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
