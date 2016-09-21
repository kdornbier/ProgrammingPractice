//
//  TourInfoViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 2/24/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "TourInfoViewController.h"
#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SpinnerView.h"

@interface TourInfoViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *bedroomsField;
@property (weak, nonatomic) IBOutlet UITextField *bathroomsField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegmentControl;
@property (strong,nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) NSMutableArray *salePriceData;
@property (strong, nonatomic) NSMutableArray *rentPriceData;
@property (strong, nonatomic) NSMutableArray *bedroomData;
@property (strong, nonatomic) NSMutableArray *bathroomData;
@property (strong, nonatomic) NSMutableArray *states;

@property (weak, nonatomic) UITextField *lastEditedField;
@property (weak, nonatomic) NSString *dataToUse;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedroomsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bathroomsLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic) BOOL tourIdReturned;

@property (nonatomic) int viewPointIndex;
@property (nonatomic) int imageIndex;
@property (nonatomic) int jumpToIndex;

@property (nonatomic) int totalImages;
@property (nonatomic) int count;

@property (strong, nonatomic) NSMutableArray *imagePaths;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) SpinnerView * spinner;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation TourInfoViewController

- (NSMutableArray *)states {
    if (_states == nil)
		_states = [[NSMutableArray alloc] init];
    return _states;
}
- (NSMutableArray *)salePriceData {
    if (_salePriceData == nil)
		_salePriceData = [[NSMutableArray alloc] init];
    return _salePriceData;
}
- (NSMutableArray *)rentPriceData {
    if (_rentPriceData == nil)
		_rentPriceData = [[NSMutableArray alloc] init];
    return _rentPriceData;
}
- (NSMutableArray *)bedroomData {
    if (_bedroomData == nil)
		_bedroomData = [[NSMutableArray alloc] init];
    return _bedroomData;
}
- (NSMutableArray *)bathroomData {
    if (_bathroomData == nil)
		_bathroomData = [[NSMutableArray alloc] init];
    return _bathroomData;
}
- (NSMutableArray *)imagePaths {
    if (_imagePaths == nil)
		_imagePaths = [[NSMutableArray alloc] init];
    return _imagePaths;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *response = [[NSString alloc] initWithData:self.responseData encoding:NSASCIIStringEncoding];
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:0
                     error:&error];
        
        if(error) { NSLog(@"ERROR With JSON"); }
        
        if([object isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"DICTIONARY");
            NSDictionary *results = object;
            NSLog(@"Message = %@", [results objectForKey:@"message"]);
            NSLog(@"Filepath = %@", [results objectForKey:@"file_path"]);
            
            [self.imagePaths addObject:[results objectForKey:@"file_path"]];
            [self uploadImage];
        }
        else{
            NSLog(@"Array");
        }
    }
    else{
        //ERROR
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@", error);
}

- (IBAction)segmentControlChange:(id)sender {
    self.priceField.text = @"";
    [self.picker reloadAllComponents];
}

