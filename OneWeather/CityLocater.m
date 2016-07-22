//
//  CityLocater.m
//  OneWeather
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "CityLocater.h"
#import <CoreLocation/CoreLocation.h>

@interface CityLocater ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;

@end


@implementation CityLocater

- (void)startLocation {
    if ([self.delegate respondsToSelector:@selector(locatingIndicator:)]) {
        [self.delegate locatingIndicator:YES];//开启定位菊花
    }
    if([CLLocationManager locationServicesEnabled]) {
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            //提示用户无法进行定位操作
            if ([self.delegate respondsToSelector:@selector(positionLocater:failToLocationWithError:)]) {
                self.isSuccess = NO;
                [self.delegate positionLocater:self failToLocationWithError:@"您没有开启定位功能"];
            }
            return;
        }
        
        self.locationManager = [[CLLocationManager alloc] init];
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 100.0f;
        [self.locationManager startUpdatingLocation];
        
    }else {
        
        //提示用户无法进行定位操作
        if ([self.delegate respondsToSelector:@selector(positionLocater:failToLocationWithError:)]) {
            self.isSuccess = NO;
            [self.delegate positionLocater:self failToLocationWithError:@"您没有开启定位功能"];
        }
    }
    if ([self.delegate respondsToSelector:@selector(locatingIndicator:)]) {
        [self.delegate locatingIndicator:NO];//关闭定位菊花
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    
    __weak CityLocater *mySelf = self;
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            NSString *city = placemark.locality;
            if (!city) {
                city = placemark.administrativeArea;
            }
            if (city) {
                if (mySelf.delegate) {
                    if ([mySelf.delegate respondsToSelector:@selector(positionLocater:didFinishedLocateWithCity:)]) {
                        [mySelf.delegate positionLocater:self didFinishedLocateWithCity:city];
                    }
                }
            } else {
                if ([mySelf.delegate respondsToSelector:@selector(positionLocater:failToLocationWithError:)]) {
                    [mySelf.delegate positionLocater:self failToLocationWithError:@""];
                }
            }
            
            
            
        }
    }];
    
    [_locationManager stopUpdatingLocation];
    
}
- (void)dealloc {
    self.locationManager = nil;
    self.delegate = nil;
}

@end
