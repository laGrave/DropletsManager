//
//  IMWebViewController.h
//  DropletsManager
//
//  Created by Igor Mishchenko on 09.09.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMWebViewControllerDelegate <NSObject>

- (void)webVewControllerDidFetchParams:(NSDictionary *)params;

@end

@interface IMWebViewController : UIViewController

@property (nonatomic, weak) id <IMWebViewControllerDelegate> delegate;

@end
