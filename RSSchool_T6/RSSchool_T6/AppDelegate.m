//
//  AppDelegate.m
//  RSSchool_T6
//
//  Created by Karina on 6/19/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+ColorFromRGB.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UINavigationBar appearance].barTintColor = [UIColor colorFromRGBNumber:@0xF9CC78];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [UINavigationBar appearance].barTintColor = [UIColor colorFromRGBNumber:@0xF9CC78];
    
    MainViewController *vc = [[MainViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];;
    
    return YES;
    
}


#pragma mark - UISceneSession lifecycle



@end
