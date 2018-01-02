//
//  TARouterManager.m
//  TARouterManager
//
//  Created by tasama on 18/1/2.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import "TARouterManager.h"
#import "TARouterManagerDelegate.h"
#import "TARouterUrls.h"

@interface TARouterManager ()

@property (nonatomic, strong) NSMutableDictionary *routers;

@property (nonatomic, strong) NSMutableArray *mapUrls;

@end

NSString *TA_SCHEME = @"memo";
typedef NSArray TARouterUrlInfo;
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \

@implementation TARouterManager

#pragma mark - Load

+ (void)load {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"ModuleEnterUrls.plist" ofType:nil];
    NSArray *routers = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *router in routers) {
        
        NSString *url = router[@"url"];
        NSString *controller = router[@"controller"];
        [TARouterManager registerUrl:url withController:NSClassFromString(controller)];
    }
}

#pragma mark - Private Method

+ (void)settingRouterScheme:(NSString *)scheme {
    
    TA_SCHEME = scheme;
}

+ (id)matchWithUrl:(NSString *)urlString {
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (![self checkUrlWith:urlString]) return nil;
    
    urlString = [self checkSchemeWith:urlString];
    
    if ([[[NSURL URLWithString:urlString].scheme lowercaseString] isEqualToString:@"http"] || [[[NSURL URLWithString:urlString].scheme lowercaseString] isEqualToString:@"https"]) {
        
        //网页浏览器
        NSLog(@"进入网页浏览器");
        return nil;
    }
    
    //进入模块搜索
    return [self matchModuleWithUrl:urlString];
}

#pragma mark - Private Method

//初始化
- (instancetype)init {
    
    if (self = [super init]) {
        
        self.routers = @{}.mutableCopy;
        self.mapUrls = @[].mutableCopy;
    }
    return self;
}

+ (instancetype)shared {
    
    static TARouterManager *routerManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        routerManager = [[TARouterManager alloc] init];
    });
    
    return routerManager;
}

//注册
+ (void)registerUrl:(NSString *)url withController:(Class)controller {
    
    if (![self checkUrlWith:url]) return;
    
    [[TARouterManager shared].mapUrls addObject:url];
    
    NSMutableDictionary *dict = [[self shared] ansylizeWithUrl:url];
    
    dict[@"_"] = controller;
}

//模块搜索
+ (id)matchModuleWithUrl:(NSString *)url {
    
    NSLog(@"转入模块化搜索...");
    TARouterManager *manager = [TARouterManager shared];
    TARouterUrlInfo *urlHandle = [self handleWithUrl:url byManager:manager];
    
    NSString *scheme = urlHandle[0];
    NSString *host = urlHandle[1];
    NSArray *components = urlHandle[2];
    NSString *parameterString = urlHandle[3];
    NSString *classPartString = urlHandle[4];
    NSMutableDictionary *info = urlHandle[5];
    
    NSMutableArray *road = @[host].mutableCopy;
    [road addObjectsFromArray:components];
    NSDictionary *router = [TARouterManager shared].routers[scheme];
    
    id <TARouterManagerSourceDelegate> enter = [self anyliseComponentsWithDict:router andRoad:road andIndex:0];
    TARouterUrls *routerUrl = [[TARouterUrls alloc] initWithUrl:classPartString];
    routerUrl.parameters = info;
    if ([enter respondsToSelector:@selector(viewControllerWithUrl:)]) {
        
        return [enter viewControllerWithUrl:routerUrl];
    }
    return nil;
}

