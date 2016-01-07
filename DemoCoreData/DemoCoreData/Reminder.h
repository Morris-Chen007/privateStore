//
//  Reminder.h
//  DemoCoreData
//
//  Created by Shawn Welch on 2/13/12.
//  Copyright (c) 2012 anythingsimple.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notification;

@interface Reminder : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *notifications;
@end

@interface Reminder (CoreDataGeneratedAccessors)

- (void)addNotificationsObject:(Notification *)value;
- (void)removeNotificationsObject:(Notification *)value;
- (void)addNotifications:(NSSet *)values;
- (void)removeNotifications:(NSSet *)values;

@end
