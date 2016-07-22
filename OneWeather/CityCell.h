//
//  CityCell.h
//  晴天
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityWeatherModel;

@interface CityCell : UITableViewCell

@property (nonatomic, copy) NSString *cityName;

//城市名称
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@end
