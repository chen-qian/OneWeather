//
//  CityWeatherViewController.m
//  晴天
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "CityWeatherViewController.h"
#import "CityWeatherModel.h"
#import "WeatherForecastModel.h"
#import "WeatherForecastCell.h"
#import "MJRefresh.h"
#import <AFNetworking.h>
#import <AFNetworkReachabilityManager.h>

@interface CityWeatherViewController ()<UITableViewDataSource, UITableViewDelegate>

//CityListViewController传来的城市id
@property (nonatomic, copy) NSString *cityId;
//CityListViewController传来的城市名称
@property (nonatomic, copy) NSString *cityName;
//发布时间
@property (weak, nonatomic) IBOutlet UILabel *loc;
//天气图标图片
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
//当前天气
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
//当前温度
@property (weak, nonatomic) IBOutlet UILabel *tmpLabel;
//当前风力等级
@property (weak, nonatomic) IBOutlet UILabel *dir_scLabel;
//当前湿度
@property (weak, nonatomic) IBOutlet UILabel *humLabel;
//当前空气质量
@property (weak, nonatomic) IBOutlet UILabel *qltyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qltyImage;



@property (weak, nonatomic) IBOutlet UITableView *dailyForecastTableView;

@end

static NSString *identifier = @"forecastCell";
//最近打开的index
NSInteger currentClickIndex;

//是否打开cell
BOOL isOpenCell;

@implementation CityWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reachabilityCheck];
    currentClickIndex = -1;
    self.navigationItem.title = self.cityName;
