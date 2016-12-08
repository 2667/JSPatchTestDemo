//
//  HotFixManager.m
//  JSPatchTest
//
//  Created by Jake on 16/12/7.
//  Copyright © 2016年 Jake. All rights reserved.
//

#import "HotFixManager.h"

#define JSURL @"https://api.bmob.cn/1/classes/JSPatch/%@"
#define version1 @"IxeUXXXf"
#define version2 @"v6Zysss8"

@implementation HotFixManager

+ (id)checkUpdateCompleteHandle:(BlockHandle)handler {
    NSString *string = [NSString stringWithFormat:JSURL, version1];
    return [self getRequestURL:string params:nil requestCompleteHandleSuccess:^(NSDictionary *response, NSError * _Nullable error) {
        if ([response[@"isUpdate"] boolValue]) {
            NSString *urlString = [response[@"useage"] integerValue] == 1 ? response[@"jsfile1"] : response[@"jsfile2"];
            [self downLoadHotFixJSfileWithURL:urlString completeHandle:^(BOOL status, NSString *path, NSError *error) {
                if (!status) {
                    handler(NO, path, error);
                    return ;
                }
                NSLog(@"下载的是%@", urlString);
                handler(YES, path, nil);
            }];
        } else {
            handler(NO, response, error);
        }
        
    } failure:^(id response, NSError *error) {
        handler(NO, nil, error);
    }];
}

+ (id)downLoadHotFixJSfileWithURL:(NSString *)url completeHandle:(BlockHandle)handler {
    
    return [self downloadRequestURL:url params:nil requestCompleteHandleSuccess:^(id filePath, NSError * _Nullable error) {
        if (error) {
            handler(NO, nil, error);
            return ;
        }
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSLog(@"沙盒目录------------------%@", documentPath);
        NSString *destPath = [documentPath stringByAppendingPathComponent:@"hotfix.js"];
        NSError *err = nil;
        NSFileManager *fmanager = [NSFileManager defaultManager];
        if ( [fmanager fileExistsAtPath:destPath] ) {
            [fmanager removeItemAtPath:destPath error:&err];
        }
        [fmanager moveItemAtPath:[filePath path] toPath:destPath error:&err];
       
       
        if (err) {
            handler(NO, nil, err);
             NSLog(@"hotfix文件创建失败！");
        } else {
            handler(YES, destPath, nil);
             NSLog(@"hotfix文件创建成功！");
        }
        
    } failure:^(id filePath, NSError *error) {
        handler(NO, nil, error);
        NSLog(@"下载JS文件出错：%@", error.userInfo);
    }];
}

+ (id)getRequestURL:(NSString *)urlStr params:(NSDictionary *)params requestCompleteHandleSuccess:(void (^)(id response, NSError *_Nullable error))successHandler failure:(void (^)(id response, NSError *error))failureHandler {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:@"1b622283e66139a1dc107c5c81befc55" forHTTPHeaderField:@"X-Bmob-Application-Id"];
    [mutableRequest addValue:@"faf2cab2127a75393d127819d726bb86" forHTTPHeaderField:@"X-Bmob-REST-API-Key"];
    request = [mutableRequest copy];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failureHandler(response, error);
        }
        if (data){
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            successHandler(json, nil);
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (id)downloadRequestURL:(NSString *)urlStr params:(NSDictionary *)params requestCompleteHandleSuccess:(void (^)(id filePath, NSError *_Nullable error))successHandler failure:(void (^)(id filePath, NSError *error))failureHandler {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failureHandler(nil, error);
        }
        //location参数是下载来的文件的临时地址
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        //如果返回的是200，请求正常响应
        if(httpResponse.statusCode == 200){
            NSLog(@"下载来的文件在%@",location);
            successHandler(location, nil);
        } else {
            failureHandler(nil, error);
        }
        
    }];
    
    [downloadTask resume];
    return downloadTask;
}

@end
