//
//  TARouterManagerDelegate.h
//  TARouterManager
//
//  Created by tasama on 18/1/2.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#ifndef TARouterManagerDelegate_h
#define TARouterManagerDelegate_h

@class TARouterUrls;
@protocol TARouterManagerSourceDelegate <NSObject>

- (id)viewControllerWithUrl:(TARouterUrls *)url;

@optional
/**
 控制器回调的通用代理
 
 @param controllerTag 控制器的tag
 @param dictory       回调参数
 */
- (void)viewControllerTag:(NSString *)controllerTag withParameters:(NSDictionary *)dictory;

@end

#endif /* TARouterManagerDelegate_h */
