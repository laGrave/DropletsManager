//
//  IMLoginViewController.h
//  DropletsManager
//
//  Created by Igor Mishchenko on 31.07.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMLoginViewController;

@protocol IMLoginViewControllerDelegate <NSObject>

- (void)loginVCShouldDismiss:(IMLoginViewController *)loginVC;

@end

@interface IMLoginViewController : UIViewController

@property (nonatomic, weak) id <IMLoginViewControllerDelegate> delegate;

@end
