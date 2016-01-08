//
//  ViewController.m
//  Feed
//
//  Created by Adam on 1/8/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "LoginViewController.h"


NSString * const LoginViewControllerIdentifier = @"LoginViewController";


@interface LoginViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    NSLog(@"%@", [APIClient generateURLForAuthentication].absoluteString);
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[APIClient generateURLForAuthentication]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *URL = request.URL;
    if ([URL.scheme isEqualToString:InstagramRedirectScheme] && [URL.host isEqualToString:InstagramRedirectHost])
    {
        NSString *fragment = URL.fragment;
        [self parseFragment:fragment];
        return NO;
    }
    
    return YES;
}


- (void)parseFragment:(NSString *)fragment
{
    if ([fragment containsString:@"access_token"])
    {
        NSString *accessToken = [[fragment componentsSeparatedByString:@"="] lastObject];
        
        [self.delegate loginViewController:self didLoginWithAccessToken:accessToken];
    }
    
    //[self.delegate loginViewController:self didFailToLoginWithError:fragment];
}

- (void) cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
