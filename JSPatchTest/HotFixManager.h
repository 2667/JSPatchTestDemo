//
//  HotFixManager.h
//  JSPatchTest
//
//  Created by Jake on 16/12/7.
//  Copyright © 2016年 Jake. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^BlockHandle)(BOOL status, id response, NSError *error);

@interface HotFixManager : NSObject

+ (id)checkUpdateCompleteHandle:(BlockHandle)handler;

+ (id)downLoadHotFixJSfileWithURL:(NSString *)url completeHandle:(BlockHandle)handler;

@end
