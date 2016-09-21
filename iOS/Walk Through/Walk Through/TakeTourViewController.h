//
//  TakeTourViewController.h
//  Walk Through
//
//  Created by Kaitlyn Dornbier on 4/7/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeTourNavigator.h"
#import "Virtual_Tour.h"
#import "Virtual_TourCreator.h"

@interface TakeTourViewController : UIViewController <UINavigationControllerDelegate>
@property (strong,nonatomic) NSDictionary *results;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIButton *jumpBackButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)moveRight;
- (IBAction)moveLeft;
- (IBAction)jumpBack;
@end
