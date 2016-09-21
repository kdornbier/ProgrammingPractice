//
//  TourMapViewViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 4/4/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "TourMapViewViewController.h"
#import "ContactOwnerViewController.h"
#import "TakeTourViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface TourMapViewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedroomsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bathroomLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) NSDictionary *passingResults;

@property (strong, nonatomic) NSString *myAddress;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation TourMapViewViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.addressLabel.text = [NSString stringWithFormat:@"Address: %@", self.addressString];
    self.cityLabel.text = [NSString stringWithFormat:@"City: %@", self.cityString];
    self.stateLabel.text = [NSString stringWithFormat:@"State: %@", self.stateString];
    self.bedroomsLabel.text = [NSString stringWithFormat:@"Bedrooms: %@", self.bedroomsString];
    self.bathroomLabel.text = [NSString stringWithFormat:@"Bathrooms: %@", self.bathroomsString];
    self.priceRangeLabel.text = [NSString stringWithFormat:@"Price Range: %@", self.priceString];
    self.statusLabel.text = [NSString stringWithFormat:@"Status: %@", self.statusString];
    [self setMapLocation];
}
- (void)viewTour {
    
    
    //NSLog(@"Tour size = %lu", sizeof(self.tour));
    //Virtual_Tour *virtualTour = [NSKeyedUnarchiver unarchiveObjectWithData:self.tour];
    
    NSString *url = [NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/view_tour.php?id=%@", self.imagesid];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    //    NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@", string);
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:response
                     options:0
                     error:&error];
        
        if(error) { NSLog(@"ERROR With JSON"); }
        
        if([object isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"DICTIONARY");
            NSDictionary *results = object;
            self.passingResults = results;
        }
        else{
            NSLog(@"Array");
        }
    }
    else{
        //ERROR
    }
    NSLog(@"Done");
}

-(void)addLoadingScreen{
    UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
    loading.layer.cornerRadius = 15;
    loading.opaque = NO;
    loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 81, 22)];
    loadLabel.text = @"Loading";
    loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    loadLabel.textAlignment = NSTextAlignmentCenter;
    loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    loadLabel.backgroundColor = [UIColor clearColor];
    [loading addSubview:loadLabel];
    UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinning.frame = CGRectMake(42, 54, 37, 37);
    [spinning startAnimating];
    [loading addSubview:spinning];
    loading.frame = CGRectMake(100, 200, 120, 120);
    [self.view addSubview:loading];
    [self viewTour];
}


- (IBAction)getDirections:(id)sender {
    NSString* endAddres = self.address;
    
    endAddres =  [endAddres stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];

    [self getAddressFromCoordinates];
    
}

-(void)getAddressFromCoordinates{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    
    float latitude = self.locationManager.location.coordinate.latitude;
    float longitude = self.locationManager.location.coordinate.longitude;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude]; //insert your coordinates
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];

         self.myAddress = locatedAt;
         self.address = [NSString stringWithFormat:@"%@, %@, %@ %@, United States", self.addressString, self.cityString, self.stateString, self.zipString];
         
         NSString* urlText = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&saddr=%@", self.address, self.myAddress];
         NSString *escaped = [urlText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];

     }
     ];
}

- (IBAction)contactPressed {
    NSString *url = [NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/contact_owner.php?userid=%@", self.userid];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:response
                     options:0
                     error:&error];
        
        if(error) { NSLog(@"ERROR With JSON"); }
        
        if([object isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"DICTIONARY");
            NSDictionary *results = object;
            self.contactName = [results objectForKey:@"name"];
            self.contactEmail = [results objectForKey:@"email"];
            self.contactPhone = [results objectForKey:@"phone"];
            
        }
        else{
            NSLog(@"Array");
        }
    }
    else{
        //ERROR
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"contact"]){
        ContactOwnerViewController *vc = [segue destinationViewController];
        vc.userId = self.userid;
        vc.name = self.contactName;
        vc.email = self.contactEmail;
        vc.phone = self.contactPhone;
    } else if([segue.identifier isEqualToString:@"viewtour"]){
        //[self addLoadingScreen];
        [self viewTour];
        TakeTourViewController *controller = [segue destinationViewController];
        controller.results = self.passingResults;
    }
}

-(void)setMapLocation{
    //NSString *location = @"278 East Court Street Iowa City, Iowa 52240";
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = self.map.region;
                         region.center = [(CLCircularRegion *)placemark.region center];
                         region.span.longitudeDelta /= 100000.0;
                         region.span.latitudeDelta /= 100000.0;
                         self.map.mapType = MKMapTypeHybrid;
                         [self.map setRegion:region animated:YES];
                         [self.map addAnnotation:placemark];
                     }
                 }
     ];
}
@end
