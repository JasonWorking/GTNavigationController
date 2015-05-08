//
//  ViewController.m
//  CustomNaviDemo
//
//  Created by Jason-autonavi on 15/5/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "GTDemoViewController.h"
#import "UIViewController+ADTransitionController.h"
#import "GTNavigationViewController.h"
#import "ALSettingsViewController.h"



@interface GTDemoViewController ()<ALSettingsDelegate>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UIButton *pushButton;
@property (nonatomic, strong) UIButton *popToRootButton;

@property (nonatomic, assign) BOOL pushAnimated;
@property (nonatomic, assign) BOOL popAnimated;
@end

@implementation GTDemoViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

    if (![[NSUserDefaults standardUserDefaults] objectForKey:AL_SPEED_KEY]) {
        [self setupDefaultsSettings];
    }
    [self retrieveSettings];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self retrieveSettings];
}

#pragma mark - Setup UI
- (void)setupUI
{
    self.view.backgroundColor = [self randomColor];
    [self setupButtons];
    [self setupBarButtonItems];
}

- (UIColor *)randomColor
{
    int randomInt = arc4random()%4;
    UIColor *color = nil;
    switch (randomInt) {
        case 0:
            color = [UIColor colorWithRed:0.196 green:0.651 blue:0.573 alpha:1.000];
            break;
        case 1:
            color = [UIColor colorWithRed:1.000 green:0.569 blue:0.349 alpha:1.000];
            break;
        case 2:
            color = [UIColor colorWithRed:0.949 green:0.427 blue:0.427 alpha:1.000];
            break;
        case 3:
            color = [UIColor colorWithRed:0.322 green:0.639 blue:0.800 alpha:1.000];
            break;
        default:
            color = UIColor.whiteColor;
            break;
    }
    return color;
}

- (void)setupButtons
{
    [self.view addSubview:self.pushButton];
    [self.view addSubview:self.popToRootButton];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.settingsButton];
}

