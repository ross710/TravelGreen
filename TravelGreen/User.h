//
//  User.h
//  LoginPage
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic) id userId;
@property(nonatomic) int weight;
@property(nonatomic) int carbonEmission;
@property(nonatomic) int milesWalked;
@property(nonatomic) int milesBiked;
@property(nonatomic) int milesDriven;
@property(nonatomic) int milesPt;
@property(nonatomic) int carMpg;
@property(nonatomic) int bikeMpg;
@property(nonatomic) NSString *sex;
@property(nonatomic) NSString *username;

@end
