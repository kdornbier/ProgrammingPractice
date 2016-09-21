//
//  Virtual_Tour.m
//  VirtualTour
//
//  Created by Kaitlyn Dornbier on 2/18/14.
//  Copyright (c) 2014 Kaitlyn Dornbier. All rights reserved.
//

#import "Virtual_Tour.h"

@implementation Virtual_Tour

-(NSMutableArray *) viewPointArray
{
    if(!_viewPointArray) _viewPointArray = [[NSMutableArray alloc] init];
    return _viewPointArray;
}

@end
