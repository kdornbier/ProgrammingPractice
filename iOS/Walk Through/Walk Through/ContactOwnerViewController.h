//
//  ContactOwnerViewController.h
//  Walk Through
//
//  Created by Nate Halbmaier on 4/6/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactOwnerViewController : UIViewController
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@end
