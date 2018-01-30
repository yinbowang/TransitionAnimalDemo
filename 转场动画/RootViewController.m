//
//  RootViewController.m
//  转场动画
//
//  Created by wyb on 2018/1/30.
//  Copyright © 2018年 中天易观. All rights reserved.
//

#import "RootViewController.h"
#import "TestAController.h"
#import "TranstionObject.h"
#import "TestBController.h"

@interface RootViewController ()<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
/***  是否modal*/
@property (nonatomic, assign) BOOL isDismiss;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)push:(id)sender {
    
    TestAController *testA = [[TestAController alloc]init];
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:testA animated:YES];
    
}

- (IBAction)present:(id)sender {
    
    TestBController *testB = [[TestBController alloc]init];
    //这是系统默认的代理动画，有淡入，翻页等
    //testA = UIModalTransitionStyleFlipHorizontal;
    
    // 设置控制器的动画代理
    testB.modalPresentationStyle = UIModalPresentationCustom;
    testB.transitioningDelegate = self;
    [self presentViewController:testB animated:YES completion:nil];
    
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush && [fromVC isEqual:self]) {
        return [TranstionObject new];
    }else if(operation == UINavigationControllerOperationPop && [toVC isEqual:self]) {
        return [TranstionObject new];
    }else{
        return nil;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
// 赋值modal的代理
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

// 赋值dismiss的代理
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
// 返回手势动画速度
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

/**
 *  实现动画，目前这个方法push和pop都使用了淡入，后面会分出
 *
 *  @param transitionContext 动画上下文
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1.从哪里来的控制器，这里是当前控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // 2.要去哪里的控制器，这是是UIViewController
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 3.这个view是包含视图，怎么说呢，几个控制器的view做的动画都是在这里面操作的，看我文章图
    UIView *containerView = [transitionContext containerView];
    
    
    if (self.isDismiss) {
        self.isDismiss = NO;
        // dismiss动画实现
        [UIView animateWithDuration:3.0 * 0.5 / 4.0
                              delay:0.5 / 4.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             fromViewController.view.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [fromViewController.view removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
        
        [UIView animateWithDuration:2.0 * 0.5
                              delay:0.0
             usingSpringWithDamping:1.0
              initialSpringVelocity:-15.0
                            options:0
                         animations:^{
                             fromViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
                         }
                         completion:nil];
    } else {
        
        self.isDismiss = YES;
        // modal动画实现
        // 3.1 更改了显示的容器frame哦
        [containerView addSubview:toViewController.view];
        CGRect frame = containerView.bounds;
        CGFloat width = frame.size.width * 0.5;
        CGFloat left = width * 0.5;
        CGFloat top = frame.size.height * 0.5 - width;
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(top, left, width, left));
        
        // 3.2 更改modal的控制器
        toViewController.view.frame = frame;
        toViewController.view.alpha = 0.0;
        toViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
        // 4.动画效果
        [UIView animateWithDuration:0.5 / 2.0 animations:^{
            toViewController.view.alpha = 1.0;
        }];
        
        CGFloat damping = 0.55;
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:1.0 / damping options:0 animations:^{
            toViewController.view.transform = CGAffineTransformIdentity;
            fromViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}


@end
