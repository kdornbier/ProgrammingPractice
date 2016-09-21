//
//  TourSearchResultsViewController.h
//  Walk Through
//
//  Created by Nate Halbmaier on 3/2/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TourSearchResultsViewController : UIViewController
@property (weak, nonatomic) NSMutableArray *labels;
@property (weak, nonatomic) NSDictionary *tourData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
