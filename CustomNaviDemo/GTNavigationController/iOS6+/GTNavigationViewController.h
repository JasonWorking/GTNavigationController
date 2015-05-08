//
//  GTNavigationViewController.h
//  CustomNaviDemo
//
//  Created by Jason-autonavi on 15/5/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "ADTransitionController.h"
typedef void (^GTNavigationControllerCompletionBlock)(void);

typedef NS_ENUM(NSUInteger, GTNavigationTransitionType) {
    GTNavigationTransitionTypePush = 0,
    GTNavigationTransitionTypePushRotate,
    GTNavigationTransitionTypeFold,
    GTNavigationTransitionTypeBackFade,
    GTNavigationTransitionTypeFade,
    GTNavigationTransitionTypeSwap,
    GTNavigationTransitionTypeFlip,
    GTNavigationTransitionTypeSwipeFade,
    GTNavigationTransitionTypeScale,
    GTNavigationTransitionTypeGlue,
    GTNavigationTransitionTypeZoom,
    GTNavigationTransitionTypeGhost,
    GTNavigationTransitionTypeSwipe,
    GTNavigationTransitionTypeSlide,
    GTNavigationTransitionTypeCross,
    GTNavigationTransitionTypeCube,
    GTNavigationTransitionTypeCarrousel
};


@interface GTNavigationViewController : ADTransitionController

@property (nonatomic, assign) NSTimeInterval transitionDuration;

@property (nonatomic, assign) GTNavigationTransitionType transitionType;


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
                            transitionType:(GTNavigationTransitionType)type;

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated;

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                completion:(GTNavigationControllerCompletionBlock)block;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated; // Pops view controllers until the one specified is on top. Returns the popped controllers.

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.



@end
