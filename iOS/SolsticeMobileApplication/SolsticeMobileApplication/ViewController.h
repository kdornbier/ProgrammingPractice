//
//  ViewController.h
//  SolsticeMobileApplication
//
//  Created by Kaitlyn Dornbier on 10/19/15.
//  Copyright (c) 2015 Kaitlyn Dornbier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

- (IBAction)showPicker:(id)sender;

@end

