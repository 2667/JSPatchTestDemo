//
//  JSPatchController.m
//  JSPatchTest
//
//  Created by Jake on 16/12/6.
//  Copyright © 2016年 Jake. All rights reserved.
//

#import "JSPatchController.h"
#import "SecondViewController.h"
#import "HotFixManager.h"
#import "JSPatch/JPEngine.h"

#define jsfile1 @"http://ohr2l42gb.bkt.clouddn.com/_JSFile1.js"
#define jsfile2 @"http://ohr2l42gb.bkt.clouddn.com/_JSFile2.js"

@interface JSPatchController ()

@end

@implementation JSPatchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ad" ofType:@"mp4"];
    NSLog(@"%@",filePath);
    
}

- (IBAction)pushJSViewController:(UIButton *)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];

}

- (IBAction)updateJS:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSString *url = sender.isSelected ? jsfile1 : jsfile2;
    [sender setTitle:@"当前JS1" forState:UIControlStateSelected];
    [sender setTitle:@"当前JS2" forState:UIControlStateNormal];
    
    NSLog(@"下载的是%@",url);
    [HotFixManager downLoadHotFixJSfileWithURL:url completeHandle:^(BOOL status, id response, NSError *error) {
        if (!status){
            NSLog(@"下载出错\n%@", error.userInfo);
            return ;
        }
        NSLog(@"Hotfix文件更新成功");
        [JPEngine startEngine];
        NSString *script = [NSString stringWithContentsOfFile:response encoding:NSUTF8StringEncoding error:nil];
        [JPEngine evaluateScript:script];
    }];
}

- (IBAction)removeJs:(id)sender {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"沙盒目录------------------%@", documentPath);
    NSString *destPath = [documentPath stringByAppendingPathComponent:@"hotfix.js"];
    NSError *err = nil;
    NSFileManager *fmanager = [NSFileManager defaultManager];
    if ( [fmanager fileExistsAtPath:destPath] ) {
        [fmanager removeItemAtPath:destPath error:&err];
    }
    
    if (err) {
        NSLog(@"hotfix文件删除失败！");
    } else {
        NSLog(@"hotfix文件删除成功！");
    }

}

@end
