//
//  AppDelegate.m
//  毕业设计
//
//  Created by admin on 15-4-8.
//  Copyright (c) 2015年 ShengQiangLiu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#define kParseId @"vKyyGRKsLBpomdWtDW7vuyA4YBYqHAeBj1QcBaLu"
#define kParseClientKey @"Z7EZjSlePFRjK6KKOPoNWei8UJPRxCWvRbJhW4SS"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 设置状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [Parse setApplicationId:kParseId clientKey:kParseClientKey];

    // 跟踪应用程序打开的统计数据
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    // 发送自定义数据分析
    [self sendCustomAnalyticsDataWithOptions:launchOptions];
    
    // 注册推送通知
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    //---------------------------------------------------------------------------------------------------------------------------------------------
//    [PFFacebookUtils initializeFacebook];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [PFImageView class];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    self.window.rootViewController = [LoginViewController new];
    return YES;
}

// 发送自定义数据分析
- (void)sendCustomAnalyticsDataWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *dimensions = @{
                                 // What type of news is this?
                                 @"category": @"politics",
                                 // Is it a weekday or the weekend?
                                 @"dayType": @"weekday",
                                 };
    // Send the dimensions to Parse along with the 'read' event
    
    [PFAnalytics trackEvent:@"read" dimensions:dimensions];
    
}

// 存储 deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

//
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
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
