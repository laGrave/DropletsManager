//
//  IMSettingsViewController.h
//  DropletsManager
//
//  Created by Igor Mishchenko on 31.07.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMSettingsViewController;

@protocol IMSettingsViewControllerDelegate <NSObject>

- (void)SettingsVCShouldDismiss:(IMSettingsViewController *)SettingsVC;

@end

@interface IMSettingsViewController : UIViewController

@property (nonatomic, weak) id <IMSettingsViewControllerDelegate> delegate;

@end