- (IBAction)saveTourData {
    self.tourIdReturned = NO;
    self.picker.hidden = YES;
    
    self.viewPointIndex = 0;
    self.imageIndex = 0;
    if([self.addressField.text isEqualToString:@""] || [self.cityField.text isEqualToString:@""] ||
       [self.stateField.text isEqualToString:@""]   || [self.zipCodeField.text isEqualToString:@""] ||
       [self.priceField.text isEqualToString:@""]   ||
       [self.bedroomsField.text isEqualToString:@""]|| [self.bathroomsField.text isEqualToString:@""]){
        
        if([self.addressField.text isEqualToString:@""]){
            self.addressLabel.textColor = [UIColor redColor];
        }else{
            self.addressLabel.textColor = [UIColor blackColor];
        }
        
        if([self.cityField.text isEqualToString:@""]){
            self.cityLabel.textColor = [UIColor redColor];
        }else{
            self.cityLabel.textColor = [UIColor blackColor];
        }
        
        if([self.stateField.text isEqualToString:@""]){
            self.stateLabel.textColor = [UIColor redColor];
        }else{
            self.stateLabel.textColor = [UIColor blackColor];
        }
        
        if([self.zipCodeField.text isEqualToString:@""]){
            self.zipLabel.textColor = [UIColor redColor];
        }else{
            self.zipLabel.textColor = [UIColor blackColor];
        }
        
        if([self.priceField.text isEqualToString:@""]){
            self.priceLabel.textColor = [UIColor redColor];
        }else{
            self.priceLabel.textColor = [UIColor blackColor];
        }
        
        if([self.bedroomsField.text isEqualToString:@""]){
            self.bedroomsLabel.textColor = [UIColor redColor];
        }else{
            self.bedroomsLabel.textColor = [UIColor blackColor];
        }
        
        if([self.bathroomsField.text isEqualToString:@""]){
            self.bathroomsLabel.textColor = [UIColor redColor];
        }else{
            self.bathroomsLabel.textColor = [UIColor blackColor];
        }
        
        self.errorLabel.text = @"Please fill in all required fields";
    }else{
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //Loading Screen set up
//        self.spinner = [SpinnerView loadSpinnerIntoView:self.view];
//    });
    
        NSMutableArray *viewPointArray = self.tour.viewPointArray;
        Virtual_TourViewpoint *view = [viewPointArray objectAtIndex:0];
        self.jumpToIndex = view.jumpIndex;
    

        /*
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        self.indicator.center = self.view.center;
        self.indicator.color = [UIColor blackColor];
        [self.view addSubview:self.indicator];
        [self.indicator bringSubviewToFront:self.view];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
        [self.indicator startAnimating];
         */
        
        //Disable TextFields
        self.addressField.enabled = NO;
        self.cityField.enabled = NO;
        self.stateField.enabled = NO;
        self.zipCodeField.enabled = NO;
        self.priceField.enabled = NO;
        self.bedroomsField.enabled = NO;
        self.bathroomsField.enabled = NO;
        self.SaveButton.enabled  = NO;
        self.statusSegmentControl.enabled = NO;

        //Add Loading SubView
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

        
        //Start Upload Process
        [self uploadImage];
    
    }
}

-(void)simulateconnection{
    [self uploadImage];
}

