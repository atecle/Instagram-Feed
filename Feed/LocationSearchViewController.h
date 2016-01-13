//
//  LocationSearchViewController.h
//  Feed
//
//  Created by Adam on 1/12/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Post.h"
#import "PostTableCell.h"
#import "APIClient.h"
#import "LocationGETOperation.h"
#import "MediaFromLocationGETOperation.h"

extern NSString * const LocationSearchViewControllerIdentifier;

@interface LocationSearchViewController : UIViewController

- (void)setAPIClient:(APIClient *)client;

@end
