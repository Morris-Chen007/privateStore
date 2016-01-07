//
//  CoreData.m
//  DemoCoreData
//
//  Created by Shawn Welch on 10/23/11.
//  Copyright (c) 2011 anythingsimple.com. All rights reserved.
//

#import "CoreData.h"

#define iCloudSyncIfAvailable YES
#define ManagedObjectModelFileName @"DemoCoreData"

//iCloud Parameters
#warning Must replace these values with your information if using iCloud
#define UBIQUITY_CONTAINER_IDENTIFIER @"[TEAM_ID].com.mycompany.myapp"
#define UBIQUITY_CONTENT_NAME_KEY @"com.mycompany.myapp.CoreData"

static CoreData *sharedModel = nil;

@implementation CoreData
@synthesize delegates = _delegates;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

//iCloud
@synthesize iCloudAvailable = _iCloudAvailable;

#pragma mark - Singleton Creation

+ (id)sharedModel:(id<CoreDataDelegate>)delegate{
	@synchronized(self){
		if(sharedModel == nil)
			sharedModel = [[self alloc] initWithDelegate:delegate];
		else {
			if(delegate)
				[sharedModel.delegates addObject:delegate];
		}
	}
	return sharedModel;
}
+ (id)allocWithZone:(NSZone *)zone{
    @synchronized(self) {
        if(sharedModel == nil)  {
            sharedModel = [super allocWithZone:zone];
            return sharedModel;
        }
    }
    return nil;
}
+ (void)addDelegate:(id<CoreDataDelegate>)delegate{
	[sharedModel.delegates addObject:delegate];
}
+ (void)removeDelegate:(id<CoreDataDelegate>)delegate{
	[sharedModel.delegates removeObjectIdenticalTo:delegate];
}
- (id)initWithDelegate:(id<CoreDataDelegate>)newDelegate{
    self = [super init];
	if(self){
    
		_delegates = [[NSMutableArray alloc] init];
		if(newDelegate)
			[_delegates addObject:newDelegate];
		
        //Test for iCloud availability
        if(iCloudSyncIfAvailable){
            [[NSBundle mainBundle] bundleIdentifier];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *contentURL = [fileManager URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_IDENTIFIER];
            if(contentURL)
                self.iCloudAvailable = YES;
            else
                self.iCloudAvailable = NO;
        }
        
        
        __managedObjectContext = [self managedObjectContext];
		
	}
	return self;
}

#pragma mark - Model Accessors

- (NSArray*)reminders{

    // Create a new fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    // Set the entity of the fetch request to be our Issues object
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" 
                                                   inManagedObjectContext:__managedObjectContext];
    [request setEntity:entity];	

    // Set up the request sorting
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
                                        initWithKey:@"date"
                                        ascending:YES];

    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    // Fetch the results
    // Since there is no predicate defined for this request,
    // The results will be all issues in the managed object context
    NSError *error = nil;
    NSArray *fetchResults = [__managedObjectContext executeFetchRequest:request 
                                                                  error:&error];    
    // If the results found an object, return the first one found
    if([fetchResults count] > 0)
        return fetchResults;
    
    // Nothing found, return nil
    return nil;

}
- (NSArray*)notifications{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notification" 
                                              inManagedObjectContext:__managedObjectContext];
	[request setEntity:entity];	
	
	NSError *error = nil;
    NSArray *fetchResults = [__managedObjectContext executeFetchRequest:request 
                                                                  error:&error];
	if (fetchResults == nil) {
		NSLog(@"Error retrieving Notifications");
        return nil;
	}
	
	if([fetchResults count] > 0)
		return fetchResults;
	
	return nil;
}

- (NSArray*)remindersWithTitle:(NSString*)title{
    // Create a new Fetch Request
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // Set the entity of our request to a Reminder in our
    // our managed object context
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" 
                                             inManagedObjectContext:__managedObjectContext];
	[request setEntity:entity];
	
    // Set up a predicate limiting the results of the request
    // We only want the issue with the name provided
	NSPredicate *query = [NSPredicate predicateWithFormat:@"title == %@",title];
	[request setPredicate:query];
    
    // Set up the request sorting
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
                                        initWithKey:@"date"
                                        ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
    // Fetch the results
	NSError *error = nil;
	NSArray *fetchResults = [__managedObjectContext executeFetchRequest:request 
                                                                  error:&error];
	if (fetchResults == nil) {
		NSLog(@"Error retrieving Reminders");
        return nil;
	}
	
    // Since names are not unique, we are returning an array of all matches found
	if([fetchResults count] > 0)
        return fetchResults;
	
    // No results were found, return nil
	return nil;
}
- (NSArray*)notificationsWithFireDate:(NSDate*)date{
    // Create a new Fetch Request
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // Set the entity of our request to a Reminder in our
    // our managed object context
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notification" 
                                              inManagedObjectContext:__managedObjectContext];
	[request setEntity:entity];
	
    // Set up a predicate limiting the results of the request
    // We only want the issue with the name provided
	NSPredicate *query = [NSPredicate predicateWithFormat:@"date == %@",date];
	[request setPredicate:query];
    
    // Set up the request sorting
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
                                        initWithKey:@"date"
                                        ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
    // Fetch the results
	NSError *error = nil;
	NSArray *fetchResults = [__managedObjectContext executeFetchRequest:request 
                                                                  error:&error];
	if (fetchResults == nil) {
		NSLog(@"Error retrieving Notifications");
        return nil;
	}
	
    // Since names are not unique, we are returning an array of all matches found
	if([fetchResults count] > 0)
        return fetchResults;
	
    // No results were found, return nil
	return nil;
    
}

