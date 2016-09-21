//
//  RegistrationViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 2/15/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "RegistrationViewController.h"
#import "ProfileManagement.h"
#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RegistrationViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) ProfileManagement *profile;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *stateText;
@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (strong, nonatomic) NSMutableArray *states;
@property (weak, nonatomic) UITextField *lastEditedField;
@property (weak, nonatomic) UITextField *lastNonPickerField;
@property (strong,nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) UIView *loading;
@property (strong, nonatomic) UILabel *loadLabel;
@property (strong, nonatomic) UIActivityIndicatorView *spinning;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation RegistrationViewController
- (NSMutableArray *)states {
    if (_states == nil)
		_states = [[NSMutableArray alloc] init];
    return _states;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"Return data =  %@", string);
    ProfileManagement* profile = [ProfileManagement getInstance];
    profile.uniqueId = [string intValue];
    profile.name = self.nameText.text;
    profile.email = self.emailText.text;
    profile.city = self.cityText.text;
    profile.state = self.stateText.text;
    profile.password = self.passwordText.text;
    profile.phone = self.phoneText.text;
}

- (IBAction)doneTouched {
    
    if([self.nameText.text isEqualToString:@""] || [self.emailText.text isEqualToString:@""] ||
       [self.passwordText.text isEqualToString:@""] ||
       [self.stateText.text isEqualToString:@""] || [self.cityText.text isEqualToString:@""] ){
        
        if([self.nameText.text isEqualToString:@""]){
            self.nameLabel.textColor = [UIColor redColor];
        }else{
            self.nameLabel.textColor = [UIColor blackColor];
        }
        
        
        if([self.emailText.text isEqualToString:@""] || ![self validateEmail:self.emailText.text]){
            self.emailLabel.textColor = [UIColor redColor];
        }else{
            self.emailLabel.textColor = [UIColor blackColor];
        }

        if([self.passwordText.text isEqualToString:@""]){
             self.passwordLabel.textColor = [UIColor redColor];
        }else{
            self.passwordLabel.textColor = [UIColor blackColor];
        }

        if([self.stateText.text isEqualToString:@""]){
             self.stateLabel.textColor = [UIColor redColor];
        }else{
            self.stateLabel.textColor = [UIColor blackColor];
        }
        
        if([self.cityText.text isEqualToString:@""]){
             self.cityLabel.textColor = [UIColor redColor];
        }else{
            self.cityLabel.textColor = [UIColor blackColor];
        }
        self.errorLabel.text = @"Please fill in all required fields";
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
    }else{
        
        if([self.phoneText.text isEqualToString:@"optional"]){
            self.phoneText.text = @"";
        }
        
        NSLog(@"New USER REQUEST");
        NSString *post = [NSString stringWithFormat:@"&name=%@&email=%@&password=%@&phone=%@&city=%@&state=%@",self.nameText.text, self.emailText.text, self.passwordText.text, self.phoneText.text, self.cityText.text, self.stateText.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",postData.length];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/registration.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if(conn){
            NSLog(@"connection Successful");
            
            ProfileManagement* profile = [ProfileManagement getInstance];
            profile.name = self.nameText.text;
            profile.email = self.emailText.text;
            profile.city = self.cityText.text;
            profile.state = self.stateText.text;
            profile.password = self.passwordText.text;
            profile.phone = self.phoneText.text;
            
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
            NSLog(@"Connection could not be made");
            self.errorLabel.text = @"Connection Could not be made, Please try again in a little while";
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
    }
}

-(void)removeMessage{
    [self.timer invalidate];
    [self.loading removeFromSuperview];
}

-(void)changeToProfileScreen{
    [self.timer invalidate];
    ProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
    [self presentViewController:profileView animated:YES completion:Nil];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if([self.emailText.text isEqualToString:@"me@example.com"]){
        return NO;
    }
    
    return [emailTest evaluateWithObject:candidate];
}

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC

// Make sure you are the text fields 'delegate', then this will get called before text gets changed.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // This will be the character set of characters I do not want in my text field.  Then if the replacement string contains any of the characters, return NO so that the text does not change.
    NSCharacterSet *unacceptedInput = nil;
    
    if(textField == self.phoneText){
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:NUMERIC] invertedSet];
    }else if (textField == self.nameText || textField == self.stateText || textField == self.cityText){
        NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet characterSetWithCharactersInString:ALPHA];
        [charactersToKeep addCharactersInString:@" "];
        unacceptedInput = [charactersToKeep invertedSet];
    }else{
        unacceptedInput = [[NSCharacterSet illegalCharacterSet] invertedSet];
    }
    
    // If there are any characters that I do not want in the text field, return NO.
    return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self textFieldShouldReturn:self.lastEditedField];
    if(textField == self.stateText){
        [self.stateText resignFirstResponder];
        self.picker.hidden=NO;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        [self.picker reloadAllComponents];
        
        if([self.stateText.text isEqualToString:@""]){
            [self.picker selectRow:0 inComponent:0 animated:YES];
        }else{
            
            NSInteger index = [self.states indexOfObject:self.stateText.text];
            [self.picker selectRow:index inComponent:0 animated:YES];
            
            NSInteger row;
            row = [self.picker selectedRowInComponent:0];
            self.stateText.text = [self.states objectAtIndex:row];
        }
        [self.view addSubview:self.picker];
    }else{
        self.picker.hidden=YES;
        self.lastNonPickerField = textField;
    }
    
    self.lastEditedField = textField;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.picker.hidden=YES;
    [self.view endEditing:YES];
    [self textFieldShouldReturn:self.lastEditedField];
    [self textFieldShouldReturn:self.lastNonPickerField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal { return NO; }


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //if([self.dataToUse isEqualToString:@"STATES"]){
    //NSInteger row;
    row = [self.picker selectedRowInComponent:0];
    self.stateText.text = [self.states objectAtIndex:row];
    // }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    [self.view endEditing:YES];
    //if([self.dataToUse isEqualToString:@"STATES"]){
    return [self.states count];
    //}
    //return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    [self.view endEditing:YES];
    //if([self.dataToUse isEqualToString:@"STATES"]){
    return [self.states objectAtIndex:row];
    //}
    
    //return @"";//or nil, depending how protective you are
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.nameText.delegate = self;
    self.phoneText.delegate = self;
    self.cityText.delegate = self;
    self.stateText.delegate = self;
    
    
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
    
    self.picker.hidden = YES;

    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
