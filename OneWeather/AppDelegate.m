//
//  AppDelegate.m
//  晴天
//
//  Created by mac on 16/6/1.
//  Copyright © 2016年 com.chen. All rights reserved.
//

#import "AppDelegate.h"

#define mScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface AppDelegate ()
@property (strong, nonatomic)UIView *splashView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreenController"];
    
    self.splashView = viewController.view;
    [self.window makeKeyAndVisible];
    //D片U大淡出的效果开始;
//    self.splashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
//    self.splashView.backgroundColor = [UIColor colorWithRed:69/255.0 green:156/255.0 blue:213/255.0 alpha:1];
//    //设置一个图片;
//    UIImageView *niceView = [[UIImageView alloc] initWithFrame:CGRectMake(mScreenWidth/2-50,mScreenHeight*0.2, 100, 100)];
//    niceView.image = [UIImage imageNamed:@"100"];
//    [self.splashView addSubview:niceView];
    //添加到场景
    [self.window addSubview:self.splashView];
    
    //放到最顶层;
    [self.window bringSubviewToFront:self.splashView];
    [self performSelector:@selector(disappear) withObject:nil afterDelay:1.5];
    
    return YES;
}

- (void)disappear {
    //开始设置动画;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    //�@�e�ü可以�O置回�{函�;
    
    //[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    
    self.splashView.alpha = 0.0;
    self.splashView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.5f, 2.5f, 1.0f);
    //    niceView.frame = CGRectMake(0, 0, 100, 100);
    [UIView commitAnimations];
    
    //结束;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
