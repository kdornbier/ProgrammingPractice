//
//  FriendSearchResultsViewController.h
//  Walk Through
//
//  Created by Nate Halbmaier on 4/5/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendSearchResultsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSDictionary *tourData;
@property (weak, nonatomic) NSMutableArray *labels;


@end
