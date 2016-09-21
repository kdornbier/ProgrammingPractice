//
//  Virtual_TourViewPoint.m
//  Walk Through
//
//  Created by Nate Halbmaier on 4/2/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "Virtual_TourViewpoint.h"

@implementation Virtual_TourViewpoint

-(NSMutableArray *)imageArray
{
    if(!_imageArray) _imageArray = [[NSMutableArray alloc] init];
    return _imageArray;
}

@end
