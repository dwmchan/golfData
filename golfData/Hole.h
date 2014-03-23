//
//  Hole.h
//  golfData
//
//  Created by Donald Chan on 23/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Round;

@interface Hole : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * par;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * matchIndex;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSNumber * handicap;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) Round *round;

@end
