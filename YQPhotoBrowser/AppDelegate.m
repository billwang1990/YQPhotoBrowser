//
//  AppDelegate.m
//  YQPhotoBrowser
//
//  Created by yang hai on 13-8-17.
//  Copyright (c) 2013年 billwang1990@gmail.com. All rights reserved.
//

#import "AppDelegate.h"
#import "YQPhotoBrowser.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    NSArray *bimageArr=[NSArray arrayWithObjects:
                        @"http://125.70.12.96/media/awine/ex_chap/P33-1.png",
                        @"http://125.70.12.96/media/awine/he_in_chap/P33-5.png",
                        @"http://125.70.12.96/media/awine/tra_cert/P35-1.png",
                        @"http://125.70.12.96/media/awine/ex_in_rep/P35-2.png",
                        @"http://d.hiphotos.baidu.com/album/w%3D2048/sign=0c2a56cf77c6a7efb926af26c9c2ae51/32fa828ba61ea8d316248714960a304e251f5898.jpg",
                        nil];
    
    NSArray *text = [NSArray arrayWithObjects:@"the two array must have some count objects", @"if there isn't a description word, you can set the [NSNull null] like the next one", [NSNull null], @"ksnhk", @"good luck, billwang@gmail.com",nil];
    
    YQPhotoBrowser   *vc = [[YQPhotoBrowser alloc]initWithImagesUrl:bimageArr andDescription:text];
    
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
