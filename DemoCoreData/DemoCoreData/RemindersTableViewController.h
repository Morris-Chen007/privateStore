//
//  RemindersTableViewController.h
//  DemoCoreData
//
//  Created by Shawn Welch on 2/13/12.
//  Copyright (c) 2012 anythingsimple.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"

@interface RemindersTableViewController : UITableViewController <CoreDataDelegate>{
    CoreData *sharedModel;
    NSMutableArray *_reminders;
}

@end
