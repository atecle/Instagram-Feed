//
//  HomeViewController.m
//  Feed
//
//  Created by Adam on 1/8/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <LoginViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, PostTableCellDelegate>
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) APIClient *client;
@property (copy, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PostTableCell class]) bundle:nil] forCellReuseIdentifier:PostCellIdentifier];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefaults stringForKey:@"accessToken"];
    
    if (accessToken == nil)
    {
        [self showLoginViewController];
    }
    else
    {
        _client = [[APIClient alloc] initWithAccessToken:accessToken];
        [self loadFeed];
    }
    
    self.accessToken = accessToken;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showLoginViewController
{
    LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:LoginViewControllerIdentifier];
    vc.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void) loadFeed
{
    [self.client requestRecentMediaWithSuccess:^(NSArray *posts) {
        
        self.posts = posts;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
- (IBAction)cameraButtonPressed:(id)sender
{
    PhotoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:PhotoViewControllerIdentifier];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (IBAction)tagsButtonPressed:(id)sender
{
    TagSearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:TagSearchViewControllerIdentifier];
    
    [vc setAPIClient:self.client];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)locationsButtonPressed:(id)sender
{
    LocationSearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:LocationSearchViewControllerIdentifier];

    [vc setAPIClient:self.client];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LoginViewControllerDelegate

- (void)loginViewController:(LoginViewController *)loginViewController didLoginWithAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
    _accessToken = accessToken;
    _client = [[APIClient alloc] initWithAccessToken:self.accessToken];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self loadFeed];
    
}

- (void)loginViewController:(LoginViewController *)loginViewController didFailToLoginWithError:(NSString *)error
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PostCellIdentifier];
    
    Post *post = [self.posts objectAtIndex:indexPath.row];
    [cell setPost:post];
    cell.delegate = self;
    
    __weak PostTableCell *weakCell = cell;
    [self.client downloadImageFromURL:post.imageURL withSuccess:^(UIImage *image) {
        __strong PostTableCell *cell = weakCell;
        [cell setPhoto:image forPost: post ];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [self.client downloadImageFromURL:post.avatarURL withSuccess:^(UIImage *image) {
        __strong PostTableCell *cell = weakCell;
        [cell setAvatarPhoto:image forPost:post];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    return cell;
}

#pragma mark - PostTableCellDelegate

- (void)postTableCellDidPressActionButton:(PostTableCell *)cell
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Report", nil) style:UIAlertActionStyleDestructive handler:nil];
    UIAlertAction *facebookShareAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Share To Facebook", nil) style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *tweetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Tweet", nil) style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *copyShareAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Copy Share URL", nil) style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [actionSheet addAction:reportAction];
    [actionSheet addAction:facebookShareAction];
    [actionSheet addAction:tweetAction];
    [actionSheet addAction:copyShareAction];
    [actionSheet addAction:cancelAction];
    

    [self presentViewController:actionSheet animated:YES completion:nil];
}



@end
