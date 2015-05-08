//
//  ALSettingsViewController.m
//  ADTransitionController
//
//  Created by Pierre Felgines on 30/05/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import "ALSettingsViewController.h"
#import "ALSettingsTableViewCell.h"
#import "GTNavigationViewController.h"
@interface ALSettingsViewController () {
    CGFloat _speed;
    GTNavigationTransitionType _type;
    BOOL _navigationBarHidden;
    BOOL _toolbarHidden;
    BOOL _pushAnimated;
    BOOL _popAnimated;
}
@end

@implementation ALSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        _speed = [[defaults objectForKey:AL_SPEED_KEY] floatValue];
        _navigationBarHidden = [[defaults objectForKey:AL_NAVIGATION_BAR_HIDDEN_KEY] boolValue];
        _toolbarHidden = [[defaults objectForKey:AL_TOOLBAR_HIDDEN_KEY] boolValue];
        _type = [[defaults objectForKey:GT_TRANSITION_TYPE_KEY] intValue];
        _pushAnimated = [[defaults objectForKey:GT_PUSH_ANIMATED_KEY] boolValue];
        _popAnimated = [[defaults objectForKey:GT_POP_ANIMATED_KEY] boolValue];
        self.title = @"Settings";
    }
    return self;
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSpeedLabel:nil];
    [self setSlider:nil];
    [self setNavigationBarSwitch:nil];
    [self setScrollView:nil];
    [self setCreditView:nil];
    [self setToolbarSwitch:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slider.value = _speed;
    self.speedLabel.text = [NSString stringWithFormat:@"%.2fs", self.slider.value];
    self.navigationBarSwitch.on = !_navigationBarHidden;
    self.toolbarSwitch.on = !_toolbarHidden;
    self.pushAnimatedSwitch.on = _pushAnimated;
    self.popAnimatedSwitch.on = _popAnimated;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.creditView.frame) + 20.0f);
    
    UIBarButtonItem * doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
}

- (IBAction)toggleNavigationBar:(UISwitch *)sender {
    _navigationBarHidden = !sender.on;
}

- (IBAction)toggleToolbar:(UISwitch *)sender {
    _toolbarHidden = !sender.on;
}
- (IBAction)togglePushAnimated:(UISwitch *)sender {
    _pushAnimated = sender.isOn;
}
- (IBAction)togglePopAnimated:(UISwitch *)sender {
    _popAnimated = sender.isOn;
}

- (IBAction)updateSpeed:(UISlider *)sender {
    _speed = sender.value;
    self.speedLabel.text = [NSString stringWithFormat:@"%.2fs", _speed];
}

- (IBAction)done:(id)sender {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@(_speed) forKey:AL_SPEED_KEY];
    [defaults setValue:@(_type) forKey:GT_TRANSITION_TYPE_KEY];
    [defaults setValue:@(_navigationBarHidden) forKey:AL_NAVIGATION_BAR_HIDDEN_KEY];
    [defaults setValue:@(_toolbarHidden) forKey:AL_TOOLBAR_HIDDEN_KEY];
    [defaults setValue:@(_pushAnimated) forKey:GT_PUSH_ANIMATED_KEY];
    [defaults setValue:@(_popAnimated) forKey:GT_POP_ANIMATED_KEY];
    [defaults synchronize];
    [self.delegate settingsViewControllerDidUpdateSettings:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALSettingsTableViewCell * cell = [ALSettingsTableViewCell newCell];
    
    NSString * text = nil;
    switch (indexPath.row) {
        case GTNavigationTransitionTypePush: {
            text = @"Push";
            break;
        }
        case GTNavigationTransitionTypePushRotate: {
            text = @"PushRotat";

            break;
        }
        case GTNavigationTransitionTypeFold: {
            text = @"Fold";

            
            break;
        }
        case GTNavigationTransitionTypeBackFade: {
            text = @"BackFade";
            break;
        }
        case GTNavigationTransitionTypeFade: {
            text = @"Fade";
            break;
        }
        case GTNavigationTransitionTypeSwap: {
            text = @"Swap";
            break;
        }
        case GTNavigationTransitionTypeFlip: {
            text = @"Flip";
            break;
        }
        case GTNavigationTransitionTypeSwipeFade: {
            text = @"Fade";
            break;
        }
        case GTNavigationTransitionTypeScale: {
            text = @"Scale";
            
            break;
        }
        case GTNavigationTransitionTypeGlue: {
            text = @"Glue";
            
            break;
        }
        case GTNavigationTransitionTypeZoom: {
            text = @"Zoom";
            break;
        }
        case GTNavigationTransitionTypeGhost: {
            text = @"Ghost";
            break;
        }
        case GTNavigationTransitionTypeSwipe: {
            text = @"Swipe";
            
            break;
        }
        case GTNavigationTransitionTypeSlide: {
            text = @"Slide";
            break;
        }
        case GTNavigationTransitionTypeCross: {
            text = @"Cross";
            break;
        }
        case GTNavigationTransitionTypeCube: {
            text = @"Cube";
            break;
        }
        case GTNavigationTransitionTypeCarrousel: {
            text = @"Carrousel";
            break;
        }
        default: {
            text = @"Push";
            break;
        }
    }
    
    cell.orientationLabel.text = text;
    cell.checkImageView.hidden = _type != indexPath.row;
    if (_type == indexPath.row) {
        cell.checkImageView.hidden = NO;
        cell.orientationLabel.textColor = [UIColor colorWithRed:0.000 green:0.498 blue:0.918 alpha:1.0f];
    } else {
        cell.checkImageView.hidden = YES;
        cell.orientationLabel.textColor = [UIColor colorWithRed:0.133 green:0.118 blue:0.149 alpha:1.0f];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _type = indexPath.row;
    [self.tableView reloadData];
}

@end