- (void)setupBarButtonItems {
    if (self.index > 0) {
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 34.0f, 34.0f);
        [backButton setImage:[UIImage imageNamed:@"ALBackButtonOff"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"ALBackButtonOn"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(onBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    
    UIButton * settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(0, 0, 34.0f, 34.0f);
    [settingsButton setImage:[UIImage imageNamed:@"ALSettingsButtonOff"] forState:UIControlStateNormal];
    [settingsButton setImage:[UIImage imageNamed:@"ALSettingsButtonOn"] forState:UIControlStateHighlighted];
    [settingsButton addTarget:self action:@selector(onShowSettingsTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * settingsButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.rightBarButtonItem = settingsButtonItem;
    
    UIBarButtonItem * shareButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onShareTapped:)];
    self.toolbarItems = @[shareButtonItem];
}


#pragma mark - User Interaction

- (void)onPushButtonTapped:(UIButton *)sender
{
    GTDemoViewController *newVC = [GTDemoViewController new];
    [self.gtNavigationController pushViewController:newVC animated:_pushAnimated];
    NSLog(@"Button tapped. ");
}

- (void)onPopToRootTapped:(UIButton *)sender
{
    [self.gtNavigationController popToRootViewControllerAnimated:_popAnimated];
}

- (IBAction)onBackButtonTapped:(id)sender {
    [self.gtNavigationController popViewControllerAnimated:_popAnimated];
}

- (IBAction)onShowSettingsTapped:(id)sender {
    ALSettingsViewController * settingsViewController = [[ALSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)onShareTapped:(id)sender {
    NSString * text = @"I use ADTransitionController by @applidium http://applidium.github.io/";
    UIActivityViewController * activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[text] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}


#pragma mark - Delegate

- (void)settingsViewControllerDidUpdateSettings:(ALSettingsViewController *)settingsViewController {
    [self retrieveSettings];
}

- (BOOL)prefersStatusBarHidden
{
    return ![[[NSUserDefaults standardUserDefaults] objectForKey:AL_NAVIGATION_BAR_HIDDEN_KEY] boolValue];
    
}


#pragma mark - Other methods


- (void)setupDefaultsSettings {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@(0.5f) forKey:AL_SPEED_KEY];
    [defaults setValue:@NO forKey:AL_NAVIGATION_BAR_HIDDEN_KEY];
    [defaults setValue:@YES forKey:AL_TOOLBAR_HIDDEN_KEY];
    [defaults setValue:@(GTNavigationTransitionTypePush) forKey:GT_TRANSITION_TYPE_KEY];
    [defaults setValue:@YES forKey:GT_PUSH_ANIMATED_KEY];
    [defaults setValue:@YES forKey:GT_POP_ANIMATED_KEY];
    [defaults synchronize];
}

- (void)retrieveSettings {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL navigationBarHidden = [[defaults objectForKey:AL_NAVIGATION_BAR_HIDDEN_KEY] boolValue];
    BOOL toolbarHidden = [[defaults objectForKey:AL_TOOLBAR_HIDDEN_KEY] boolValue];
    NSTimeInterval duration = [[defaults objectForKey:AL_SPEED_KEY] floatValue];
    GTNavigationTransitionType type = [[defaults objectForKey:GT_TRANSITION_TYPE_KEY] intValue];
    _pushAnimated = [[defaults objectForKey:GT_PUSH_ANIMATED_KEY] boolValue];
    _popAnimated  = [[defaults objectForKey:GT_POP_ANIMATED_KEY] boolValue];
    
    
    [self.gtNavigationController setTransitionDuration:duration];
    [self.gtNavigationController setTransitionType:type];
    [self.gtNavigationController setNavigationBarHidden:navigationBarHidden];
    [self.gtNavigationController setToolbarHidden:toolbarHidden];
    
    self.backButton.hidden = !navigationBarHidden || self.index == 0;
    [[UIApplication sharedApplication] setStatusBarHidden:navigationBarHidden];
    self.settingsButton.hidden = !navigationBarHidden;
}


#pragma mark - Getter
- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"ALBackButtonOn"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"ALBackButtonOff"] forState:UIControlStateHighlighted];
        _backButton.frame = CGRectMake(4, 28, 34, 34);
        [_backButton addTarget:self action:@selector(onBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)settingsButton
{
    if (!_settingsButton) {
        _settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingsButton setImage:[UIImage imageNamed:@"ALSettingsButtonOn"] forState:UIControlStateNormal];
        [_settingsButton setImage:[UIImage imageNamed:@"ALSettingsButtonOff"] forState:UIControlStateHighlighted];
        _settingsButton.frame = CGRectMake(self.view.bounds.size.width - 34 -4 , 28, 34, 34);
        [_settingsButton addTarget:self action:@selector(onShowSettingsTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingsButton;
}

- (UIButton *)pushButton
{
    if (!_pushButton) {
        CGFloat buttonWidth = 200;
        CGFloat buttonHeight = 50;
        _pushButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _pushButton.frame = CGRectMake(self.view.bounds.size.width/2 - buttonWidth/2 , self.view.bounds.size.height/2 - buttonHeight/2 , buttonWidth, buttonHeight);
        [_pushButton setTitle:@"Tap me to push " forState:UIControlStateNormal];
        [_pushButton addTarget:self action:@selector(onPushButtonTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushButton;
}

- (UIButton *)popToRootButton
{
    if (!_popToRootButton) {
        CGFloat buttonWidth = 200;
        CGFloat buttonHeight = 50;
        _popToRootButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _popToRootButton.frame = CGRectMake(self.view.bounds.size.width/2 - buttonWidth/2 , self.view.bounds.size.height/2 - buttonHeight/2 + buttonHeight , buttonWidth, buttonHeight);
        [_popToRootButton setTitle:@"Pop to root" forState:UIControlStateNormal];
        [_popToRootButton addTarget:self action:@selector(onPopToRootTapped:)
              forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _popToRootButton;
}

- (NSUInteger)index
{
    return [self.gtNavigationController.viewControllers indexOfObject:self];
}



#pragma mark - Setter




@end
