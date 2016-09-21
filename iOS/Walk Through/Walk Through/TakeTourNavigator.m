//
//  TakeTourNavigator.m
//  Walk Through
//
//  Created by Kaitlyn Dornbier on 4/7/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "TakeTourNavigator.h"

@implementation TakeTourNavigator

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

-(void) moveRight
{
    self.currentViewpointIndex = (self.currentViewpointIndex + 1) % (self.currentView.imageArray.count);
}

-(void) moveLeft
{
    self.currentViewpointIndex = (self.currentViewpointIndex - 1) % (self.currentView.imageArray.count);
}

-(void) jumpBack
{
    NSLog(@"Jumping back");
    //self.currentViewpointIndex = self.currentView.jumpIndex;
    self.currentView = self.currentView.jumpToViewpoint;
    self.currentViewpointIndex = self.currentView.jumpIndex;
}

-(Virtual_Tour *)getTour{
    return self.tour;
}


@end
