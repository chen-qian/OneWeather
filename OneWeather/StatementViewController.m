//
//  StatementViewController.m
//  OneWeather
//
//  Created by mac on 16/7/7.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "StatementViewController.h"

@interface StatementViewController ()

@property (weak, nonatomic) IBOutlet UITextView *statementTextView;
@end

@implementation StatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.statementTextView setContentOffset:CGPointMake(0, 0) animated:YES];
    // Do any additional setup after loading the view.
}

- (IBAction)didClickCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
