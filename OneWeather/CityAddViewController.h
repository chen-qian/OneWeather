//
//  CityAddViewController.h
//  OneWeather
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CityAddViewControllerDelegate <NSObject>

- (void)addCity:(NSString *)cityName;

@end


@interface CityAddViewController : UIViewController

@property (nonatomic, weak) id<CityAddViewControllerDelegate>delegate;

@end
