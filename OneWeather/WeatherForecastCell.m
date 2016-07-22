//
//  WeatherForecastCell.m
//  晴天
//
//  Created by mac on 16/6/9.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "WeatherForecastCell.h"
#import "WeatherForecastModel.h"

@interface WeatherForecastCell ()


@end

@implementation WeatherForecastCell

- (void)awakeFromNib {
    
}

- (void)setForecastModel:(WeatherForecastModel *)forecastModel {
    _forecastModel = forecastModel;
    
    self.date.text = forecastModel.date;
    //拼接36x36图标名
    NSString *imageName36 = [NSString stringWithFormat:@"%@-36", forecastModel.code];
    
    self.icon.image = [UIImage imageNamed:imageName36];
    
    self.tmp.text = [NSString stringWithFormat:@"%@°/%@°", forecastModel.min, forecastModel.max];
    
    self.txt_d.text = [NSString stringWithFormat:@"日 %@", forecastModel.txt_d];
    
    self.txt_n.text = [NSString stringWithFormat:@"夜 %@", forecastModel.txt_n];
    
    self.sunrise.text = forecastModel.sunrise;
    
    self.sunset.text = forecastModel.sunset;
    
    self.pop.text = forecastModel.pop;
    if ([forecastModel.sc isEqualToString:@"微风"]) {
        self.dir_sc.text = [NSString stringWithFormat:@"%@ %@", forecastModel.dir, forecastModel.sc];
    } else {
        self.dir_sc.text = [NSString stringWithFormat:@"%@%@级", forecastModel.dir, forecastModel.sc];
    }
}


@end
