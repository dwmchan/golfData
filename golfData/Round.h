//
//  Round.h
//  golfData
//
//  Created by Donald Chan on 23/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hole;

@interface Round : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * roundID;
@property (nonatomic, retain) NSNumber * out;
@property (nonatomic, retain) NSNumber * in;
@property (nonatomic, retain) NSNumber * totalOut;
@property (nonatomic, retain) Hole *holes;

@end
