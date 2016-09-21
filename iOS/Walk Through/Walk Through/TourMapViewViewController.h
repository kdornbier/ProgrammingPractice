//
//  TourMapViewViewController.h
//  Walk Through
//
//  Created by Nate Halbmaier on 4/4/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TourMapViewViewController : UIViewController
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *addressString;
@property (strong, nonatomic) NSString *bathroomsString;
@property (strong, nonatomic) NSString *bedroomsString;
@property (strong, nonatomic) NSString *statusString;
@property (strong, nonatomic) NSString *priceString;
@property (strong, nonatomic) NSString *cityString;
@property (strong, nonatomic) NSString *stateString;
@property (strong, nonatomic) NSString *zipString;
@property (strong, nonatomic) NSString *tourId;
@property (strong, nonatomic) NSString *tourString;
@property (strong, nonatomic) NSString *imagesid;
@property (strong, nonatomic) NSString *userid;

@property (strong, nonatomic) NSString *contactName;
@property (strong, nonatomic) NSString *contactEmail;
@property (strong, nonatomic) NSString *contactPhone;

@property (strong, nonatomic) NSData *tour;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@end
