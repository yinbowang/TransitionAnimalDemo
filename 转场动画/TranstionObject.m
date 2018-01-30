//
//  TranstionObject.m
//  转场动画
//
//  Created by wyb on 2018/1/30.
//  Copyright © 2018年 中天易观. All rights reserved.
//

#import "TranstionObject.h"

@implementation TranstionObject

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.34;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1.从哪里来的控制器，这里是当前控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // 2.要去哪里的控制器，这是是UIViewController
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 2.1不透明咯
    toViewController.view.alpha = 0;
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    
    
    // 3.这个view是包含视图，怎么说呢，几个控制器的view做的动画都是在这里面操作的，看我文章图
    UIView *containerView = [transitionContext containerView];
    // 3.1要显示必须添加到里面哦
    [containerView addSubview:toViewController.view];
    
    
    
    // 4.动画效果
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        // 用了淡入
        toViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        // 移除从哪里来的控制器的view
        [fromViewController.view removeFromSuperview];
        // 必须一定肯定要调用，用来告诉上下文说已经结束动画了
        [transitionContext completeTransition:YES];
    }];
}

@end
