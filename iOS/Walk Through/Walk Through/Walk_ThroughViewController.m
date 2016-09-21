//
//  Walk_ThroughViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 2/6/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "Walk_ThroughViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Walk_ThroughAppDelegate.h"
#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RegistrationViewController.h"
#import "Database.h"

@interface Walk_ThroughViewController () <FBLoginViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@property (weak, nonatomic) NSString *nameVal;
@property (weak, nonatomic) NSString *emailVal;
@property (weak, nonatomic) NSString *passwordVal;
@property (weak, nonatomic) NSString *phoneVal;
@property (weak, nonatomic) NSString *cityVal;
@property (weak, nonatomic) NSString *stateVal;
@property (nonatomic) int idVal;

@property (strong, nonatomic) ProfileManagement *profile;
@property (strong, nonatomic) RegistrationViewController *registration;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (strong, nonatomic) UIView *loading;
@property (strong, nonatomic) UILabel *loadLabel;
@property (strong, nonatomic) UIActivityIndicatorView *spinning;
@property (strong, nonatomic) NSTimer *timer;

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;

@end


@implementation Walk_ThroughViewController

-(RegistrationViewController *)registration{
    if(!_registration) _registration = [[RegistrationViewController alloc] init];
    return _registration;
}

- (void)getRequest {

    NSString *enteredEmail = self.emailText.text;
    NSString *url = [NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts?email=%@", enteredEmail];
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
        
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"DICTIONARY");
            NSDictionary *results = object;
            NSDictionary *json = [results objectForKey:@"user"];
            self.nameVal = [json objectForKey:@"name"];
            self.emailVal = [json objectForKey:@"email"];
            self.passwordVal = [json objectForKey:@"password"];
            self.phoneVal= [json objectForKey:@"phone"];
            self.cityVal= [json objectForKey:@"city"];
            self.stateVal = [json objectForKey:@"state"];
            self.idVal = [[json objectForKey:@"id"] intValue];
  
            ProfileManagement* profile = [ProfileManagement getInstance];
            profile.name = self.nameVal;
            profile.email = self.emailVal;
            profile.password = self.passwordVal;
            profile.phone = self.phoneVal;
            profile.city = self.cityVal;
            profile.state = self.stateVal;
            profile.uniqueId = self.idVal;
            
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
        }
        else
        {
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
            
            NSLog(@"Array");
            
        }
    }
    else
    {
        // the user is using iOS 4; we'll need to use a third-party solution.
        // If you don't intend to support iOS 4 then get rid of this entire
        // conditional and just jump straight to
        // NSError *error = nil;
        // [NSJSONSerialization JSONObjectWithData:...
    }
    
}

-(BOOL)AuthenticateUser:(NSString *)email :(NSString *)password{
    
    [self getRequest];
    ProfileManagement* profile = [ProfileManagement getInstance];
    
    if([email isEqualToString: profile.email]){
        if([password isEqualToString: profile.password]){
            return true;
        }
    }
    return false;
}

- (IBAction)loginButtonPressed:(id)sender {
    NSLog(@"Login Button Pressed");
    
    BOOL loggedIn = [self AuthenticateUser:self.emailText.text : self.passwordText.text];
    
    if(loggedIn){
        NSLog(@"User successfully Logged In");
        [self.errorLabel setHidden:YES];
        
        self.loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
        self.loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        self.loading.layer.cornerRadius = 15;
        self.loading.opaque = NO;
        self.loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 81, 22)];
        self.loadLabel.text = @"Success";
        self.loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.loadLabel.textAlignment = NSTextAlignmentCenter;
        self.loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        self.loadLabel.backgroundColor = [UIColor clearColor];
        [self.loading addSubview:self.loadLabel];
        self.loading.frame = CGRectMake(100, 200, 120, 120);
        [self.view addSubview:self.loading];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(changeToProfileScreen)
                                                    userInfo:nil
                                                     repeats:NO];
        
        
    }else{
        NSLog(@"Incorrect Username or Password");
        [self.errorLabel setHidden:NO];
        self.passwordText.text = @"";
    
        self.loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
        self.loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        self.loading.layer.cornerRadius = 15;
        self.loading.opaque = NO;
        self.loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 81, 22)];
        self.loadLabel.text = @"Error";
        self.loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.loadLabel.textAlignment = NSTextAlignmentCenter;
        self.loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        self.loadLabel.backgroundColor = [UIColor clearColor];
        [self.loading addSubview:self.loadLabel];
        self.loading.frame = CGRectMake(100, 200, 120, 120);
        [self.view addSubview:self.loading];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(removeMessage)
                                                    userInfo:nil
                                                     repeats:NO];
    }
}

