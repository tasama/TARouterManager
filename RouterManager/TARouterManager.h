//
//  TARouterManager.h
//  TARouterManager
//
//  Created by tasama on 18/1/2.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TARouterManager : NSObject

/**
 配置scheme
 */
+ (void)settingRouterScheme:(NSString *)scheme;

/**
 匹配url
 
 @param urlString 用以匹配的url
 
 @return 返回匹配结果（如果匹配到的是block，则会直接执行这个block，并返回这个block的返回值）
 */
+ (id)matchWithUrl:(NSString *)urlString;

@end

@interface TARouterUrlConstructer : NSObject

/**
 构造url
 
 @param url  后台定义的url
 @param info 需要拼接的参数
 
 @return 返回拼接完成的url
 */
+ (NSString *)constructUrlWith:(NSString *)url andOptions:(NSDictionary *)info;

@end