- (Reminder*)makeReminderWithTitle:(NSString *)title{

    Reminder *newReminder = (Reminder*)[NSEntityDescription insertNewObjectForEntityForName:@"Reminder"
                                                            inManagedObjectContext:__managedObjectContext];
    [newReminder setTitle:title];

    return newReminder;
}

- (Notification*)makeNotificationWithFireDate:(NSDate*)fireDate{
 
    Notification *newNotification = (Notification*)[NSEntityDescription insertNewObjectForEntityForName:@"Notification"
                                                                                 inManagedObjectContext:__managedObjectContext];
    [newNotification setFireDate:fireDate];
    
    return newNotification;
    
}




- (BOOL)removeAllReminders{
    for(Reminder *reminder in [self reminders]){
        [__managedObjectContext deleteObject:reminder];  
    }
    return [self saveContext];
}

- (BOOL)removeAllNotifications{
    for(Notification *notification in [self notifications]){
        [__managedObjectContext deleteObject:notification];    
    }
    return [self saveContext];
}

- (BOOL)removeReminders:(NSArray *)reminders{
    // In most cases the reminders array will contain 1 object,
    // but by designing the model this way we make it possible for multiple
    // reminders to be deleted with only one save operation on the context
    for(Reminder *reminder in reminders){
        [__managedObjectContext deleteObject:reminder];
    }
    return [self saveContext];
}
   
- (BOOL)removeNotifications:(NSArray *)notifications{
    // In most cases the notifications array will contain 1 object,
    // but by designing the model this way we make it possible for multiple
    // notifications to be deleted with only one save operation on the context
    for(Notification *notification in notifications){
        [__managedObjectContext deleteObject:notification];
    }
    return [self saveContext];
}



#pragma mark - Managed Object Context

- (BOOL)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil){
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return NO;
        } 
    }
    else{
        NSLog(@"Managed Object Context is nil");
        return NO;
    }
    NSLog(@"Context Saved, iCloud should sync if enabled");
    
    return YES;
}

#pragma mark - Undo/Redo Operations


- (void)undo{
    [__managedObjectContext undo];

}

- (void)redo{
    [__managedObjectContext redo];
}

- (void)rollback{
    [__managedObjectContext rollback];
}

- (void)reset{
    [__managedObjectContext reset];
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext{
    if (__managedObjectContext != nil){
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil){
        
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] 
                                       initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [moc performBlockAndWait:^(void){
            // Set up an undo manager, not included by default
            NSUndoManager *undoManager = [[NSUndoManager alloc] init];
            [undoManager setGroupsByEvent:NO];
            [moc setUndoManager:undoManager];
            
            
            // Set persistent store
            [moc setPersistentStoreCoordinator:coordinator];
            
            //icloud
            if(iCloudSyncIfAvailable){
                [[NSNotificationCenter defaultCenter] addObserver:self 
                                                         selector:@selector(persistentStoreDidChange:) 
                                                             name:NSPersistentStoreDidImportUbiquitousContentChangesNotification 
                                                           object:coordinator];
            }
        }];

        
        __managedObjectContext = moc;
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ManagedObjectModelFileName withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (__persistentStoreCoordinator != nil){
        return __persistentStoreCoordinator;
    }
    
    // Set up persistent Store Coordinator
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // Set up SQLite db and options dictionary
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",ManagedObjectModelFileName]];
    NSDictionary *options = nil;
    
    // If we want to use iCloud, set up 
    if(iCloudSyncIfAvailable && _iCloudAvailable){
        [[NSBundle mainBundle] bundleIdentifier];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *contentURL = [fileManager URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_IDENTIFIER];
        
        options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 UBIQUITY_CONTENT_NAME_KEY,
                                 NSPersistentStoreUbiquitousContentNameKey,
                                 contentURL,
                                 NSPersistentStoreUbiquitousContentURLKey, 
                                 nil];

    }
    else if(!_iCloudAvailable){
        NSLog(@"Attempted to set up iCloud Core Data Stack, but iCloud is unvailable");
    }
    
    // Add the persistent store to the persistent store coordinator
    NSError *error = nil;
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                    configuration:nil 
                                                              URL:storeURL 
                                                          options:options 
                                                            error:&error]){
        // Handle the error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }  
    
   
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - iCloud Functionality

- (void)persistentStoreDidChange:(NSNotification*)notification{
    NSLog(@"Change Detected!");
    [__managedObjectContext performBlockAndWait:^(void){
        [__managedObjectContext mergeChangesFromContextDidSaveNotification:notification];

        for(id<CoreDataDelegate>delegate in _delegates){
            if([delegate respondsToSelector:@selector(persistentStoreDidChange)])
               [delegate persistentStoreDidChange];
        }
    }];
}

@end
