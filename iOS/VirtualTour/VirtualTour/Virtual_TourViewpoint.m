//
//  Virtual_TourViewpoint.m
//  VirtualTour
//
//  Created by Kaitlyn Dornbier on 2/17/14.
//  Copyright (c) 2014 Kaitlyn Dornbier. All rights reserved.
//

#import "Virtual_TourViewpoint.h"

@implementation Virtual_TourViewpoint

-(NSMutableArray *)imageArray
{
    if(!_imageArray) _imageArray = [[NSMutableArray alloc] init];
    return _imageArray;
}

@end
