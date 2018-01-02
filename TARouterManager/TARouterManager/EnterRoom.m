//
//  EnterRoom.m
//  TARouterManager
//
//  Created by tasama on 18/1/2.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import "EnterRoom.h"
#import "TARouter.h"
#import "NewViewController.h"

@interface EnterRoom () <TARouterManagerSourceDelegate>

@end

@implementation EnterRoom

- (id)viewControllerWithUrl:(TARouterUrls *)url {
    
    return [[NewViewController alloc] init];
}

@end