-(void)uploadImage{
    NSLog(@"Upload Image");
    
    NSMutableArray *viewPointArray = self.tour.viewPointArray;
    for(int i=0; i<[viewPointArray count]; i++){
        Virtual_TourViewpoint * view = [viewPointArray objectAtIndex:i];
        for(int j=0; j<[view.imageArray count]; j++){
            
            UIImage *image = [view.imageArray objectAtIndex:j];
            NSString *fileName = [NSString stringWithFormat:@"image_%d_%d.jpg",i,j];
            
            NSLog(@"Filename = %@", fileName);
            
            NSData *imageData = UIImageJPEGRepresentation(image, 90);
            NSString *urlString = @"http://walkthrough.dellspergerdevelopment.com/scripts/uploadImage.php";
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *contentDispo = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", fileName];
            
            [body appendData:[contentDispo dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPBody:body];
            
            //NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
            //[connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            //[connection start];
            NSURLResponse *response;
            NSError *error;
            //send it synchronous
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            //NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
            
            if(NSClassFromString(@"NSJSONSerialization"))
            {
                NSError *error = nil;
                id object = [NSJSONSerialization
                             JSONObjectWithData:responseData
                             options:0
                             error:&error];
                
                if(error) { NSLog(@"ERROR With JSON"); }
                
                if([object isKindOfClass:[NSDictionary class]])
                {
                    //NSLog(@"DICTIONARY");
                    NSDictionary *results = object;
                    NSLog(@"Message = %@", [results objectForKey:@"message"]);
                    NSLog(@"Filepath = %@", [results objectForKey:@"file_path"]);
                    
                    [self.imagePaths addObject:[results objectForKey:@"file_path"]];
                    
                    //[self uploadImage];
                }
                else{
                    NSLog(@"Array");
                }
            }
            else{
                //ERROR
            }
        }
    }
    
    NSString *view0image0 = @"null";
    NSString *view0image1 = @"null";
    NSString *view0image2 = @"null";
    NSString *view0image3 = @"null";
    NSString *view1image0 = @"null";
    NSString *view1image1 = @"null";
    NSString *view1image2 = @"null";
    NSString *view1image3 = @"null";
    
    Virtual_TourViewpoint * view = [viewPointArray objectAtIndex:0];
    int count = 0;
    if(viewPointArray.count > 0 && view.imageArray.count > 0 )
    {
        view0image0 = [self.imagePaths objectAtIndex:count];
        count++;
    }
    if(viewPointArray.count > 0 && view.imageArray.count > 1 )
    {
        view0image1 = [self.imagePaths objectAtIndex:count];
        count++;
    }
    if(viewPointArray.count > 0 && view.imageArray.count > 2 )
    {
        view0image2 = [self.imagePaths objectAtIndex:count];
        count++;
    }
    if(viewPointArray.count > 0 && view.imageArray.count > 3 )
    {
        view0image3 = [self.imagePaths objectAtIndex:count];
        count++;
    }
    
    if(viewPointArray.count > 1) view = [viewPointArray objectAtIndex:1];
    
    if(viewPointArray.count > 1 && view.imageArray.count > 0 )
    {
        view1image0 = [self.imagePaths objectAtIndex:count];
        count++;
    }
    if(viewPointArray.count > 1 && view.imageArray.count > 1 )
    {
        view1image1 = [self.imagePaths objectAtIndex:count];
        count++;
    }
    if(viewPointArray.count > 1 && view.imageArray.count > 2 )
    {
        view1image2 = [self.imagePaths objectAtIndex:count];
        count++;
    }
    if(viewPointArray.count > 1 && view.imageArray.count > 3 )
    {
        view1image3 = [self.imagePaths objectAtIndex:count];
        count++;
    }
    
    NSLog(@"Inserting Image Paths");
    //Insert Image Paths and such
    NSString *post = [NSString stringWithFormat:@"&view0image0=%@&view0image1=%@&view0image2=%@&view0image3=%@&view1image0=%@&view1image1=%@&view1image2=%@&view1image3=%@&jumpIndex=%d", view0image0,
                      view0image1,view0image2,view0image3,view1image0,view1image1,view1image2,view1image3, self.jumpToIndex];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",postData.length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/insert_image_paths.php"]]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    //send it synchronous
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // check for an error. If there is a network error, you should handle it here.
    if(!error)
    {
        ProfileManagement* profile = [ProfileManagement getInstance];
        NSString *image_row_id = responseString;
        //NSLog(@"Response from server = %@", responseString);
        //Insert only tour information
        NSString *post = [NSString stringWithFormat:@"&address=%@&city=%@&state=%@&zipcode=%@&price=%@&bedrooms=%@&bathrooms=%@&status=%@&imagesid=%@&userid=%d", self.addressField.text, self.cityField.text, self.stateField.text, self.zipCodeField.text, self.priceField.text, self.bedroomsField.text, self.bathroomsField.text, [self.statusSegmentControl titleForSegmentAtIndex:self.statusSegmentControl.selectedSegmentIndex], image_row_id, profile.uniqueId];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu",postData.length];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/insert_tour_info.php"]]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLResponse *response;
        NSError *error;
        //send it synchronous
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        // check for an error. If there is a network error, you should handle it here.
        if(!error)
        {
            NSLog(@"Response from server = %@", responseString);
            NSLog(@"HOLY SHIT WE HAVE A SUCCESSS");
            
            //Remove Spinner Loading
            //[self.spinner removeSpinner];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
            [self.indicator stopAnimating];
            
            
            ProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
            [self presentViewController:profileView animated:YES completion:Nil];
            
        }else{
            NSLog(@"Network Error");
        }
        
    }else{
        NSLog(@"Network Error");
    }
    
    //Disable TextFields, Buttons, and StatusSegment
    self.addressField.enabled = YES;
    self.cityField.enabled = YES;
    self.stateField.enabled = YES;
    self.zipCodeField.enabled = YES;
    self.priceField.enabled = YES;
    self.bedroomsField.enabled = YES;
    self.bathroomsField.enabled = YES;
    self.SaveButton.enabled  = YES;
    self.statusSegmentControl.enabled = YES;
    
}


