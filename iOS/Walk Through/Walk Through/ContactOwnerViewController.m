//
//  ContactOwnerViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 4/6/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "ContactOwnerViewController.h"

@interface ContactOwnerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@end

@implementation ContactOwnerViewController

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
    
    self.nameLabel.text = [NSString stringWithFormat:@"Name: %@", self.name];
    self.emailLabel.text = [NSString stringWithFormat:@"Email: %@", self.email];
    self.phoneLabel.text = [NSString stringWithFormat:@"Phone: %@", self.phone];
    
    
    if([self.phone isEqualToString:@""]){
        self.callButton.enabled = NO;
    }
    
    if([self.email isEqualToString:@""]){
        self.emailButton.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendEmail {
    NSString *email = [@"mailto://" stringByAppendingString:self.email];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (IBAction)call {
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:self.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
@end
