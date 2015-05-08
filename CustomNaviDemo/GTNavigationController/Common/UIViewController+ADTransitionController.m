//
//  UIViewController+ADTransitionController.m
//  Transition
//
//  Created by Romain Goyet on 22/02/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "UIViewController+ADTransitionController.h"
#import "GTNavigationViewController.h"
#import <objc/runtime.h>

extern NSString * ADTransitionControllerAssociationKey;

@implementation UIViewController (ADTransitionController)

- (ADTransitionController *)transitionController {
    return (ADTransitionController *)objc_getAssociatedObject(self, (__bridge const void *)(ADTransitionControllerAssociationKey));
}

- (GTNavigationViewController *)gtNavigationController
{
    GTNavigationViewController *navi = nil;
    ADTransitionController *transitionCotroller = [self transitionController];
    if (transitionCotroller && [transitionCotroller isKindOfClass:[GTNavigationViewController class]]) {
        navi = (GTNavigationViewController *)self.transitionController;
    }
    return navi;
}

@end
