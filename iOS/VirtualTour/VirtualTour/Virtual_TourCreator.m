//
//  Virtual_TourCreator.m
//  VirtualTour
//
//  Created by Kaitlyn Dornbier on 2/24/14.
//  Copyright (c) 2014 Kaitlyn Dornbier. All rights reserved.
//

#import "Virtual_TourCreator.h"

#define MAXIMUM_PANORAMA_IMAGES 4
#define MAXIMUM_VIEWPOINTS 2

@implementation Virtual_TourCreator

-(Virtual_Tour *)tour
{
    if(!_tour) _tour = [[Virtual_Tour alloc] init];
    return _tour;
}

-(Virtual_TourViewpoint *)currentView
{
    if(!_currentView)
    {
        _currentView = [[Virtual_TourViewpoint alloc] init];
        [self.tour.viewPointArray addObject:_currentView];
        self.currentViewpointIndex = 0;
    }
    return _currentView;
}

-(void) setViewImage: (UIImage *)image
{
    if(self.currentViewpointIndex > self.currentView.imageArray.count)
    {
        [self.currentView.imageArray insertObject:image atIndex:0];
        self.currentViewpointIndex = 0;
    } else {
        [self.currentView.imageArray setObject:image atIndexedSubscript:self.currentViewpointIndex];
    }
}

-(void) moveRight
{
    if(self.currentView.imageArray.count < MAXIMUM_PANORAMA_IMAGES)
    {
        self.currentViewpointIndex = (self.currentViewpointIndex + 1) % (self.currentView.imageArray.count + 1);
    } else {
        self.currentViewpointIndex = (self.currentViewpointIndex + 1) % MAXIMUM_PANORAMA_IMAGES;
    }
}

-(void) moveLeft
{
    if(self.currentView.imageArray.count < MAXIMUM_PANORAMA_IMAGES)
    {
        if(self.currentView.imageArray.count == 0)
        {
            self.currentViewpointIndex = 0;
        } else if(self.currentViewpointIndex == 0)
        {
            self.currentViewpointIndex = self.currentView.imageArray.count + 1.0;
        } else if(self.currentViewpointIndex > self.currentView.imageArray.count){
            self.currentViewpointIndex = self.currentView.imageArray.count - 1.0;
        } else {
            self.currentViewpointIndex = (self.currentViewpointIndex - 1) % (self.currentView.imageArray.count + 1);
        }
    } else {
        if(self.currentViewpointIndex == 0)
        {
            self.currentViewpointIndex = 3;
        } else {
            self.currentViewpointIndex = (self.currentViewpointIndex - 1) % MAXIMUM_PANORAMA_IMAGES;
        }
    }
}

-(void) makeJump
{
    NSLog(@"Made jump");
    Virtual_TourViewpoint *newView = [[Virtual_TourViewpoint alloc] init];
    newView.jumpToViewpoint = self.currentView;
    self.currentView.jumpIndex = self.currentViewpointIndex;
    newView.jumpIndex = 0;
    [self.tour.viewPointArray addObject:newView];
    self.currentView.jumpToViewpoint = newView;
    self.currentView = newView;
    self.currentViewpointIndex = 0;
}

-(void) jumpBack
{
    NSLog(@"Jumping back");
    self.currentViewpointIndex = self.currentView.jumpIndex;
    self.currentView = self.currentView.jumpToViewpoint;
}

-(BOOL) canJump
{
    return self.tour.viewPointArray.count < MAXIMUM_VIEWPOINTS;
}

@end
