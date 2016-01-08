//
//  HomeViewController.m
//  Feed
//
//  Created by Adam on 1/8/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <LoginViewControllerDelegate>
@property (strong, nonatomic) NSString *accessToken;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefaults stringForKey:@"accessToken"];
    
    if (accessToken == nil)
    {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:LoginViewControllerIdentifier];
        vc.delegate = self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
    self.accessToken = accessToken;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginViewController:(LoginViewController *)loginViewController didLoginWithAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
    self.accessToken = accessToken;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)loginViewController:(LoginViewController *)loginViewController didFailToLoginWithError:(NSString *)error
{
    
}

@end
