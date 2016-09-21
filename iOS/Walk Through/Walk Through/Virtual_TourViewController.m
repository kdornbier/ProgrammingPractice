//
//  Virtual_TourViewController.m
//  Walk Through
//
//  Created by Nate Halbmaier on 4/2/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "Virtual_TourViewController.h"
//#import "Virtual_TourCreator.h"
#import "TourInfoViewController.h"

@interface Virtual_TourViewController ()
@property (nonatomic, strong) Virtual_TourCreator *newTour;
@end

@implementation Virtual_TourViewController

- (Virtual_TourCreator *) newTour
{
    if(!_newTour) _newTour = [[Virtual_TourCreator alloc] init];
    return _newTour;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    if(self.newTour.currentView.jumpToViewpoint == nil)
    {
        [self.jumpBackButton setHidden:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"tourInfo"]){
            TourInfoViewController *vc = [segue destinationViewController];
        
            Virtual_Tour * tour = [self.newTour getTour];
            vc.tour = tour;
    }
}
- (IBAction)moveRight {
    [self.newTour moveRight];
    [self updateScreen];
}

- (IBAction)moveLeft {
    [self.newTour moveLeft];
    [self updateScreen];
}

- (IBAction)makeJump {
    [self.newTour makeJump];
    [self updateScreen];
}

- (IBAction)jumpBack {
    [self.newTour jumpBack];
    [self updateScreen];
}

- (void)updateScreen
{
    if(self.newTour.currentViewpointIndex < self.newTour.currentView.imageArray.count)
    {
        self.imageView.image = [self.newTour.currentView.imageArray objectAtIndex:self.newTour.currentViewpointIndex];
    } else {
        //self.imageView.image = nil;
        [self.imageView setImage:[UIImage imageNamed:@"NewPhotoScreen"]];
    }
    
    if(!self.newTour.canJump)
    {
        [self.jumpButton setHidden:YES];
    }
    
    if(self.newTour.currentViewpointIndex == self.newTour.currentView.jumpIndex && self.newTour.currentView.jumpToViewpoint != nil)
    {
        [self.jumpBackButton setHidden:NO];
    } else {
        [self.jumpBackButton setHidden:YES];
    }
}

- (IBAction)takePhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:NO completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:NO completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    CGSize scaleSize = CGSizeMake(320,430);
    UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
    [chosenImage drawInRect:CGRectMake(0,0,scaleSize.width, scaleSize.height)];
    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.newTour setViewImage:chosenImage];
    [self.doneButton setHidden:NO];
    [self updateScreen];
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
}
@end
