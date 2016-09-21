//
//  MyTourDetailViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 4/7/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "MyTourDetailViewController.h"
#import "TakeTourViewController.h"

@interface MyTourDetailViewController ()
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
@end

@implementation MyTourDetailViewController

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
//            NSLog(@"id = %@", [results objectForKey:@"id"]);
//            NSLog(@"view0_image0 = %@", [results objectForKey:@"view0_image0"]);
//            NSLog(@"view0_image1 = %@", [results objectForKey:@"view0_image1"]);
//            NSLog(@"view0_image2 = %@", [results objectForKey:@"view0_image2"]);
//            NSLog(@"view0_image3 = %@", [results objectForKey:@"view0_image3"]);
//            
//            NSLog(@"view1_image0 = %@", [results objectForKey:@"view1_image0"]);
//            NSLog(@"view1_image1 = %@", [results objectForKey:@"view1_image1"]);
//            NSLog(@"view1_image2 = %@", [results objectForKey:@"view1_image2"]);
//            NSLog(@"view1_image3 = %@", [results objectForKey:@"view1_image3"]);
//            NSLog(@"jumpIndex = %@", [results objectForKey:@"jumpIndex"]);
            
            //Call Kaitlyn's Code Here and send the above info!
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"PrepareForSegue");
    if([segue.identifier isEqualToString:@"viewtour"]){
        [self viewTour];
        TakeTourViewController *controller = [segue destinationViewController];
        controller.results = self.passingResults;
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
