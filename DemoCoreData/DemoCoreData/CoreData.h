//
//  CoreData.h
//  DemoCoreData
//
//  Created by Shawn Welch on 10/23/11.
//  Copyright (c) 2011 anythingsimple.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Reminder.h"
#import "Notification.h"

@protocol CoreDataDelegate;
@interface CoreData : NSObject {

}

@property (nonatomic, strong) NSMutableArray *delegates;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//Chapter 3: iCloud
@property (nonatomic) BOOL iCloudAvailable;

// Singleton Creation
+ (id)sharedModel:(id<CoreDataDelegate>)delegate;
+ (void)addDelegate:(id<CoreDataDelegate>)delegate;
+ (void)removeDelegate:(id<CoreDataDelegate>)delegate;
+ (id)allocWithZone:(NSZone *)zone;

- (id)initWithDelegate:(id<CoreDataDelegate>)newDelegate;

// Context Operations
- (void)undo;
- (void)redo;
- (void)rollback;
- (void)reset;
- (BOOL)saveContext;

// Model Accessors (These are the methods you edit and create for your specific model)
- (NSArray*)reminders;
- (NSArray*)notifications;

- (NSArray*)remindersWithTitle:(NSString*)title;
- (NSArray*)notificationsWithFireDate:(NSDate*)date;

- (Reminder*)makeReminderWithTitle:(NSString *)title;
- (Notification*)makeNotificationWithFireDate:(NSDate*)fireDate;

- (BOOL)removeReminders:(NSArray*)reminders;
- (BOOL)removeAllReminders;
- (BOOL)removeNotifications:(NSArray*)notifications;
- (BOOL)removeAllNotifications;


// Core Data Utilities
- (NSURL *)applicationDocumentsDirectory;

@end

@protocol CoreDataDelegate <NSObject>
- (void)persistentStoreDidChange;

@end
