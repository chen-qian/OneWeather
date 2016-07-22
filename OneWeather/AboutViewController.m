//
//  AboutViewController.m
//  OneWeather
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *aboutList;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.aboutList.delegate = self;
    self.navigationItem.title = @"关于";
    
    //设置backButton
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 19, 30, 30);
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toBackButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = toBackButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];

    UIImageView *disclosure = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.9, 10, 24, 24)];
    disclosure.image = [UIImage imageNamed:@"disclosure"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"给我评分";
            cell.detailTextLabel.text = @"";
            cell.imageView.image = [UIImage imageNamed:@"star"];
            [cell addSubview:disclosure];
            break;
        case 1:
            cell.textLabel.text = @"免责声明";
            cell.detailTextLabel.text = @"";
            cell.imageView.image = [UIImage imageNamed:@"statement"];
            [cell addSubview:disclosure];
            break;
        case 2:
            cell.textLabel.text = @"新浪微博";
            cell.detailTextLabel.text = @"陳乾的微博";
            cell.imageView.image = [UIImage imageNamed:@"weibo"];
            break;
//        case 3:
//            cell.textLabel.text = @"微信";
//            cell.detailTextLabel.text = @"chenqian1338332";
//            cell.imageView.image = [UIImage imageNamed:@"weixin"];
//            break;
        default:
            break;
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    [cell.accessoryView setBackgroundColor:[UIColor redColor]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];//去掉highlighted灰色背景
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];//高亮背景
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:28/255.0 green:161/255.0 blue:242/255.0 alpha:1];//高亮字色
    cell.detailTextLabel.highlightedTextColor = [UIColor colorWithRed:28/255.0 green:161/255.0 blue:242/255.0 alpha:1];//高亮字色
    
    //分割线
    UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(10, cell.frame.size.height - 1, cell.frame.size.width - 20, 1)];
    separatorView.image = [UIImage imageNamed:@"separator"];
    [cell addSubview:separatorView];
    return cell;
    
}
//组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1132639944"];
    NSURL * url = [NSURL URLWithString:str];
    
    switch (indexPath.row) {
        case 0:
            //去评分
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            else
            {
                NSLog(@"can not open");
            }
            break;
        case 1:
            [self performSegueWithIdentifier:@"about2statement" sender:nil];
            break;
        case 2:

            break;
        default:
            break;
    }
    
}


//backButton点击方法
- (void)backPage:(id)sender {    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
