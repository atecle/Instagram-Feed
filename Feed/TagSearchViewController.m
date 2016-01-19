//
//  TagSearchViewController.m
//  Feed
//
//  Created by Adam on 1/12/16.
//  Copyright © 2016 ;. All rights reserved.
//

#import "TagSearchViewController.h"

NSString * const TagSearchViewControllerIdentifier = @"TagSearchViewController";

@interface TagSearchViewController () <UITableViewDataSource, UITableViewDelegate, PostTableCellDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *posts;
@property (strong, nonatomic) APIClient *client;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation TagSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = NSLocalizedString(@"Tags", nil);

    
    self.posts = @[];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PostTableCell class]) bundle: nil] forCellReuseIdentifier:PostCellIdentifier];
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAPIClient:(APIClient *)client
{
    self.client = client;
}

- (void)searchForTag:(NSString *)tag
{
    
    if (tag.length == 0)
    {
        self.posts = @[];
        [self.tableView reloadData];
        return;
    }
    
    [self.dataTask cancel];
    __weak TagSearchViewController *weakSelf = self;
    self.dataTask = [self.client requestRecentlyTaggedMedia:tag withSuccess:^(NSArray *feedEntries) {
        __strong TagSearchViewController *strongSelf = weakSelf;
        strongSelf.posts = feedEntries;
        [strongSelf.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)searchTimerFired:(NSTimer *)timer
{
    NSString *tag = timer.userInfo;
    [self searchForTag:tag];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(searchTimerFired:) userInfo:searchBar.text repeats:NO];
}


@end
