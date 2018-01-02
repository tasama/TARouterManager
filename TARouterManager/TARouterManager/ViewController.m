//
//  ViewController.m
//  TARouterManager
//
//  Created by tasama on 18/1/2.
//  Copyright © 2018年 MoemoeTechnology. All rights reserved.
//

#import "ViewController.h"
#import "TARouter.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    id vc = [TARouterManager matchWithUrl:@"memo://enter_room/test"];
    if (vc) {
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}



@end
