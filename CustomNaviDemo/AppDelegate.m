//
//  AppDelegate.m
//  CustomNaviDemo
//
//  Created by Jason-autonavi on 15/5/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "AppDelegate.h"
#import "GTDemoViewController.h"
#import "GTNavigationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // Hide statusBar .
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    // Set appearance
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"ALNavigationBarBackground"] stretchableImageWithLeftCapWidth:1.0f topCapHeight:1.0f] forBarMetrics:UIBarMetricsDefault];
    NSDictionary * navigationBarTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor],
                                                   UITextAttributeTextShadowColor : [UIColor blackColor],
                                                   UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(-1.0f, 0)]};
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTextAttributes];
    
    
    
    
    //Setup GTNavigationViewController
    GTDemoViewController *vc = [[GTDemoViewController alloc] init];
    GTNavigationViewController *navi = [[GTNavigationViewController alloc] initWithRootViewController:vc transitionType:GTNavigationTransitionTypePush];
    
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = navi;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sky@2x.jpg"]];
    imageView.frame = self.window.bounds;
    [self.window insertSubview:imageView atIndex:0];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
