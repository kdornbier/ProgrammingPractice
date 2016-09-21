//
//  TourSearchResultsViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 3/2/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "TourSearchResultsViewController.h"
#import "TourMapViewViewController.h"

@interface TourSearchResultsViewController ()

@end

@implementation TourSearchResultsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"detail"]){
        TourMapViewViewController *vc = [segue destinationViewController];
        NSArray *json = [self.tourData objectForKey:@"tours"];
        NSLog(@"%@", json);
        NSInteger selectedCellNum = [self.tableView indexPathForSelectedRow].row;
        NSDictionary *dict = [json objectAtIndex:selectedCellNum];
        vc.bathroomsString = [dict objectForKey:@"bathrooms"];
        vc.bedroomsString = [dict objectForKey:@"bedrooms"];
        vc.priceString = [dict objectForKey:@"price"];
        vc.statusString =[dict objectForKey:@"status"];
        vc.cityString =[dict objectForKey:@"city"];
        vc.stateString =[dict objectForKey:@"state"];
        vc.addressString = [dict objectForKey:@"address"];
        vc.tourId = [dict objectForKey:@"tourid"];
        vc.imagesid = [dict objectForKey:@"imagesid"];
        vc.userid = [dict objectForKey:@"userid"];
        vc.zipString =[dict objectForKey:@"zipcode"];
        vc.address = [self.labels objectAtIndex:selectedCellNum];
    }
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


@end