//解析URL
- (NSMutableDictionary *)ansylizeWithUrl:(NSString *)urlString {
    
    urlString = [TARouterManager checkSchemeWith:urlString];
    
    urlString = [urlString lowercaseString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *scheme = url.scheme;
    NSString *host = url.host;
    NSArray *components = url.path.pathComponents;
    
    if (!self.routers[scheme]) {
        
        self.routers[scheme] = @{}.mutableCopy;
    }
    NSMutableDictionary *routerDic = self.routers[scheme];
    
    if (!routerDic[host]) {
        
        routerDic[host] = @{}.mutableCopy;
    }
    
    routerDic = routerDic[host];
    for (NSString *component in components) {
        
        if ([component isEqualToString:@"/"]) continue;
        
        if (!routerDic[component]) {
            
            routerDic[component] = @{}.mutableCopy;
        }
        
        routerDic = routerDic[component];
    }
    return routerDic;
}

//对URL进行一次处理
+ (TARouterUrlInfo *)handleWithUrl:(NSString *)url byManager:(TARouterManager *)manager {
    
    NSRange range = [url rangeOfString:@"?"];
    
    NSString *parameterString = @"";
    NSString *classPartString = @"";
    if (range.location != NSNotFound) {
        
        parameterString = [url substringFromIndex:([url rangeOfString:@"?"].location + 1)];//urlAndParametersArr.lastObject; // 参数字符串段
        classPartString = [[url substringToIndex:([url rangeOfString:@"?"].location)] lowercaseString];//;[urlAndParametersArr.firstObject lowercaseString]; //匹配字符串段
    } else {
        
        classPartString = [url lowercaseString];
    }
    NSMutableDictionary *info = [manager ansylizeInfo:parameterString];
    
    NSString *scheme = [NSURL URLWithString:classPartString].scheme;
    NSString *host = [NSURL URLWithString:classPartString].host;
    NSArray *components = [NSURL URLWithString:classPartString].path.pathComponents;
    NSMutableArray *temp = @[].mutableCopy;
    for (NSString *key in components) {
        
        if ([key isEqualToString:@"/"]) continue;
        [temp addObject:key];
    }
    components = temp.copy;
    return @[scheme, host, components,parameterString,classPartString,info];
}

//检测URL的合法性
+ (BOOL)checkUrlWith:(NSString *)urlString {
    if (!urlString || urlString.length == 0) {
        return NO;
    }
    
    urlString = [[self checkSchemeWith:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (!url.host) {
        
        return NO;
    }
    
    return YES;
}

//检测URL的scheme
+ (NSString *)checkSchemeWith:(NSString *)url {
    
    NSString *urlTemp = [url lowercaseString];
    
    if (![urlTemp hasPrefix:TA_SCHEME] && ![urlTemp hasPrefix:@"http://"] && ![urlTemp hasPrefix:@"https://"]) {
        
        if ([urlTemp hasPrefix:@"/"]) {
            
            NSString *scheme = [TA_SCHEME stringByAppendingString:@":/"];
            return [scheme stringByAppendingString:url];
        }
        
        NSString *scheme = [TA_SCHEME stringByAppendingString:@"://"];
        return [scheme stringByAppendingString:url];
    }
    
    return url;
}

//根据路径检索注册的模块
+ (id)anyliseComponentsWithDict:(NSDictionary *)dic andRoad:(NSMutableArray *)arr andIndex:(NSUInteger)index {
    
    if (index > arr.count - 1) {
        
        return nil;
    }
    if (dic[@"_"]) {
        
        Class controller = dic[@"_"];
        id target = nil;
        @try {
            
            target = [[controller alloc] init];
        } @catch (NSException *exception) {
            
            NSLog(@"exception!!--> name:%@, reason:%@, info:%@",exception.name, exception.reason, exception.userInfo);
        }
        
        if (!target) {
            
            return nil;
        }
        return target;
    }
    
    dic = dic[arr[index]];
    if (!dic) {
        
        return nil;
    }
    index += 1;
    return [self anyliseComponentsWithDict:dic andRoad:arr andIndex:index];
}

//解析参数，将URL中的参数解析为字典
- (NSMutableDictionary *)ansylizeInfo:(NSString *)parameters {
    
    NSArray *parametersArr = [parameters componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *info = @{}.mutableCopy;
    for (NSString *singleParameter in parametersArr) {
        NSRange range = [singleParameter rangeOfString:@"="];
        NSString *key = @"";
        id value = @"";
        if (range.location != NSNotFound) {
            
            key = [singleParameter substringToIndex:range.location];
            value = [singleParameter substringFromIndex:(range.location + 1)];
        }
        
        if (kStringIsEmpty(key) || kStringIsEmpty(value)) {
            
            continue;
        }
        info[key] = value;
    }
    return info;
}

@end


#pragma mark - TARouterUrlConstructer

#define BASE64TYPE @"#codeBybase64Encoding#"
#define ENCODINGLENGTH [@"#codeBybase64Encoding#" length]

@implementation TARouterUrlConstructer

+ (NSString *)constructUrlWith:(NSString *)url andOptions:(NSDictionary *)info {
    
    __block NSString *urlMutable = [url stringByAppendingString:@"?"];
    [info enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *string = @"";
        if ([obj isKindOfClass:[NSString class]]){
            
            string = obj;
            
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            
            string = [obj stringValue];
            
        } else {
            
            if (![obj isKindOfClass:[NSArray class]] && ![obj isKindOfClass:[NSDictionary class]]) {
                
                return;
            }
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            
            string = [[jsonData base64EncodedStringWithOptions:NSUTF8StringEncoding] stringByAppendingString:BASE64TYPE];
        }
        NSString *str = [NSString stringWithFormat:@"%@=%@&", key, string];
        
        urlMutable = [urlMutable stringByAppendingString:str];
    }];
    
    return [urlMutable substringToIndex:(urlMutable.length - 1)];
}

@end
