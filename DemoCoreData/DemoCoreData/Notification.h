//
//  Notification.h
//  DemoCoreData
//
//  Created by Shawn Welch on 2/13/12.
//  Copyright (c) 2012 anythingsimple.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notification : NSManagedObject

@property (nonatomic, retain) NSDate * fireDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * messageBody;
@property (nonatomic, retain) NSManagedObject *reminder;

@end
