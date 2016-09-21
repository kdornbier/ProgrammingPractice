//
//  Virtual_Tour.m
//  Walk Through
//
//  Created by Nate Halbmaier on 4/2/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "Virtual_Tour.h"

@implementation Virtual_Tour

static Virtual_Tour *singletonInstance;

-(NSMutableArray *) viewPointArray
{
    if(!_viewPointArray) _viewPointArray = [[NSMutableArray alloc] init];
    return _viewPointArray;
}

@end