//    self.codeImage.contentMode = UIViewContentModeScaleAspectFill
    
    //设置cityButton
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame = CGRectMake(0, 19, 30, 30);
    [cityButton setImage:[UIImage imageNamed:@"cityButton"] forState:UIControlStateNormal];
    [cityButton addTarget:self action:@selector(toCityList:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toCityListButton = [[UIBarButtonItem alloc] initWithCustomView:cityButton];
    self.navigationItem.leftBarButtonItem = toCityListButton;
    
    //设置aboutButton
    UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutButton.frame = CGRectMake(0, 19, 30, 30);
    [aboutButton setImage:[UIImage imageNamed:@"aboutButton"] forState:UIControlStateNormal];
    [aboutButton addTarget:self action:@selector(toAboutPage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toAboutButton = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
    self.navigationItem.rightBarButtonItem = toAboutButton;
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self requestWeatherInfo:self.cityId];
    }];
    // 设置文字
    header.lastUpdatedTimeLabel.text = @"上次刷新";
    [header setTitle:@"下拉刷新天气" forState:MJRefreshStateIdle];
    [header setTitle:@"松开更新天气" forState:MJRefreshStatePulling];
    [header setTitle:@"获取天气中..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightUltraLight];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightUltraLight];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    self.dailyForecastTableView.mj_header = header;
    
    //设置图片
    UIImage *um_close = [UIImage imageNamed:@"um_close"];
    UIImage *um_open = [UIImage imageNamed:@"um_open"];
    [header setImages:@[um_close] forState:MJRefreshStateIdle];
    [header setImages:@[um_open] forState:MJRefreshStatePulling];
    // 马上进入刷新状态
    [self.dailyForecastTableView.mj_header beginRefreshing];
}

////绘制小时预报图
//- (void)generateHourlyForecastView {
//    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120.0)];
//    NSArray *xLabelArray = @[@"3点",@"6点",@"9点",@"12点",@"15点",@"18点",@"21点"];
//    NSArray *yLabelArray = @[@"18°", @"21°", @"25°", @"27°", @"28°", @"24°", @"20°"];
//    
//    [lineChart setXLabels:xLabelArray];
//    
//    // Line Chart No.1
//    PNLineChartData *data01 = [PNLineChartData new];
//    data01.color = PNFreshGreen;
//    data01.itemCount = lineChart.xLabels.count;
//    data01.getData = ^(NSUInteger index) {
//        CGFloat yValue = [yLabelArray[index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
//    lineChart.chartData = @[data01];
//    [lineChart strokeChart];
//    [self.hourlyForecastView addSubview:lineChart];
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

//请求天气数据
- (void)requestWeatherInfo:(NSString *)cityId {
    
    NSString *httpUrl = @"https://api.heweather.com/x3/weather?cityid=CN";
    NSString *key =@"&key=411feb273ae249f086d2253d74df5ba7";
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@%@%@", httpUrl, cityId, key];
//    NSURL *url = [NSURL URLWithString: urlStr];
//    
//    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL: url
//                                                                  cachePolicy: NSURLRequestUseProtocolCachePolicy
//                                                              timeoutInterval: 10];
//    [urlRequest setHTTPMethod: @"GET"];
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    __block  NSString *result = @"";
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (!error) {
//            //没有错误，返回正确；
//            result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data
//                                                                       options:NSJSONReadingMutableLeaves
//                                                                         error:&error];
//            self.cityWeather = [self convertToModelwithJSON:weatherDic];
//            //更新UI
//            [self setWeatherToUI];
//            NSLog(@"%@", result);
//        }
//        else{
//            //出现错误；
//            NSLog(@"错误信息：%@",error);
//        }
//    }];
//    
//    [dataTask resume];
    

    //    从URL获取json数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        self.cityWeather = [self convertToModelwithJSON:responseObject];
        //更新UI
        [self setWeatherToUI];
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//将请求返回JSON结果转为weatherModel
- (CityWeatherModel *)convertToModelwithJSON:(NSDictionary *)result {
    
    CityWeatherModel *weatherModel = [[CityWeatherModel alloc] init];
    NSArray *a =[result objectForKey:@"HeWeather data service 3.0"];
    NSDictionary *zero =a[0];
    
    //空气质量
    NSDictionary *aqi =[zero objectForKey:@"aqi"];
    //基本信息
    NSDictionary *basic = [zero objectForKey:@"basic"];
    //实况天气
    NSDictionary *now =[zero objectForKey:@"now"];
    //未来几天天气预报
    NSArray *daily_forecast = [zero objectForKey:@"daily_forecast"];
    for (NSDictionary *day in daily_forecast) {
        NSDictionary *cond = [day objectForKey:@"cond"];
        NSDictionary *astro = [day objectForKey:@"astro"];
        NSDictionary *tmp = [day objectForKey:@"tmp"];
        NSString *date = [day objectForKey:@"date"];
        NSString *txt = [cond objectForKey:@"txt_d"];
        NSString *code = [cond objectForKey:@"code_d"];
        NSString *sunrise = [astro objectForKey:@"sr"];
        NSString *sunset = [astro objectForKey:@"ss"];
        NSString *pop = [day objectForKey:@"pop"];
        NSString *max = [tmp objectForKey:@"max"];
        NSString *min = [tmp objectForKey:@"min"];
        NSString *txt_d = [cond objectForKey:@"txt_d"];
        NSString *txt_n = [cond objectForKey:@"txt_n"];
        NSDictionary *wind = [day objectForKey:@"wind"];
        NSString *dir = [wind objectForKey:@"dir"];
        NSString *sc = [wind objectForKey:@"sc"];
        WeatherForecastModel *dailyForecast = [[WeatherForecastModel alloc] init];
        dailyForecast.date = date;
        dailyForecast.txt = txt;
        dailyForecast.code = code;
        dailyForecast.sunrise = sunrise;
        dailyForecast.sunset = sunset;
        dailyForecast.pop = [NSString stringWithFormat:@"%@%@", pop, @"%"];
        dailyForecast.max = max;
        dailyForecast.min = min;
        dailyForecast.txt_d = txt_d;
        dailyForecast.txt_n = txt_n;
        dailyForecast.dir = dir;
        dailyForecast.sc = sc;
        [weatherModel.dailyForecast addObject:dailyForecast];//要重写CityWeatherModel的init方法 初始化一个dailyForecast才行
    }
    //未来几小时天气预报
    NSArray *hourly_forecast = [zero objectForKey:@"hourly_forecast"];
    for (NSDictionary *hourly in hourly_forecast) {
        NSString *hour = [hourly objectForKey:@"date"];
        NSString *tmp = [hourly objectForKey:@"tmp"];
        WeatherForecastModel *hourlyForecast = [[WeatherForecastModel alloc] init];
        hourlyForecast.hour = hour;
        hourlyForecast.tmp = tmp;
        [weatherModel.hourlyForecast addObject:hourlyForecast];//要重写CityWeatherModel的init方法 初始化一个hourlyForecast才行
    }
    //城市名称
    NSString *city = [basic objectForKey:@"city"];
    //更新信息
    NSDictionary *update = [basic objectForKey:@"update"];
    //发布时间
    NSString *loc = [update objectForKey:@"loc"];
    
    //温度
    NSString *tmp = [now objectForKey:@"tmp"];
    //天气状况
    NSDictionary *cond = [now objectForKey:@"cond"];
    //风力状况
    NSDictionary *wind = [now objectForKey:@"wind"];
    //风向
    NSString *dir = [wind objectForKey:@"dir"];
    //风力
    NSString *sc = [wind objectForKey:@"sc"];
    //湿度
    NSString *hum = [now objectForKey:@"hum"];
    //天气
    NSString *txt_unicode = [cond objectForKey:@"txt"];
    //天气图标
    NSString *code = [cond objectForKey:@"code"];
    
    NSDictionary *cityaqi = [aqi objectForKey:@"city"];
    //pm2.5
    NSString *pm25 = [cityaqi objectForKey:@"pm25"];
    //空气质量情况
    NSString *qlty = [cityaqi objectForKey:@"qlty"];
    
    weatherModel.cityName = city;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm";
//    NSDate * lastUpdateTime = [dateFormatter dateFromString:loc];
    
    weatherModel.loc = loc;
    weatherModel.icon = code;
    weatherModel.tmp = tmp;
    weatherModel.dir = dir;
    weatherModel.sc = sc;
    weatherModel.hum = hum;
    weatherModel.txt = txt_unicode;
    weatherModel.pm25 = pm25;
    weatherModel.qlty = qlty;
    return weatherModel;
}

//daily组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//daily行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityWeather.dailyForecast.count;
}

//更新界面UI
- (void)setWeatherToUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.title = self.cityWeather.cityName;
        self.loc.text = self.cityWeather.loc;
        self.codeImage.image = [UIImage imageNamed:self.cityWeather.icon];
        self.txtLabel.text = self.cityWeather.txt;
        self.tmpLabel.text = self.cityWeather.tmp;
        if ([self.cityWeather.sc isEqualToString:@"微风"]) {
            self.dir_scLabel.text = [NSString stringWithFormat:@"%@ %@", self.cityWeather.dir, self.cityWeather.sc];
        } else {
            self.dir_scLabel.text = [NSString stringWithFormat:@"%@%@级", self.cityWeather.dir, self.cityWeather.sc];        }
        self.humLabel.text = self.cityWeather.hum;
        self.qltyLabel.text = [NSString stringWithFormat:@"空气质量 %@", self.cityWeather.qlty];
        if (self.cityWeather.qlty == nil) {//有的城市居然没有空气质量信息...
            [self.qltyImage removeFromSuperview];
            [self.qltyLabel removeFromSuperview];
            
        }
//        [self generateHourlyForecastView];
        [self.dailyForecastTableView reloadData];
        [self.dailyForecastTableView.mj_header endRefreshing];
    });
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == currentClickIndex) {
        if (isOpenCell == YES) {
            currentClickIndex = indexPath.row;
            return 180;
        }
        return 70;
    }else{
        return 70;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //计算展开的cell是否超出屏幕
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    CGFloat yOfCellBottom = rect.origin.y + 180;
    //以下if-else逻辑有待优化
    if (indexPath.row == currentClickIndex) {//如果点击相同cell,打开变关闭,关闭变打开
        isOpenCell = !isOpenCell;
        if (isOpenCell == YES) {//再次点开cell还是要算
            if (yOfCellBottom > [tableView superview].frame.size.height) {
                [tableView setContentOffset:CGPointMake(0.0, tableView.contentOffset.y + yOfCellBottom - [tableView superview].frame.size.height) animated:NO];
                
            }
        }
    }else{
        isOpenCell = YES;
        if (yOfCellBottom > [tableView superview].frame.size.height) {
            [tableView setContentOffset:CGPointMake(0.0, tableView.contentOffset.y + yOfCellBottom - [tableView superview].frame.size.height) animated:NO];
            
        }
    }
    
    currentClickIndex = indexPath.row;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    

}
//未来几天预报cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeatherForecastCell *forecastCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    forecastCell.forecastModel = self.cityWeather.dailyForecast[indexPath.row];
    if (indexPath.row == 0) {
        forecastCell.date.text = @"今天";
    } else if (indexPath.row == 1)
    {
        forecastCell.date.text = @"明天";
    }
    [forecastCell setBackgroundColor:[UIColor clearColor]];
    return forecastCell;
}
//网络状态检测
- (void)reachabilityCheck {
    UILabel *noNetwork = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 30)];
    noNetwork.text = @"网络连接故障";
    noNetwork.font = [UIFont systemFontOfSize:15 weight:UIFontWeightUltraLight];
    noNetwork.textColor = [UIColor redColor];
    noNetwork.textAlignment = NSTextAlignmentCenter;
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [self.view addSubview:noNetwork];
                NSLog(@"没有网络(断网)");
                break;
//            case AFNetworkReachabilityStatusUnknown: // 未知网络
//                NSLog(@"未知网络");
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//                NSLog(@"手机自带网络");
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
//                NSLog(@"WIFI");
//                break;
            default:
                [noNetwork removeFromSuperview];
                [self.dailyForecastTableView.mj_header beginRefreshing];
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}
//cityButton点击方法
- (void)toCityList:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//aboutButton点击方法
- (void)toAboutPage:(id)sender {
    [self performSegueWithIdentifier:@"cityWeather2aboutPage" sender:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
