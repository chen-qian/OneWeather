
//
//  CityCell.m
//  晴天
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "CityCell.h"
#import "CityWeatherModel.h"

@interface CityCell ()

@end

@implementation CityCell

- (void)awakeFromNib {
    
}
- (void)setCityName:(NSString *)cityName {
    _cityName = cityName;
    
    _cityNameLabel.text = cityName;
}


@end