-(void)removeMessage{
    [self.timer invalidate];
    [self.loading removeFromSuperview];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create Login View so that the app will be granted "status_update" permission.
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    [loginview setReadPermissions:@[@"basic_info"]];

    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
    #ifdef __IPHONE_7_0
    #ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        loginview.frame = CGRectOffset(loginview.frame, (self.view.center.x - (loginview.frame.size.width / 2)), 350);
    }
    #endif
    #endif
    #endif
    
    loginview.delegate = self;
    _emailText.delegate = self;
    _passwordText.delegate = self;
    
    [self.view addSubview:loginview];
    [loginview sizeToFit];
}

- (void)viewDidUnload {
    self.loggedInUser = nil;
    //self.profilePic = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
    self.loading.layer.cornerRadius = 15;
    self.loading.opaque = NO;
    self.loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    self.loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 81, 22)];
    self.loadLabel.text = @"Loading";
    self.loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.loadLabel.textAlignment = NSTextAlignmentCenter;
    self.loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    self.loadLabel.backgroundColor = [UIColor clearColor];
    [self.loading addSubview:self.loadLabel];
    self.spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinning.frame = CGRectMake(42, 54, 37, 37);
    [self.spinning startAnimating];
    [self.loading addSubview:self.spinning];
    self.loading.frame = CGRectMake(100, 200, 120, 120);
    [self.view addSubview:self.loading];
    [self requestUserInfo];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //NSLog(@"Return data =  %@", string);
    self.idVal = [string intValue];
    ProfileManagement* profile = [ProfileManagement getInstance];
    profile.uniqueId = self.idVal;
}

