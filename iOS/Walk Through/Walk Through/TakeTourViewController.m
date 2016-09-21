//
//  TakeTourViewController.m
//  Walk Through
//
//  Created by Kaitlyn Dornbier on 4/7/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "TakeTourViewController.h"
//#import "Virtual_TourCreator.h"

@interface TakeTourViewController ()
@property (nonatomic, strong) Virtual_TourCreator *createTour;
@property (nonatomic, strong) TakeTourNavigator *currentTour;

@end

@implementation TakeTourViewController

- (Virtual_TourCreator *) createTour
{
    if(!_createTour) _createTour = [[Virtual_TourCreator alloc] init];
    return _createTour;
}

- (TakeTourNavigator *) currentTour
{
    if(!_currentTour) _currentTour = [[TakeTourNavigator alloc] init];
    return _currentTour;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentTour.tour = [self createTourPrior];
    
    self.currentTour.currentViewpointIndex = 0;
    self.currentTour.currentView = [self.currentTour.tour.viewPointArray objectAtIndex:0];
    [self updateScreen];
}

-(void) moveRight
{
    [self.currentTour moveRight];
    [self updateScreen];
}

-(void) moveLeft
{
    [self.currentTour moveLeft];
    [self updateScreen];
}

-(void) jumpBack
{
    [self.currentTour jumpBack];
    [self updateScreen];
}

- (void)updateScreen
{
    if(self.currentTour.currentViewpointIndex < self.currentTour.currentView.imageArray.count)
    {
        self.imageView.image = [self.currentTour.currentView.imageArray objectAtIndex:self.currentTour.currentViewpointIndex];
    } else {
        self.imageView.image = nil;
    }
    
    if(self.currentTour.currentViewpointIndex == self.currentTour.currentView.jumpIndex && self.currentTour.currentView.jumpToViewpoint != nil)
    {
        [self.jumpBackButton setHidden:NO];
    } else {
        [self.jumpBackButton setHidden:YES];
    }
}

-(Virtual_Tour *)createTourPrior
{
    if(![[self.results objectForKey:@"view0_image0"] isEqualToString:@"null"])
    {
        self.createTour.currentViewpointIndex = 0;
        self.createTour.currentView.jumpIndex = [[self.results objectForKey:@"jumpIndex"] intValue];
        [self.createTour setViewImage: [self getImage:[self.results objectForKey:@"view0_image0"]]];
        //self.imageView.image = [self.createTour.currentView.imageArray objectAtIndex:self.createTour.currentViewpointIndex];
        if(![[self.results objectForKey:@"view0_image1"] isEqualToString:@"null"])
        {
            [self.createTour moveRight];
            [self.createTour setViewImage:[self getImage:[self.results objectForKey:@"view0_image1"]]];
        }
        if(![[self.results objectForKey:@"view0_image2"] isEqualToString:@"null"])
        {
            [self.createTour moveRight];
            [self.createTour setViewImage:[self getImage:[self.results objectForKey:@"view0_image2"]]];
        }
        if(![[self.results objectForKey:@"view0_image3"] isEqualToString:@"null"])
        {
            [self.createTour moveRight];
            [self.createTour setViewImage:[self getImage:[self.results objectForKey:@"view0_image3"]]];
        }
        
        self.createTour.currentViewpointIndex = 0;
        if(![[self.results objectForKey:@"view1_image0"] isEqualToString:@"null"])
        {
            //NSLog(@"Comparing %d and %d", self.createTour.currentView.jumpIndex, self.createTour.currentViewpointIndex);
            while((int)self.createTour.currentView.jumpIndex != self.createTour.currentViewpointIndex)
            {
                [self.createTour moveRight];
            }
            [self.createTour makeJump];
            [self.createTour setViewImage:[self getImage:[self.results objectForKey:@"view1_image0"]]];
            if(![[self.results objectForKey:@"view1_image1"] isEqualToString:@"null"])
            {
                [self.createTour moveRight];
                [self.createTour setViewImage:[self getImage:[self.results objectForKey:@"view1_image1"]]];
            }
            if(![[self.results objectForKey:@"view1_image2"] isEqualToString:@"null"])
            {
                [self.createTour moveRight];
                [self.createTour setViewImage:[self getImage:[self.results objectForKey:@"view1_image2"]]];
            }
            if(![[self.results objectForKey:@"view1_image3"] isEqualToString:@"null"])
            {
                [self.createTour moveRight];
                [self.createTour setViewImage:[self getImage:[self.results objectForKey:@"view1_image3"]]];
            }
        }
    }
    
    //NSLog(@"Create Tour is %@", self.createTour.tour);
    
    return self.createTour.getTour;
}

-(UIImage *)getImage:(NSString *)url
{
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    CGSize scaleSize = CGSizeMake(320,430);
    UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,scaleSize.width, scaleSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    //NSLog(@"Size height is %f", image.size.height);
    return image;
}

-(void)viewWillDisappear:(BOOL)animate
{
    [self.view removeFromSuperview];
}

@end
