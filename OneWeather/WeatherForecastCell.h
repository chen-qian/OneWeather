//
//  WeatherForecastCell.h
//  晴天
//
//  Created by mac on 16/6/9.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherForecastModel;

@interface WeatherForecastCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *tmp;

@property (weak, nonatomic) IBOutlet UILabel *txt_d;

@property (weak, nonatomic) IBOutlet UILabel *txt_n;

@property (weak, nonatomic) IBOutlet UILabel *sunrise;

@property (weak, nonatomic) IBOutlet UILabel *sunset;

@property (weak, nonatomic) IBOutlet UILabel *pop;

@property (weak, nonatomic) IBOutlet UILabel *dir_sc;

@property (nonatomic, strong) WeatherForecastModel *forecastModel;

@end
