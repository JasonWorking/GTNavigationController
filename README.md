# GTNavigationController
A drop in replacement of UINavigationController with predefined custom transition animations. Base on ADTransitionController. Support iOS6+ .
# Base on [ADTransitionController](https://github.com/applidium/ADTransitionController/) .
![image](https://raw.githubusercontent.com/JasonWorking/GTNavigationController/master/customNaviDemo.gif)


#### 1 实现原理：
1. 概述： GTNavigationViewController是[ADTransitionController](https://github.com/applidium/ADTransitionController/)的一个封装。提供类似系统自带UINavigationController的接口，并提供17种预定义的转场动画模版。
2. ADTransitionController通过实现一个自定义的Containner ViewControler来实现NavigationController的功能，提供17种自定义Transition动画模版。GTNavigationViewController通过继承ADTransitionController来简化ADTransitionController的使用，底层实现还是由ADTransitionController来提供的。


#### 2 使用方式:

#####iOS7+
1. 在iOS7+上，系统提供了自定义Transition动画的接口，通过由三个协议来实现，如何通过iOS7以后提供的官方API实现自定义转场动画可以参考这个系列的[blog](https://bradbambara.wordpress.com/2014/04/17/ios-view-controller-transitions-part-2/)：


```
///协议1: UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0);

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);

************************

///协议2: UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0);

************************

/// 协议3: UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;



************************


``` 
虽然系统提供了接口，但是实现起来比较复杂，需要学习成本，ADTransitionController为我们提供了两个类：`ADNavigationControllerDelegate` 和 `ADTransitioningDelegate`, 其中ADNavigationControllerDelegate实现了UINavigationControllerDelegate，实例化一个该类的实例作为UINavigationController的代理就可以不需要再处理UINavigationControllerDelegate协议。ADTransitioningDelegate实现了 协议2: UIViewControllerTransitioningDelegate和协议3: UIViewControllerAnimatedTransitioning，同样的，实例化一个ADTransitioningDelegate的实例作为UIViewController的tansitioningDelegate即可以不需要再处理这两个协议。 而且ADTransitionController为我们提供了一个预先定义好的ADTransitioningViewController，使自己的VC继承自ADTransitioningViewController，则可以方便地处理协议2和协议3，具体参考下面的例子：

```

iOS7+ 中使用方式：


1. 当ViewController继承ADTransitioningViewController时

//////////////////在appDelegate的didFinishLaunchWithOptions:中///////////
// #import "ADNavigationControllerDelegate.h"
...
UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:viewController]; //viewController是ADTransitioningViewController子类的一个实例
ADNavigationControllerDelegate * navigationDelegate = [[ADNavigationControllerDelegate alloc] init];
navigationController.delegate = navigationDelegate;
self.window.rootViewController = navigationController;

//////////////////在需要push新的ViewController时///////////

ViewController * newViewController = [[ViewController alloc] init]; // ViewController是ADTransitioningViewController的一个子类 
ADTransition * transition = [[ADCubeTransition alloc] initWithDuration:0.25f orientation:ADTransitionRightToLeft sourceRect:self.view.frame];
newViewController.transition = transition;
[self.navigationController pushViewController:newViewController animated:YES];

*********************************************************************************

2.实际工程中，我们可能并不希望我们的所有ViewContrller都继承自ADTransitioningViewController，此时，我们可以通过实例化一个ADTransitioningDelegate来作为tansitioningDelegate，具体做法如下：

//////////////////在appDelegate的didFinishLaunchWithOptions:中///////////
// #import "ADNavigationControllerDelegate.h"
...
UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:viewController]; //NOTE：viewController不是ADTransitioningViewController子类的一个实例，而是普通的VC类
ADNavigationControllerDelegate * navigationDelegate = [[ADNavigationControllerDelegate alloc] init];
navigationController.delegate = navigationDelegate;
self.window.rootViewController = navigationController;

//////////////////在需要push新的ViewController时///////////

UIViewController * newViewController = [[UIViewController alloc] init];
ADTransition * transition = [[ADCubeTransition alloc] initWithDuration:0.25f orientation:ADTransitionRightToLeft sourceRect:self.view.frame];
ADTransitioningDelegate * transitioningDelegate = [[ADTransitioningDelegate alloc] initWithTransition:transition];
newViewController.transitioningDelegate = transitioningDelegate;
[self.navigationController pushViewController:newViewController animated:YES];

```
 

#####iOS6+

1. 在iOS6+上可以直接使用GTNavigationController,使用方式如下：

```
... In appDelegate ,在初始化时制定GTNavigationController使用的动画类型 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
        
    //Setup GTNavigationViewController
    GTDemoViewController *vc = [[GTDemoViewController alloc] init];
    GTNavigationViewController *navi = [[GTNavigationViewController alloc] initWithRootViewController:vc transitionType:GTNavigationTransitionTypePush]; 
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    return YES;
}


... In viewController ,不需要继承ADTransitioningViewController

...#import "UIViewController+ADTransitionController.h"

/// 使用GTNavigationController初始化时指定的转场动画
- (void)onPushButtonTapped:(UIButton *)sender
{
    GTDemoViewController *newVC = [GTDemoViewController new];
    [self.gtNavigationController pushViewController:newVC animated:YES/NO];
}


/// 使用其他动画

- (void)onPushButtonTapped:(UIButton *)sender
{
    ADBackFadeTransition *customTransition = [[ADBackFadeTransition alloc] initWithDuration:0.5];
    [self.gtNavigationController pushViewController:newVC withTransition:customTransition];
}

```





#### 3 使用时注意事项:
1. 若工程只需要支持iOS7+，建议使用iOS7+上的使用方式 
2. 若使用iOS6+上的方式时，每一个ViewController都是可以自定义push时的动画的，当没有自定义时会使用初始化GTNavigationController时指定的统一动画类型。当然，同时建议一个App中的navigation的动画保持统一。


#### 4 Example 

1.  GTNavigationController中的Demo主要演示如何使用该扩展类（支持iOS6＋），可以通过进入设置页修改不同动画效果。ADTransitionController中带的Demo演示了iOS7＋上的使用方式和iOS6＋上未扩展时的使用方式。