//
//  TARouterUrls.h
//  TARouterManager
//
//  Created by tasama on 18/1/2.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSObject ()

@end

@interface TARouterUrls : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) NSDictionary *parameters;

- (instancetype)initWithUrl:(NSString *)url;

@end
