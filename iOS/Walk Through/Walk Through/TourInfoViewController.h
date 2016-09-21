//
//  TourInfoViewController.h
//  Walk Through
//
//  Created by Nate Halbmaier on 2/24/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Virtual_Tour.h"

@interface TourInfoViewController : UIViewController <NSURLConnectionDelegate>

@property (strong, nonatomic) NSString *tourString;
@property (strong, nonatomic) NSString *tourid;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) Virtual_Tour *tour;
@property (weak, nonatomic) IBOutlet UIButton *SaveButton;
@end