/*
-(void)uploadImage{
    if(self.viewPointIndex < 2){
        if(self.imageIndex < 4){
            ProfileManagement* profile = [ProfileManagement getInstance];
            NSLog(@"User ID = %d", profile.uniqueId);
             //NSLog(@"View Point Index = %d", self.viewPointIndex);
             //NSLog(@"Image Index = %d", self.imageIndex);
            NSMutableArray *viewPointArray = self.tour.viewPointArray;
            Virtual_TourViewpoint *view = [viewPointArray objectAtIndex:self.viewPointIndex];
            UIImage *image = [view.imageArray objectAtIndex:self.imageIndex];
            NSString *fileName = [NSString stringWithFormat:@"image_%lu_%lu.jpg", [viewPointArray indexOfObject:view],[view.imageArray indexOfObject:image]];
            
            //NSLog(@"Filename = %@", fileName);
            
            NSData *imageData = UIImageJPEGRepresentation(image, 90);
                        NSString *urlString = @"http://walkthrough.dellspergerdevelopment.com/scripts/uploadImage.php";
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *contentDispo = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", fileName];
            
            [body appendData:[contentDispo dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPBody:body];
            
            NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
            [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [connection start];

            self.count = self.count + 1;
            float percentage = (100 * self.count)/self.totalImages;
            [self.progressView setProgress:percentage];

            self.imageIndex = self.imageIndex + 1;
        }else{
            //NSLog(@"Else");
            self.imageIndex = 0;
            self.viewPointIndex = self.viewPointIndex + 1;
            [self uploadImage];
        }
    }else{
        NSLog(@"Inserting Image Paths");
        //Insert Image Paths and such
        NSString *post = [NSString stringWithFormat:@"&view0image0=%@&view0image1=%@&view0image2=%@&view0image3=%@&view1image0=%@&view1image1=%@&view1image2=%@&view1image3=%@&jumpIndex=%d", [self.imagePaths objectAtIndex:0],
            [self.imagePaths objectAtIndex:1],[self.imagePaths objectAtIndex:2],[self.imagePaths objectAtIndex:3],[self.imagePaths objectAtIndex:4],[self.imagePaths objectAtIndex:5],[self.imagePaths objectAtIndex:6],[self.imagePaths objectAtIndex:7], self.jumpToIndex];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu",postData.length];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/insert_image_paths.php"]]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];

        NSURLResponse *response;
        NSError *error;
        //send it synchronous
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        // check for an error. If there is a network error, you should handle it here.
        if(!error)
        {
            ProfileManagement* profile = [ProfileManagement getInstance];
            NSString *image_row_id = responseString;
            //NSLog(@"Response from server = %@", responseString);
            //Insert only tour information
            NSString *post = [NSString stringWithFormat:@"&address=%@&city=%@&state=%@&zipcode=%@&price=%@&bedrooms=%@&bathrooms=%@&status=%@&imagesid=%@&userid=%d", self.addressField.text, self.cityField.text, self.stateField.text, self.zipCodeField.text, self.priceField.text, self.bedroomsField.text, self.bathroomsField.text, [self.statusSegmentControl titleForSegmentAtIndex:self.statusSegmentControl.selectedSegmentIndex], image_row_id, profile.uniqueId];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu",postData.length];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/insert_tour_info.php"]]];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            NSURLResponse *response;
            NSError *error;
            //send it synchronous
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            // check for an error. If there is a network error, you should handle it here.
            if(!error)
            {
                NSLog(@"Response from server = %@", responseString);
                NSLog(@"HOLY SHIT WE HAVE A SUCCESSS");
                
                //Remove Spinner Loading
                //[self.spinner removeSpinner];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
                [self.indicator stopAnimating];
                
                
                ProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
                [self presentViewController:profileView animated:YES completion:Nil];

            }else{
                NSLog(@"Network Error");
            }
            
        }else{
            NSLog(@"Network Error");
        }
    }
    
    //Disable TextFields, Buttons, and StatusSegment
    self.addressField.enabled = YES;
    self.cityField.enabled = YES;
    self.stateField.enabled = YES;
    self.zipCodeField.enabled = YES;
    self.priceField.enabled = YES;
    self.bedroomsField.enabled = YES;
    self.bathroomsField.enabled = YES;
    self.SaveButton.enabled  = YES;
    self.statusSegmentControl.enabled = YES;
}
*/
#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC

