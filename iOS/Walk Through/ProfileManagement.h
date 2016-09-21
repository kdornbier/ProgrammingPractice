//
//  ProfileManagement.h
//  Walk Through
//
//  Created by Nate Halbmaier on 2/15/14.
//  Copyright (c) 2014 Nate Halbmaier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileManagement : NSObject

@property (assign, nonatomic) int uniqueId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *city;

-(id)initWithUniqueId:(int)uniqueId name:(NSString *)name email:(NSString *)email password:(NSString *)password phone:(NSString *)phone city:(NSString *)city state:(NSString *)state;

-(void)initWithValues:(NSString *)name :(NSString *)email :(NSString *)password :(NSString *)phone :(NSString *)state :(NSString *)city;
+(ProfileManagement *)getInstance;

-(void)resetVariables;

@end
