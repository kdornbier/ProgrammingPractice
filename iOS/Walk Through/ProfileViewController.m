//
//  ProfileViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 2/15/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "Walk_ThroughAppDelegate.h"
#import "TourSearchResultsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SpinnerView.h"
#import "FriendSearchResultsViewController.h"
#import "MyTourResultsViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic) BOOL viewLoaded;
@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) NSMutableArray *bathrooms;
@property (strong, nonatomic) NSMutableArray *bedrooms;
@property (strong, nonatomic) NSMutableArray *priceRange;
@property (strong, nonatomic) NSMutableArray *status;
@property (strong, nonatomic) NSDictionary *dictionary;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ProfileManagement* profile = [ProfileManagement getInstance];
    self.nameLabel.text = [NSString stringWithFormat:@"Name: %@" , profile.name];
    if(![profile.email isEqualToString:@"(null)"])
        self.emailLabel.text = [NSString stringWithFormat:@"Email: %@" , profile.email];
    self.phoneLabel.text = [NSString stringWithFormat:@"Phone: %@", profile.phone];
    self.stateLabel.text = [NSString stringWithFormat:@"State: %@", profile.state];
    self.cityLabel.text = [NSString stringWithFormat:@"City: %@", profile.city];
}
- (IBAction)testLoadingScreen {
    
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
 
}

-(void)viewDidAppear:(BOOL)animated{
    [self viewDidLoad];
}
- (void)searchPressed {
    NSString *url = @"http://walkthrough.dellspergerdevelopment.com/scripts/search.php";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    //NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //NSLog(@" %@", string);
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
            
            NSMutableArray *labelArray = [[NSMutableArray alloc] init];
            NSMutableArray *bathroomArray = [[NSMutableArray alloc] init];
            NSMutableArray *bedroomArray = [[NSMutableArray alloc] init];
            NSMutableArray *priceArray = [[NSMutableArray alloc] init];
            NSMutableArray *statusArray = [[NSMutableArray alloc] init];
    
            NSDictionary *results = object;
            NSArray *json = [results objectForKey:@"tours"];
            self.dictionary = results;
            for(NSDictionary *dict in json){
                //NSLog(@"sub dictionary = %@", dict);
                
                [labelArray addObject:[NSString stringWithFormat:@" %@ %@, %@ %@", [dict objectForKey:@"address"], [dict objectForKey:@"city"],[dict objectForKey:@"state"], [dict objectForKey:@"zipcode"]]];
                [bathroomArray addObject:[dict objectForKey:@"bathrooms"]];
                [bedroomArray addObject:[dict objectForKey:@"bedrooms"]];
                [priceArray addObject:[dict objectForKey:@"price"]];
                [statusArray addObject:[dict objectForKey:@"status"]];
            }
            
            self.labels = labelArray;
            self.bathrooms = bathroomArray;
            self.bedrooms = bedroomArray;
            self.priceRange = priceArray;
            self.status = statusArray;
        }
        else{
            NSLog(@"Array");
        }
    }
    else{
        //ERROR
    }
    
}

- (void)friendSearchPressed {
    
    NSString *url = [NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/friend_search.php"];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    //NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
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
            
            NSMutableArray *labelArray = [[NSMutableArray alloc] init];
            //NSLog(@"DICTIONARY");
            NSDictionary *results = object;
            NSArray *json = [results objectForKey:@"users"];
            self.dictionary = results;
            for(NSDictionary *dict in json){
                [labelArray addObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]]];
            }
            
            self.labels = labelArray;
        }
        else{
            NSLog(@"Array");
        }
    }
    else{
        //ERROR
    }

}

-(void)myToursRequest{
    ProfileManagement* profile = [ProfileManagement getInstance];
    NSString *url = [NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/my_tour_search.php?id=%d", profile.uniqueId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@" %@", string);
    
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
            
            NSMutableArray *labelArray = [[NSMutableArray alloc] init];

            //NSLog(@"DICTIONARY");
            NSDictionary *results = object;
            NSArray *json = [results objectForKey:@"tours"];
            self.dictionary = results;
            for(NSDictionary *dict in json){
                //NSLog(@"sub dictionary = %@", dict);
                
                [labelArray addObject:[NSString stringWithFormat:@" %@ %@, %@ %@", [dict objectForKey:@"address"], [dict objectForKey:@"city"],[dict objectForKey:@"state"], [dict objectForKey:@"zipcode"]]];
            }
            
            self.labels = labelArray;

        }
        else{
            NSLog(@"Array");
        }
    }
    else{
        //ERROR
    }
    

    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"logout"]){
        [FBSession.activeSession closeAndClearTokenInformation];
        ProfileManagement* profile = [ProfileManagement getInstance];
        [profile resetVariables];
    }
    else if([segue.identifier isEqualToString:@"search"]){
        [self searchPressed];
        
        UINavigationController *segNav = [segue destinationViewController];
        TourSearchResultsViewController *vc =[segNav topViewController];
        vc.labels = self.labels;
        vc.tourData = self.dictionary;
    }else if([segue.identifier isEqualToString:@"friendSearch"]){
        [self friendSearchPressed];
        
        UINavigationController *segNav = [segue destinationViewController];
        FriendSearchResultsViewController *vc =[segNav topViewController];
        vc.labels = self.labels;
        vc.tourData = self.dictionary;
    }else if([segue.identifier isEqualToString:@"myTours"]){
        [self myToursRequest];
        
        UINavigationController *segNav = [segue destinationViewController];
        MyTourResultsViewController *vc =[segNav topViewController];
        vc.labels = self.labels;
        vc.tourData = self.dictionary;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
