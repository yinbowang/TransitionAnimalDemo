//
//  TestBController.m
//  转场动画
//
//  Created by wyb on 2018/1/30.
//  Copyright © 2018年 中天易观. All rights reserved.
//

#import "TestBController.h"

@interface TestBController ()

@end

@implementation TestBController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     [self dismissViewControllerAnimated:YES completion:nil];
}


@end
