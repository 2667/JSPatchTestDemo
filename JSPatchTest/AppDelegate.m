//
//  AppDelegate.m
//  JSPatchTest
//
//  Created by Jake on 16/12/6.
//  Copyright © 2016年 Jake. All rights reserved.
//

#import "AppDelegate.h"
#import "JSPatch/JPEngine.h"
#import "HotFixManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *docuPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *hotfixPath = [docuPath stringByAppendingPathComponent:@"hotfix.js"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:hotfixPath]) {
        [JPEngine startEngine];
        NSString *script = [NSString stringWithContentsOfFile:hotfixPath encoding:NSUTF8StringEncoding error:nil];
        [JPEngine evaluateScript:script];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [HotFixManager checkUpdateCompleteHandle:^(BOOL status, NSString *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!status){
                if (!error) {
                    NSLog(@"没有更新");
                } else {
                    NSLog(@"%@", error.userInfo);
                }
                return ;
            }
            NSLog(@"Hotfix文件更新成功");
            
            
        });
    }];
    
}


/*
 [JPEngine startEngine];
 NSString *script = [NSString stringWithContentsOfFile:response encoding:NSUTF8StringEncoding error:nil];
 [JPEngine evaluateScript:script];
 */


/*
 [JPEngine startEngine];
 NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"JSFile" ofType:@"js"];
 NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
 [JPEngine evaluateScript:script];
 */

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