-(void) changeView{
    NSLog(@"Change View");
    BOOL newUSER = NO;
    
    NSString *enteredEmail = self.emailVal;
    NSString *url = [NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts?email=%@", enteredEmail];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    //NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    if(requestError){
        NSLog(@"Server Error");
        self.loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
        self.loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        self.loading.layer.cornerRadius = 15;
        self.loading.opaque = NO;
        self.loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 81, 100)];
        self.loadLabel.text = @"Server Error";
        self.loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.loadLabel.textAlignment = NSTextAlignmentCenter;
        self.loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        self.loadLabel.backgroundColor = [UIColor clearColor];
        self.loadLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.loadLabel.numberOfLines = 0;
        [self.loading addSubview:self.loadLabel];
        self.loading.frame = CGRectMake(100, 200, 120, 120);
        [self.view addSubview:self.loading];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(removeMessage)
                                                    userInfo:nil
                                                     repeats:NO];
    }

    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:response
                     options:0
                     error:&error];
        
        if(error) {
            NSLog(@"ERROR With JSON");
            self.loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
            self.loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
            self.loading.layer.cornerRadius = 15;
            self.loading.opaque = NO;
            self.loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 81, 100)];
            self.loadLabel.text = @"Server Error";
            self.loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
            self.loadLabel.textAlignment = NSTextAlignmentCenter;
            self.loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
            self.loadLabel.backgroundColor = [UIColor clearColor];
            self.loadLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.loadLabel.numberOfLines = 0;
            [self.loading addSubview:self.loadLabel];
            self.loading.frame = CGRectMake(100, 200, 120, 120);
            [self.view addSubview:self.loading];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(removeMessage)
                                                        userInfo:nil
                                                         repeats:NO];
        }
        
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"DICTIONARY");
            NSDictionary *results = object;
            NSDictionary *json = [results objectForKey:@"user"];
            self.nameVal = [json objectForKey:@"name"];
            self.emailVal = [json objectForKey:@"email"];
            self.passwordVal = [json objectForKey:@"password"];
            self.phoneVal = [json objectForKey:@"phone"];
            self.cityVal = [json objectForKey:@"city"];
            self.stateVal = [json objectForKey:@"state"];
            self.idVal= [[json objectForKey:@"id"] intValue];
            
            ProfileManagement* profile = [ProfileManagement getInstance];
            profile.uniqueId = self.idVal;
            profile.name = self.nameVal;
            profile.email = self.emailVal;
            profile.password = self.passwordVal;
            profile.phone = self.phoneVal;
            profile.city = self.cityVal;
            profile.state = self.stateVal;
        }
        else{
            NSLog(@"Array");
            newUSER = YES;
        }
    }
    else{
        //ERROR
        self.loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
        self.loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        self.loading.layer.cornerRadius = 15;
        self.loading.opaque = NO;
        self.loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 81, 100)];
        self.loadLabel.text = @"Server Error";
        self.loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.loadLabel.textAlignment = NSTextAlignmentCenter;
        self.loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        self.loadLabel.backgroundColor = [UIColor clearColor];
        self.loadLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.loadLabel.numberOfLines = 0;
        [self.loading addSubview:self.loadLabel];
        self.loading.frame = CGRectMake(100, 200, 120, 120);
        [self.view addSubview:self.loading];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(removeMessage)
                                                    userInfo:nil
                                                     repeats:NO];
    }
    
    if(newUSER){
        NSLog(@"New USER REQUEST");
        
        NSString *post = [NSString stringWithFormat:@"&name=%@&email=%@&city=%@&state=%@", self.nameVal, self.emailVal, self.cityVal, self.stateVal];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",postData.length];
        request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/insert.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];

        if(conn){
            NSLog(@"New user successful");
        }else{
            NSLog(@"Connection could not be made: Server Error");
        }
        
        self.passwordVal = @"";
        self.phoneVal = @"";
        
        ProfileManagement* profile = [ProfileManagement getInstance];
        profile.name = self.nameVal;
        profile.email = self.emailVal;
        profile.city = self.cityVal;
        profile.state = self.stateVal;
        profile.password = self.passwordVal;
        profile.phone = self.phoneVal;
    
    }
    //[self.view sendSubviewToBack:self.loading];
    [self.view sendSubviewToBack:self.spinning];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(successMessage)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)successMessage{
    NSLog(@"Success Screen");
    [self.timer invalidate];
    self.loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
    self.loading.layer.cornerRadius = 15;
    self.loading.opaque = NO;
    self.loadLabel.text = @"Success";
    [self.loading addSubview:self.loadLabel];
    self.loading.frame = CGRectMake(100, 200, 120, 120);
    [self.view addSubview:self.loading];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(changeToProfileScreen)
                                   userInfo:nil
                                    repeats:NO];
    
    
}

-(void)changeToProfileScreen{
    [self.timer invalidate];
    ProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
    [self presentViewController:profileView animated:YES completion:Nil];
}

-(void)requestUserInfo{
    NSLog(@"Request User Info");
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"basic_info", @"email"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted, we can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               NSLog(@"error %@", error.description);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    //self.profilePic.profileID = user.id;
    self.loggedInUser = user;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    
    self.loggedInUser = nil;
}
- (void) makeRequestForUserData
{
    NSLog(@"Make Request");
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            //NSLog([NSString stringWithFormat:@"user info: %@", result]);
        
            NSString *name = [result objectForKey:@"name"];
            //NSLog(@"Name is %@", name);
            
            self.nameVal = name;
            
            NSString *email = [result objectForKey:@"email"];
           // NSLog(@"Email is %@", email);
            
            self.emailVal = email;
            
            NSDictionary *location = [result objectForKey:@"location"];
            NSString *cityState = location[@"name"];
            //NSLog(@"Location is %@", cityState);
            
            NSArray *loc = [cityState componentsSeparatedByString: @","];
            NSString *city = [loc objectAtIndex:0];
            NSString *state = [loc objectAtIndex:1];
            
            if(city == NULL){
                self.cityVal=@"";
            }else{
                self.cityVal = city;
            }
            
            if(state == NULL){
                self.stateVal=@"";
            }else{
                self.stateVal = state;
            }
            
           // NSLog(@"City is %@ and State is %@", city, state);
        
            [self changeView];
        } else {
            NSLog(@"There was an error");
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            //NSLog([NSString stringWithFormat:@"error %@", error.description]);
        }
    }];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

#pragma mark -

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
