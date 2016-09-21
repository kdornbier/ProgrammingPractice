//
//  FriendSearchResultsViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 4/5/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "FriendSearchResultsViewController.h"
#import "UserViewController.h"

@interface FriendSearchResultsViewController ()

@end

@implementation FriendSearchResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger cellNum = indexPath.row;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.labels objectAtIndex: cellNum]];
	return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.labels count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"detail"]){
        UserViewController *vc = [segue destinationViewController];
        NSArray *json = [self.tourData objectForKey:@"users"];
        NSLog(@"JSON = %@", json);
        NSInteger selectedCellNum = [self.tableView indexPathForSelectedRow].row;
        NSLog(@"Selected Index = %ld", (long)selectedCellNum);
        
        NSDictionary *dict = [json objectAtIndex:selectedCellNum];
        vc.userId = [dict objectForKey:@"id"];
        vc.name = [dict objectForKey:@"name"];
        vc.email = [dict objectForKey:@"email"];
        vc.phone = [dict objectForKey:@"phone"];
        vc.city = [dict objectForKey:@"city"];
        vc.state = [dict objectForKey:@"state"];
    }
}


@end
