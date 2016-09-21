//
//  SearchCriteriaViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 3/8/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "SearchCriteriaViewController.h"
#import "TourSearchResultsViewController.h"

@interface SearchCriteriaViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *bedroomsField;
@property (weak, nonatomic) IBOutlet UITextField *bathroomsField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *statusSegmentControl;
@property (strong,nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) NSMutableArray *salePriceData;
@property (strong, nonatomic) NSMutableArray *rentPriceData;
@property (strong, nonatomic) NSMutableArray *bedroomData;
@property (strong, nonatomic) NSMutableArray *bathroomData;
@property (strong, nonatomic) NSMutableArray *states;
@property (weak, nonatomic) UITextField *lastEditedField;
@property (weak, nonatomic) NSString *dataToUse;

@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) NSDictionary *dictionary;

@end

@implementation SearchCriteriaViewController

- (NSMutableArray *)salePriceData {
    if (_salePriceData == nil)
		_salePriceData = [[NSMutableArray alloc] init];
    return _salePriceData;
}
- (NSMutableArray *)states {
    if (_states == nil)
		_states = [[NSMutableArray alloc] init];
    return _states;
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

- (IBAction)segmentControlChange:(id)sender {
    self.priceField.text = @"";
    [self.picker reloadAllComponents];
}

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
                
            }else{
                self.priceField.text = @"";
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
        }else{
            self.priceField.text = @"";
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
        }else{
            return 0;
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
        }else{
            return Nil;
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

- (void)searchPressed {
    NSString *address = self.addressField.text;
    NSString *city = self.cityField.text;
    NSString *state = self.stateField.text;
    NSString *zip = self.zipCodeField.text;
    NSString *bed = self.bedroomsField.text;
    NSString *bath = self.bathroomsField.text;
    NSString *price = self.priceField.text;
    NSString *status = [self.statusSegmentControl titleForSegmentAtIndex:self.statusSegmentControl.selectedSegmentIndex];
    
    if([status isEqualToString:@"Both"]){
        status = @"";
    }else if([status isEqualToString:@"Rent"]){
        status = @"For Rent";
    }else if([status isEqualToString:@"Sale"]){
        status = @"For Sale";
    }
    
    NSString *url = [NSString stringWithFormat:@"http://walkthrough.dellspergerdevelopment.com/scripts/advanced_search.php?address=%@&city=%@&state=%@&zipcode=%@&bedrooms=%@&bathrooms=%@&price=%@&status=%@", address, city, state, zip, bed, bath, price, status];
    
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
            NSMutableArray *bathroomArray = [[NSMutableArray alloc] init];
            NSMutableArray *bedroomArray = [[NSMutableArray alloc] init];
            NSMutableArray *priceArray = [[NSMutableArray alloc] init];
            NSMutableArray *statusArray = [[NSMutableArray alloc] init];
            //NSLog(@"DICTIONARY");
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
    if([segue.identifier isEqualToString:@"search"]){
        [self searchPressed];
        TourSearchResultsViewController *vc =[segue destinationViewController];
        vc.labels = self.labels;
        vc.tourData = self.dictionary;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.priceField.delegate = self;
    self.bedroomsField.delegate = self;
    self.bathroomsField.delegate = self;
    self.addressField.delegate = self;
    self.cityField.delegate = self;
    self.stateField.delegate = self;
    self.zipCodeField.delegate = self;
    
    self.picker.hidden=YES;
    
    [self.salePriceData addObject:@"0 - 50,000"];
    [self.salePriceData addObject:@"50,000 - 100,000"];
    [self.salePriceData addObject:@"100,000 - 150,000"];
    [self.salePriceData addObject:@"150,000 - 200,000"];
    [self.salePriceData addObject:@"250,000 - 250,000"];
    
    [self.rentPriceData addObject:@"0 - 300"];
    [self.rentPriceData addObject:@"300 - 400"];
    [self.rentPriceData addObject:@"400 - 500"];
    [self.rentPriceData addObject:@"500 - 600"];
    [self.rentPriceData addObject:@"600 - 700"];
    
    [self.bedroomData addObject:@"1"];
    [self.bedroomData addObject:@"2"];
    [self.bedroomData addObject:@"3"];
    [self.bedroomData addObject:@"4"];
    [self.bedroomData addObject:@"5"];
    [self.bedroomData addObject:@"6"];
    
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
