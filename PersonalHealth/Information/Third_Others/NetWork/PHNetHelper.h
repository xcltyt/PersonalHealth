//
//  PHNetHelper.h
//  personal health helper
//
//  Created by Dylan on 3/1/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface PHNetHelper :AFHTTPSessionManager
// 封装GET请求，成功和失败在一个 block 里面处理
+ (void)GETWithExtraUrl:(NSString *)url andParam:(NSDictionary *)params andComplete:(void (^)(BOOL success, id result))complete;

// 封装POST请求，成功和失败在一个 block 里面处理
+ (void)POSTWithExtraUrl:(NSString *)url andParam:(NSDictionary *)params andComplete:(void (^)(BOOL success, id result))complete;

@end
