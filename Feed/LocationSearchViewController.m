//
//  LocationSearchViewController.m
//  Feed
//
//  Created by Adam on 1/12/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "LocationSearchViewController.h"

NSString * const LocationSearchViewControllerIdentifier = @"LocationSearchViewController";

@interface LocationSearchViewController () <UITableViewDataSource, UITableViewDelegate, PostTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *posts;
@property (strong, nonatomic) APIClient *client;

@end

@implementation LocationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PostTableCell class]) bundle:nil] forCellReuseIdentifier:PostCellIdentifier];
    
    [self loadFeed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAPIClient:(APIClient *)client
{
    _client = client;
}

- (void)loadFeed
{
    
    [self.tableView reloadData];
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
