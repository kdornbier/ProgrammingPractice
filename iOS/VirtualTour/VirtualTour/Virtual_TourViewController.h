//
//  Virtual_TourViewController.h
//  VirtualTour
//
//  Created by Kaitlyn Dornbier on 2/17/14.
//  Copyright (c) 2014 Kaitlyn Dornbier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Virtual_TourViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIButton *jumpButton;
@property (strong, nonatomic) IBOutlet UIButton *jumpBackButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)moveRight;
- (IBAction)moveLeft;
- (IBAction)makeJump;
- (IBAction)jumpBack;
@end