// Make sure you are the text fields 'delegate', then this will get called before text gets changed.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // This will be the character set of characters I do not want in my text field.  Then if the replacement string contains any of the characters, return NO so that the text does not change.
    NSCharacterSet *unacceptedInput = nil;
    
    if (textField == self.addressField){
        NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet characterSetWithCharactersInString:ALPHA_NUMERIC];
        [charactersToKeep addCharactersInString:@" "];
        unacceptedInput = [charactersToKeep invertedSet];
    }else if(textField == self.cityField){
        NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet characterSetWithCharactersInString:ALPHA];
        [charactersToKeep addCharactersInString:@" "];
        unacceptedInput = [charactersToKeep invertedSet];
    }else if(textField == self.zipCodeField){
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:NUMERIC] invertedSet];
    }else{
        unacceptedInput = [[NSCharacterSet illegalCharacterSet] invertedSet];
    }
    
    // If there are any characters that I do not want in the text field, return NO.
    return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self textFieldShouldReturn:self.lastEditedField];
    
    if (textField==self.priceField) {
        self.dataToUse = @"PRICE";
        [self.priceField resignFirstResponder];
        self.picker.hidden=NO;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        [self.picker reloadAllComponents];
        
        if([self.priceField.text isEqualToString: @""]){
            [self.picker selectRow:0 inComponent:0 animated:YES];
        }else{
            if([self.statusSegmentControl selectedSegmentIndex] == 0){
                NSInteger index = [self.salePriceData indexOfObject:self.priceField.text];
                
                if(index < [self.salePriceData count]){
                    [self.picker selectRow:index inComponent:0 animated:YES];
                    NSInteger row;
                    row = [self.picker selectedRowInComponent:0];
                    self.priceField.text = [self.salePriceData objectAtIndex:row];
                }else{
                    [self.picker selectRow:0 inComponent:0 animated:YES];
                    self.priceField.text = @"";
                }
            }else if([self.statusSegmentControl selectedSegmentIndex] == 1){
                NSLog(@"For Rent is selected");
                NSInteger index = [self.rentPriceData indexOfObject:self.priceField.text];
                
                if(index < [self.salePriceData count]){
                    [self.picker selectRow:index inComponent:0 animated:YES];
                    NSInteger row;
                    row = [self.picker selectedRowInComponent:0];
                    self.priceField.text = [self.rentPriceData objectAtIndex:row];
                }else{
                    [self.picker selectRow:0 inComponent:0 animated:YES];
                    self.priceField.text = @"";
                }
                
            }
        }
        [self.view addSubview:self.picker];
    }else if(textField == self.bedroomsField){
        self.dataToUse = @"BED";
        [self.bedroomsField resignFirstResponder];
        self.picker.hidden=NO;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        [self.picker reloadAllComponents];
        
        if([self.bedroomsField.text isEqualToString:@""]){
            [self.picker selectRow:0 inComponent:0 animated:YES];
        }else{
            NSInteger index = [self.bedroomData indexOfObject:self.bedroomsField.text];
            [self.picker selectRow:index inComponent:0 animated:YES];
            
            NSInteger row;
            row = [self.picker selectedRowInComponent:0];
            self.bedroomsField.text = [self.bedroomData objectAtIndex:row];
        }
        
        [self.view addSubview:self.picker];
    }else if(textField == self.bathroomsField){
        self.dataToUse = @"BATH";
        [self.bathroomsField resignFirstResponder];
         self.picker.hidden=NO;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        [self.picker reloadAllComponents];
        
        if([self.bathroomsField.text isEqualToString:@""]){
            [self.picker selectRow:0 inComponent:0 animated:YES];
        }else{
            
            NSInteger index = [self.bathroomData indexOfObject:self.bathroomsField.text];
            [self.picker selectRow:index inComponent:0 animated:YES];
            
            NSInteger row;
            row = [self.picker selectedRowInComponent:0];
            self.bathroomsField.text = [self.bathroomData objectAtIndex:row];
        }
        [self.view addSubview:self.picker];
    }else if(textField == self.stateField){
        self.dataToUse = @"STATES";
        [self.stateField resignFirstResponder];
        self.picker.hidden=NO;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        [self.picker reloadAllComponents];
        
        if([self.stateField.text isEqualToString:@""]){
            [self.picker selectRow:0 inComponent:0 animated:YES];
        }else{
            
            NSInteger index = [self.states indexOfObject:self.stateField.text];
            [self.picker selectRow:index inComponent:0 animated:YES];
            
            NSInteger row;
            row = [self.picker selectedRowInComponent:0];
            self.stateField.text = [self.states objectAtIndex:row];
        }
        [self.view addSubview:self.picker];
    }else{
        self.picker.hidden=YES;
    }
    
    self.lastEditedField = textField;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if([self.dataToUse isEqualToString:@"PRICE"]){
        NSInteger row;
        row = [self.picker selectedRowInComponent:0];
        if([self.statusSegmentControl selectedSegmentIndex] == 0){
            self.priceField.text = [self.salePriceData objectAtIndex:row];
        }else if([self.statusSegmentControl selectedSegmentIndex] == 1){
            self.priceField.text = [self.rentPriceData objectAtIndex:row];
        }
    }else if([self.dataToUse isEqualToString:@"BED"]){
        NSInteger row;
        row = [self.picker selectedRowInComponent:0];
        self.bedroomsField.text = [self.bedroomData objectAtIndex:row];
    }else if([self.dataToUse isEqualToString:@"BATH"]){
        NSInteger row;
        row = [self.picker selectedRowInComponent:0];
        self.bathroomsField.text = [self.bathroomData objectAtIndex:row];
    }else if([self.dataToUse isEqualToString:@"STATES"]){
        NSInteger row;
        row = [self.picker selectedRowInComponent:0];
        self.stateField.text = [self.states objectAtIndex:row];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    [self.view endEditing:YES];
    if([self.dataToUse isEqualToString:@"PRICE"]){
        if([self.statusSegmentControl selectedSegmentIndex] == 0){
            return [self.salePriceData count];
        }else if([self.statusSegmentControl selectedSegmentIndex] == 1){
            return [self.rentPriceData count];
        }
    }else if([self.dataToUse isEqualToString:@"BED"]){
        return [self.bedroomData count];
    }else if([self.dataToUse isEqualToString:@"BATH"]){
        return [self.bathroomData count];
    }else if([self.dataToUse isEqualToString:@"STATES"]){
        return [self.states count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    [self.view endEditing:YES];
    if([self.dataToUse isEqualToString:@"PRICE"]){
        if([self.statusSegmentControl selectedSegmentIndex] == 0){
            return [self.salePriceData objectAtIndex:row];
        }else if([self.statusSegmentControl selectedSegmentIndex] == 1){
            return [self.rentPriceData objectAtIndex:row];
        }
    }else if([self.dataToUse isEqualToString:@"BED"]){
        return [self.bedroomData objectAtIndex:row];
    }else if([self.dataToUse isEqualToString:@"BATH"]){
        return [self.bathroomData objectAtIndex:row];
    }else if([self.dataToUse isEqualToString:@"STATES"]){
        return [self.states objectAtIndex:row];
    }

    return @"";//or nil, depending how protective you are
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //NSLog(@"Size of data in tour info: %lu", sizeof(self.tour));
    
    self.priceField.delegate = self;
    self.bedroomsField.delegate = self;
    self.bathroomsField.delegate = self;
    self.addressField.delegate = self;
    self.cityField.delegate = self;
    self.stateField.delegate = self;
    self.zipCodeField.delegate = self;
    
    self.picker.hidden=YES;
    
    //For Sale Price Data
    [self.salePriceData addObject:@"0 - 50,000"];
    [self.salePriceData addObject:@"50,000 - 100,000"];
    [self.salePriceData addObject:@"100,000 - 150,000"];
    [self.salePriceData addObject:@"150,000 - 200,000"];
    [self.salePriceData addObject:@"250,000 - 250,000"];
    
    //For Rent Price Data
    [self.rentPriceData addObject:@"0 - 300"];
    [self.rentPriceData addObject:@"300 - 400"];
    [self.rentPriceData addObject:@"400 - 500"];
    [self.rentPriceData addObject:@"500 - 600"];
    [self.rentPriceData addObject:@"600 - 700"];
    
    //Number of Bedrooms
    [self.bedroomData addObject:@"1"];
    [self.bedroomData addObject:@"2"];
    [self.bedroomData addObject:@"3"];
    [self.bedroomData addObject:@"4"];
    [self.bedroomData addObject:@"5"];
    [self.bedroomData addObject:@"6"];
    
    //Number of Bathrooms
    [self.bathroomData addObject:@"1"];
    [self.bathroomData addObject:@"1.5"];
    [self.bathroomData addObject:@"2"];
    [self.bathroomData addObject:@"2.5"];
    [self.bathroomData addObject:@"3"];
    [self.bathroomData addObject:@"3.5"];
    
    //States List
    [self.states addObject:@"Alabama"];
    [self.states addObject:@"Alaska"];
    [self.states addObject:@"Arizona"];
    [self.states addObject:@"Arkansas"];
    [self.states addObject:@"California"];
    [self.states addObject:@"Colorado"];
    [self.states addObject:@"Connecticut"];
    [self.states addObject:@"Delaware"];
    [self.states addObject:@"Florida"];
    [self.states addObject:@"Georgia"];
    [self.states addObject:@"Hawaii"];
    [self.states addObject:@"Idaho"];
    [self.states addObject:@"Illinois"];
    [self.states addObject:@"Indiana"];
    [self.states addObject:@"Iowa"];
    [self.states addObject:@"Kansas"];
    [self.states addObject:@"Kentucky"];
    [self.states addObject:@"Louisiana"];
    [self.states addObject:@"Maine"];
    [self.states addObject:@"Maryland"];
    [self.states addObject:@"Massachusetts"];
    [self.states addObject:@"Michigan"];
    [self.states addObject:@"Minnesota"];
    [self.states addObject:@"Mississippi"];
    [self.states addObject:@"Missouri"];
    [self.states addObject:@"Montana"];
    [self.states addObject:@"Nebraska"];
    [self.states addObject:@"Nevada"];
    [self.states addObject:@"New Hampshire"];
    [self.states addObject:@"New Jersey"];
    [self.states addObject:@"New Mexico"];
    [self.states addObject:@"New York"];
    [self.states addObject:@"North Carolina"];
    [self.states addObject:@"North Dakota"];
    [self.states addObject:@"Ohio"];
    [self.states addObject:@"Oklahoma"];
    [self.states addObject:@"Oregon"];
    [self.states addObject:@"Pennsylvania"];
    [self.states addObject:@"Rhode Island"];
    [self.states addObject:@"South Carolina"];
    [self.states addObject:@"South Dakota"];
    [self.states addObject:@"Tennessee"];
    [self.states addObject:@"Texas"];
    [self.states addObject:@"Utah"];
    [self.states addObject:@"Vermont"];
    [self.states addObject:@"Virginia"];
    [self.states addObject:@"Washington"];
    [self.states addObject:@"West Virginia"];
    [self.states addObject:@"Wisconsin"];
    [self.states addObject:@"Wyoming"];
    [self.states addObject:@"District of Columbia"];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.picker.hidden=YES;
    [self.view endEditing:YES];
    [self textFieldShouldReturn:self.lastEditedField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
