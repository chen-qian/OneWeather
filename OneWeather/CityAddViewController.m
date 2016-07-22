//
//  CityAddViewController.m
//  OneWeather
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "CityAddViewController.h"
#import "ZYPinYinSearch.h"
#import "ChineseString.h"
#import "CityLocater.h"
#import "CityCell.h"

@interface CityAddViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, CityLocaterDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSDictionary *cityDictionary;
@property (strong, nonatomic) NSArray *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (strong, nonatomic) NSArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (assign, nonatomic) BOOL isSearch;//辨别是否是搜索结果的tableView

@property (nonatomic, copy) NSString *currentLocateCity; //当前定位城市
@property (nonatomic) BOOL isLocateSuccess;//判断定位是否成功
@property (nonatomic, strong)UIActivityIndicatorView *indicator;//定位菊花
@property (nonatomic, strong) UILabel *currentCityLabel;//用于修改定位城市cell的text
@property (nonatomic, strong) CityLocater *locater;

@end

@implementation CityAddViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blueColor];
    _cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initData];
    [self setSearchBar];
    self.cityTableView.sectionIndexColor = [UIColor whiteColor];//索引颜色
    self.cityTableView.sectionIndexBackgroundColor = [UIColor clearColor];//索引背景色
    [_searchBar becomeFirstResponder];//一进入就搜索框成为焦点
    
    self.locater = [[CityLocater alloc] init];
    _locater.delegate = self;
    [_locater startLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init
- (void)initData {
    _dataSource = [_cityDictionary allKeys];
    _searchDataSource = [NSMutableArray new];
    //获取索引的首字母
    _indexDataSource = [ChineseString IndexArray:_dataSource];
    //对原数据进行排序重新分组
    _allDataSource = [ChineseString LetterSortArray:_dataSource];
}


- (void)setSearchBar {
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.tintColor = [UIColor whiteColor];
    UITextField *searchField = [_searchBar valueForKey:@"searchField"];
    [searchField setTintColor:[UIColor colorWithRed:28/255.0 green:161/255.0 blue:242/255.0 alpha:1]];

    _searchBar.placeholder = @"请输入城市名称";
    _searchBar.showsCancelButton = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_isSearch) {
        return _indexDataSource.count + 1;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_isSearch) {
        if (section == 0) {
            return 1;
        }else {
            return [_allDataSource[section - 1] count];
        }
    }else {
        return _searchDataSource.count;
    }
}
//头部索引标题
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (!_isSearch) {
//        if (section == 0) {
//            return @"定位城市";
//        }else {
//            return _indexDataSource[section - 1];
//        }
//    }else {
//        return nil;
//    }
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:28/255.0 green:161/255.0 blue:242/255.0 alpha:1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    if (!_isSearch) {
        if (section == 0) {
            titleLabel.text = @"定位城市";
        }else {
            titleLabel.text = _indexDataSource[section - 1];
        }
    }else {
        self.cityTableView.tableHeaderView = nil;
    }
    [headerView addSubview:titleLabel];
    return headerView;
}

//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!_isSearch) {
        return _indexDataSource;
    }else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(10, cell.frame.size.height - 1, cell.frame.size.width - 20, 1)];
    separatorView.image = [UIImage imageNamed:@"separator"];
    [cell addSubview:separatorView];

    if (!_isSearch) {
        if (indexPath.section == 0) {
            cell.cityNameLabel.text = _currentLocateCity;
            self.currentCityLabel = cell.cityNameLabel;//以便之后用self.currentCityLabel改变定位城市的text
        } else {
            cell.cityNameLabel.text = _allDataSource[indexPath.section - 1][indexPath.row];
        }

    }else{
        cell.cityNameLabel.text = _searchDataSource[indexPath.row];
    }
    cell.cityNameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightUltraLight];
    [cell.cityNameLabel setTextColor:[UIColor whiteColor]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];//去掉highlighted灰色背景
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];//高亮背景
    cell.cityNameLabel.highlightedTextColor = [UIColor colorWithRed:28/255.0 green:161/255.0 blue:242/255.0 alpha:1];//高亮字色
    return cell;
}
//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_searchDataSource removeAllObjects];
    NSArray *array = [NSArray new];
    array = [ZYPinYinSearch searchWithOriginalArray:_dataSource andSearchText:searchText andSearchByPropertyName:@"name"];
    if (searchText.length == 0) {
        _isSearch = NO;
        [_searchDataSource addObjectsFromArray:_dataSource];
    }else {
        _isSearch = YES;
        [_searchDataSource addObjectsFromArray:array];
    }
    [self.cityTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        _searchBar.showsCancelButton = YES;
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
//    _searchBar.text = @"";
//    _isSearch = NO;
//    [_cityTableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)positionLocater:(CityLocater *)locator didFinishedLocateWithCity:(NSString *)city {
    if (city.length > 0) {
        _isLocateSuccess = YES;
        [_indicator stopAnimating];//定位后去掉菊花
        [_indicator removeFromSuperview];
        self.currentLocateCity = [city substringToIndex:[city length]-1];//去掉"市"
        self.currentCityLabel.text = [city substringToIndex:[city length]-1];
//        [self sendSaveCityRequestWithCity:city];
    }
    
    //[self.tableView reloadRowsAtIndexPaths:@[] withRowAnimation:(UITableViewRowAnimation)]
}

- (void)positionLocater:(CityLocater *)locator failToLocationWithError:(NSString *)code {
    _isLocateSuccess = NO;
    if ([code isEqualToString:@"您没有开启定位功能"]) {
        self.currentCityLabel.text = code;
        self.currentLocateCity = code;
    } else {
        self.currentCityLabel.text = @"无法获取您的位置";
        self.currentLocateCity = @"无法获取您的位置";
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cityName = nil;
    if (!_isSearch) {
        if (indexPath.section == 0) {
            if (_isLocateSuccess == NO) {
                //定位失败 不能选择
                return;
            }
            cityName = self.currentLocateCity;
        } else {
            cityName = _allDataSource[indexPath.section - 1][indexPath.row];
        }
        
    } else {
        cityName = _searchDataSource[indexPath.row];
    }
    
    if (cityName) {
        if ([self.delegate respondsToSelector:@selector(addCity:)]) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate addCity:cityName];
            }];
        }
    }
}

- (void)locatingIndicator:(BOOL)status {//打开或关闭定位菊花
    if (status) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

        CityCell *cell = [_cityTableView cellForRowAtIndexPath:indexPath];
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, cell.frame.size.height/2-10, 20, 20)];
        [cell addSubview:_indicator];
        
        [_indicator startAnimating];
    }else {
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
    }
}

- (void)dealloc {
    self.locater = nil;
    self.delegate = nil;
}

@end
