//
//  GTNavigationViewController.m
//  CustomNaviDemo
//
//  Created by Jason-autonavi on 15/5/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "GTNavigationViewController.h"


static const NSTimeInterval kDefaultTransitionDuration = 0.33;

@interface GTNavigationViewController ()
@property (nonatomic, assign) ADTransitionOrientation orientation;
@end

@implementation GTNavigationViewController
- (instancetype)init
{
    if (self = [super init]) {
        _transitionDuration = kDefaultTransitionDuration;
        _transitionType     = GTNavigationTransitionTypePush;
        _orientation        = ADTransitionRightToLeft;
    }
    
    return self;
}


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    return [self initWithRootViewController:rootViewController transitionType:GTNavigationTransitionTypePush];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
                            transitionType:(GTNavigationTransitionType)type;
{
    if (self = [super initWithRootViewController:rootViewController]) {
        _transitionDuration = kDefaultTransitionDuration;
        _transitionType = type;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated;
{
    if (animated) {
        [self pushViewController:viewController withTransition:[self transitionForType:self.transitionType]];;
    }else{
        [self pushViewController:viewController withTransition:nil];
    }
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                completion:(GTNavigationControllerCompletionBlock)block;
{
    [self pushViewController:viewController animated:animated];
    if (block) {
        block();
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
{
    if (animated) {
        return  [self popViewController];
    }else{
        return  [self popViewControllerWithTransition:nil];
    }
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated; // Pops view controllers until the one specified is on top. Returns the popped controllers.
{
    if (animated) {
        return [self popToViewController:viewController];
    }else{
        return [self popToViewController:viewController withTransition:nil];
    }
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.
{
    if (animated) {
        return [self popToRootViewController];
    }else{
        return [self popToRootViewControllerWithTransition:nil];
    }
    
}

#pragma mark - Helpers 


- (ADTransition *)transitionForType:(GTNavigationTransitionType)type
{
    ADTransition *transition = nil;
    switch (type) {
        case GTNavigationTransitionTypePush: {
            transition = [[ADModernPushTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];
            break;
        }
        case GTNavigationTransitionTypePushRotate: {
            transition = [[ADPushRotateTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];
            break;
        }
        case GTNavigationTransitionTypeFold: {
            transition = [[ADFoldTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];

            break;
        }
        case GTNavigationTransitionTypeBackFade: {
            transition = [[ADBackFadeTransition alloc] initWithDuration:self.transitionDuration];
            break;
        }
        case GTNavigationTransitionTypeFade: {
            transition = [[ADFadeTransition alloc] initWithDuration:self.transitionDuration];
            break;
        }
        case GTNavigationTransitionTypeSwap: {
            transition = [[ADSwapTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];
            break;
        }
        case GTNavigationTransitionTypeFlip: {
            transition = [[ADFlipTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];
            break;
        }
        case GTNavigationTransitionTypeSwipeFade: {
            transition = [[ADSwipeFadeTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];
            break;
        }
        case GTNavigationTransitionTypeScale: {
            transition = [[ADScaleTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];

            break;
        }
        case GTNavigationTransitionTypeGlue: {
            transition = [[ADGlueTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];

            break;
        }
        case GTNavigationTransitionTypeZoom: {
            CGRect sourceRect = CGRectMake(0, self.view.bounds.size.height/2 - 25, self.view.bounds.size.width, 50);
            transition = [[ADZoomTransition alloc] initWithSourceRect:sourceRect andTargetRect:self.view.frame forDuration:self.transitionDuration];
            break;
        }
        case GTNavigationTransitionTypeGhost: {
            transition = [[ADGhostTransition alloc] initWithDuration:self.transitionDuration];
            break;
        }
        case GTNavigationTransitionTypeSwipe: {
            transition = [[ADSwipeTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];

            break;
        }
        case GTNavigationTransitionTypeSlide: {
            transition = [[ADSlideTransition alloc] initWithDuration:self.transitionDuration
                                                         orientation:self.orientation
                                                          sourceRect:self.view.frame];
            break;
        }
        case GTNavigationTransitionTypeCross: {
            transition = [[ADCrossTransition alloc] initWithDuration:self.transitionDuration];
            break;
        }
        case GTNavigationTransitionTypeCube: {
            transition = [[ADCubeTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];
            break;
        }
        case GTNavigationTransitionTypeCarrousel: {
            transition = [[ADCarrouselTransition alloc] initWithDuration:self.transitionDuration orientation:self.orientation sourceRect:self.view.frame];
            break;
        }
        default: {
            transition = nil;
            break;
        }
    }
    
    return transition;
}




@end
