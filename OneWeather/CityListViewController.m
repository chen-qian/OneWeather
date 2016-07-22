//
//  CityListViewController.m
//  晴天
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "CityListViewController.h"
#import "CityCell.h"
#import "CityWeatherModel.h"
#import "WeatherForecastModel.h"
#import "CityWeatherViewController.h"
#import "CityAddViewController.h"

@interface CityListViewController ()<UITableViewDataSource, UITableViewDelegate, CityAddViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *cityListTableView;
//用户选择的城市列表
@property (nonatomic, strong) NSMutableArray *cityArray;
//所有的城市_代码字典
@property (nonatomic, strong) NSDictionary *cityDictionary;
//选中的城市天气
@property (nonatomic, strong) CityWeatherModel *cityWeather;
//所有城市天气
@property (nonatomic, strong) NSMutableArray *weatherArray;

@end

static NSString *identifier = @"cityCell";

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //启动直接执行城市列表到天气页面的跳转
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.cityListTableView cellForRowAtIndexPath:indexPath];
    if (self.cityArray == nil || self.cityArray.count == 0 ) {//判断是否初次运行没有城市或者城市全删除了时不能用_cityArray, 因为不会调懒加载方法, 会一直为nil
        [self performSegueWithIdentifier:@"cityList2cityAdd" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"cityList2cityWeather" sender:cell];
    }
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    //navigationBar透明
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightRegular]}];//navigationBar title白色
    
    //设置addCityButton
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 19, 30, 30);
    [addButton setImage:[UIImage imageNamed:@"addButton"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(toAddCityPage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toAddButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = toAddButton;
}

- (NSMutableArray *)cityArray {
    if (nil == _cityArray) {
        _cityArray = [NSMutableArray array];
        //读取数据
        //1.获取documents路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSLog(@"%@", path);
        //2.拼接文件名
        NSString * filePath = [path stringByAppendingPathComponent:@"cityList.plist"];
        
        //3.读取
        _cityArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        
    }
    return _cityArray;
}

- (NSDictionary *)cityDictionary {
    if (nil == _cityDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityId.plist" ofType:nil];
        _cityDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _cityDictionary;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityCell *cityCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cityCell.cityName = self.cityArray[indexPath.row];
    cityCell.selectedBackgroundView = [[UIView alloc] initWithFrame:cityCell.frame];//去掉highlighted灰色背景
    cityCell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];//高亮背景
    cityCell.cityNameLabel.highlightedTextColor = [UIColor colorWithRed:28/255.0 green:161/255.0 blue:242/255.0 alpha:1];//高亮字色
    return cityCell;

}
//组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityArray.count;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//跳转前传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {//这段代码写的不是太好, 需要优化
    if ([[segue destinationViewController] isKindOfClass:[CityWeatherViewController class]]) {
        CityWeatherViewController *cityWeatherViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.cityListTableView indexPathForCell:sender];
        NSString *cityName = self.cityArray[indexPath.row];
        NSString *cityId = [self.cityDictionary objectForKey:cityName];
        [cityWeatherViewController setValue:cityId forKey:@"cityId"];
        [cityWeatherViewController setValue:cityName forKey:@"cityName"];
        [self.cityListTableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if ([[segue destinationViewController] isKindOfClass:[CityAddViewController class]])
    {
        CityAddViewController *cityAddViewController = [segue destinationViewController];
        [cityAddViewController setValue:self.cityDictionary forKey:@"cityDictionary"];
        //设置自己成为CityAddViewController的代理 用来调用addCity方法
        cityAddViewController.delegate = self;
    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.cityArray removeObjectAtIndex:indexPath.row];
    [_cityListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self saveCityToFile];
}

- (void)addCity:(NSString *)cityName {
    if (self.cityArray == nil) {
        _cityArray = [NSMutableArray array]; //如果没城市时直接跳转cityAdd了 _cityArray没有初始化 导致下两句报错
    }
    if (![self.cityArray containsObject:cityName]) {//判断城市是否重复
        [self.cityArray addObject:cityName];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.cityArray.count - 1 inSection:0];
        [self.cityListTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self saveCityToFile];
    }

}

- (void)saveCityToFile {
    //1.获取documents路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    //2.拼接文件名
    
    NSString * filePath = [path stringByAppendingPathComponent:@"cityList.plist"];
    
    //3.存储 参数2:是否允许原子型写入
    [self.cityArray writeToFile:filePath atomically:YES];

}
//addCity点击方法
- (void)toAddCityPage:(id)sender {
    [self performSegueWithIdentifier:@"cityList2cityAdd" sender:nil];
}
@end
