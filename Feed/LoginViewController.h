//
//  ViewController.h
//  Feed
//
//  Created by Adam on 1/8/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIClient.h"

extern NSString * const LoginViewControllerIdentifier;

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewController:(LoginViewController *)loginViewController didLoginWithAccessToken:(NSString *)accessToken;
- (void)loginViewController:(LoginViewController *)loginViewController didFailToLoginWithError:(NSString *)error;

@end

@interface LoginViewController : UIViewController

@property (weak, nonatomic) id<LoginViewControllerDelegate> delegate;

@end

