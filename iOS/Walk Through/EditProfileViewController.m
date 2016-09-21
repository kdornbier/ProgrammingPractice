//
//  EditProfileViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 2/15/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EditProfileViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *stateField;
@property (strong, nonatomic) IBOutlet UITextField *cityField;
@property (nonatomic) int uniqueId;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
//@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong,nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) UIView *loading;
@property (strong, nonatomic) UILabel *loadLabel;
@property (strong, nonatomic) UIActivityIndicatorView *spinning;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSMutableArray *states;
@property (weak, nonatomic) UITextField *lastEditedField;

@end

@implementation EditProfileViewController

- (NSMutableArray *)states {
    if (_states == nil)
		_states = [[NSMutableArray alloc] init];
    return _states;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
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
    
    self.nameField.delegate = self;
    self.phoneField.delegate = self;
    self.cityField.delegate = self;
    self.stateField.delegate = self;
    
    ProfileManagement* profile = [ProfileManagement getInstance];
    self.nameField.text = profile.name;
    if(![profile.email isEqualToString:@"(null)"])
        self.emailField.text = profile.email;
    self.phoneField.text = profile.phone;
    self.stateField.text = profile.state;
    self.cityField.text = profile.city;
    self.uniqueId = profile.uniqueId;
}

- (IBAction)saveData {
    
    if([self.nameField.text isEqualToString:@""] || [self.emailField.text isEqualToString:@""] ||
       [self.stateField.text isEqualToString:@""] || [self.cityField.text isEqualToString:@""] ){
        
        if([self.nameField.text isEqualToString:@""]){
            self.nameLabel.textColor = [UIColor redColor];
        }else{
            self.nameLabel.textColor = [UIColor blackColor];
        }
        
        if([self.emailField.text isEqualToString:@""] || ![self validateEmail:self.emailField.text]){
            self.emailLabel.textColor = [UIColor redColor];
        }else{
            self.emailLabel.textColor = [UIColor blackColor];
        }
        
        if([self.stateField.text isEqualToString:@""]){
            self.stateLabel.textColor = [UIColor redColor];
        }else{
            self.stateLabel.textColor = [UIColor blackColor];
        }
        
        if([self.cityField.text isEqualToString:@""]){
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
        NSLog(@"Save Data Request");
        NSString *post = [NSString stringWithFormat:@"&id=%d&name=%@&email=%@&phone=%@&city=%@&state=%@", self.uniqueId, self.nameField.text, self.emailField.text, self.phoneField.text, self.cityField.text, self.stateField.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",postData.length];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/update.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if(conn){
            NSLog(@"connection Successful");
            ProfileManagement* profile = [ProfileManagement getInstance];
            profile.name = self.nameField.text;
            profile.email = self.emailField.text;
            profile.phone =self.phoneField.text;
            profile.state =self.stateField.text;
            profile.city =self.cityField.text;
            profile.uniqueId =self.uniqueId;
            
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
            self.errorLabel.text = @"Connection could not be made at this time, please try again later.";
            
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
    ProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
    [self presentViewController:profileView animated:YES completion:Nil];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if([candidate isEqualToString:@"me@example.com"]){
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
    
    if(textField == self.phoneField){
        self.picker.hidden = YES;
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:NUMERIC] invertedSet];
    }else if (textField == self.nameField || textField == self.cityField){
        self.picker.hidden = YES;
        NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet characterSetWithCharactersInString:ALPHA];
        [charactersToKeep addCharactersInString:@" "];
        unacceptedInput = [charactersToKeep invertedSet];
    }else if(textField == self.stateField ){
        [self.stateField resignFirstResponder];
        self.picker.hidden = NO;
    }else{
        self.picker.hidden = YES;
        unacceptedInput = [[NSCharacterSet illegalCharacterSet] invertedSet];
    }
    
    self.lastEditedField = textField;
    // If there are any characters that I do not want in the text field, return NO.
    return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self textFieldShouldReturn:self.lastEditedField];
    if(textField == self.stateField){
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
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.picker.hidden=YES;
    [self.view endEditing:YES];
    [self textFieldShouldReturn:self.lastEditedField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //if([self.dataToUse isEqualToString:@"STATES"]){
        //NSInteger row;
        row = [self.picker selectedRowInComponent:0];
        self.stateField.text = [self.states objectAtIndex:row];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
