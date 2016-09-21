//
//  ProfileManagement.m
//  Walk Through
//
//  Created by Nate Halbmaier on 2/15/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import "ProfileManagement.h"

@implementation ProfileManagement

static ProfileManagement *singletonInstance;

+ (ProfileManagement*)getInstance{
    if (singletonInstance == nil) {
        NSLog(@"New Instance Created");
        singletonInstance = [[super alloc] init];
    }
    return singletonInstance;
}

- (id)initWithUniqueId:(int)uniqueId name:(NSString *)name email:(NSString *)email password:(NSString *)password phone:(NSString *)phone city:(NSString *)city state:(NSString *)state {
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.name = name;
        self.email = email;
        self.password = password;
        self.phone = phone;
        self.city = city;
        self.state = state;
    }
    return self;
}

-(void)initWithValues:(NSString *)name :(NSString *)email :(NSString *)password :(NSString *)phone :(NSString *)state :(NSString *)city{
    //ProfileManagement *profile = [ProfileManagement getInstance];
    self.name = name;
    self.email = email;
    self.password = password;
    self.phone = phone;
    self.state = state;
    self.city = city;
}

-(void)resetVariables{
    self.name = @"";
    self.email = @"";
    self.password = @"";
    self.phone = @"";
    self.state = @"";
    self.city = @"";
}

@end
