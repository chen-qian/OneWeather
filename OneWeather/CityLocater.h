//
//  CityLocater.h
//  OneWeather
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CityLocater;

@protocol CityLocaterDelegate <NSObject>

@optional
- (void)positionLocater:(CityLocater *)locator didFinishedLocateWithCity:(NSString *)city;
- (void)positionLocater:(CityLocater *)locator failToLocationWithError:(NSString *)code;
- (void)locatingIndicator:(BOOL)status;
@end


@interface CityLocater : NSObject
//定位是否成功
@property (nonatomic) BOOL isSuccess;
@property (nonatomic, weak) id<CityLocaterDelegate>delegate;

- (void)startLocation;
@end
