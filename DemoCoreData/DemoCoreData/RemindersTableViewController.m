//
//  RemindersTableViewController.m
//  DemoCoreData
//
//  Created by Shawn Welch on 2/13/12.
//  Copyright (c) 2012 anythingsimple.com. All rights reserved.
//

#import "RemindersTableViewController.h"


@implementation RemindersTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Get our Singleton Model
        sharedModel = [CoreData sharedModel:self];
        
        // Initialize our local reminders array with all remidners
        _reminders = [[NSMutableArray alloc] initWithArray:[sharedModel reminders]];
        
        self.title = @"Reminders";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addReminder:)];
    self.navigationItem.rightBarButtonItem = add;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_reminders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Reminder *reminder = [_reminders objectAtIndex:indexPath.row];
    
    cell.textLabel.text = reminder.title;
    cell.detailTextLabel.text = reminder.body;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Update the shared model
        [sharedModel removeReminders:[NSArray arrayWithObject:[_reminders objectAtIndex:indexPath.row]]];
        [sharedModel saveContext];
        
        // Update local array and tableview
        [_reminders removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Navigation logic may go here. Create and push another view controller.
}

#pragma mark - Core Data Delegate
- (void)persistentStoreDidChange{
    //This method is called when the persistent store changes via iCloud
    // The Model takes care of all the data merging, all we need to do is refresh our view
    [_reminders removeAllObjects];
    [_reminders addObjectsFromArray:[sharedModel reminders]];

    
    [self.tableView reloadData];
}

#pragma mark - Button Actions

- (void)addReminder:(UIBarButtonItem*)button{
 
    Reminder *newReminder = [sharedModel makeReminderWithTitle:@"New Reminder"];
    [newReminder setBody:@"This is the new Reminder body"];
    [newReminder setDate:[NSDate date]];
    
    [sharedModel saveContext];
    [self persistentStoreDidChange];
}

@end
