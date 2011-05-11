//
//  TestChocrotaryTableViewDataSource.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 06/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryTaskTableViewController.h"
#import "ChocrotaryTaskTableViewController.h"
#import "ChocrotaryNotebook.h"
#import "ChocrotaryController.h"
#import "ChocrotarySecretaryInboxPerspective.h"
#import "ChocrotarySecretaryScheduledPerspective.h"
#import "ChocrotarySecretaryScheduledForTodayPerspective.h"
#import "ChocrotarySecretaryProjectPerspective.h"
#import "ChocrotaryProjectTableViewDataSource.h"
#import "ChocrotaryProjectTableViewDelegate.h"

@implementation TestChocrotaryTaskTableViewController
-(void) testInboxTasks {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	/*ChocrotaryTask *task3 =*/[secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task1];
	[task2 scheduleFor:[NSDate date]];
	
	ChocrotaryTaskTableViewController *dataSource = [ChocrotaryTaskTableViewController new];
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryInboxPerspective newWithSecretary:secretary];
	[dataSource setPerspective:perspective];
	
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have only one");
	
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"done"];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:@"description"];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" desxc column should be Not nil");
	STAssertEqualObjects(description, @"Buy pequi", @"Wrong task description");
	
	[column setIdentifier:@"project"];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:@"scheduled"];
	NSString *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(when,@"", @"Should be today");	
	
}

- (void) testScheduleTasks {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	/*ChocrotaryTask *task1 = */[secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	NSDate *date = [NSDate date];
	[task2 scheduleFor:date];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60.0f];
	[task3 scheduleFor:future];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task3];
	
	ChocrotaryTaskTableViewController *dataSource = [ChocrotaryTaskTableViewController new];
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryScheduledPerspective newWithSecretary:secretary];
	[dataSource setPerspective:perspective];	
	
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 2L, @"Should have two tasks");
	
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"done"];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should be not done");
	
	[column setIdentifier:@"description"];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Add hidden option", @"Wrong task description");
	description = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(description, @" description co lumn should be Not nil");
	STAssertEqualObjects(description, @"Buy pequi", @"Wrong task description");
	
	[column setIdentifier:@"project"];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");
	projectName = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(projectName, @"project column should be Not nil");
	STAssertEqualObjects(projectName, @"Chocrotary", @"Wrong project");
	
	
	[column setIdentifier:@"scheduled"];
	NSDatePickerCell *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceDate:date] < 24*60.0, @"Should be today");
	when = [dataSource tableView:nil objectValueForTableColumn:column row:1L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceDate:future] < 24*60.0, @"Should be future date");
}

-(void) testScheduleForToday {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	/*ChocrotaryTask *task1 = */[secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	// Scheduled for today
	NSDate *date = [NSDate date];
	[task2 scheduleFor:date];
	// Scheduled for future
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:72*60*60];
	[task3 scheduleFor:future];
	
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[project addTask:task3];
	
	ChocrotaryTaskTableViewController *dataSource = [ChocrotaryTaskTableViewController new];
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryScheduledForTodayPerspective newWithSecretary:secretary];
	[dataSource setPerspective:perspective];
	
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have one");
	
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"done"];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:@"description"];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Add hidden option", @"Wrong task description");
	
	[column setIdentifier:@"project"];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:@"scheduled"];
	NSDatePickerCell *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceDate:date] < 24*60.0, @"Should be today");	
}

-(void) testProject {
	ChocrotarySecretary *secretary = [ChocrotarySecretary new];
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	/*ChocrotaryTask *task3 =*/[secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project1 = [secretary createProject:@"Chocrotary"];
	[project1 addTask:task1];
	ChocrotaryProject *project2 = [secretary createProject:@"libsecretary"];
	[project2 addTask:task2];
	[task1 scheduleFor:[NSDate date]];
	
	ChocrotaryTaskTableViewController *dataSource = [ChocrotaryTaskTableViewController new];
	ChocrotarySecretaryPerspective *perspective = [ChocrotarySecretaryProjectPerspective newWithSecretary:secretary];
	[dataSource setPerspective:perspective];
	// Testing with one project
	[(ChocrotarySecretaryProjectPerspective*)perspective setProject:project1];
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have one");
	
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"done"];
	NSButtonCell * doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:@"description"];
	NSString *description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Improve interface", @"Wrong task description");
	
	[column setIdentifier:@"project"];
	NSString *projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"Chocrotary", @"Should have project Chocrotary");	
	
	[column setIdentifier:@"scheduled"];
	NSDatePickerCell *when = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertTrue([[when dateValue] timeIntervalSinceNow] < 10, @"Should be today");	
	
	// Testing with another project
	[(ChocrotarySecretaryProjectPerspective*)perspective setProject:project2];
	STAssertEquals([dataSource numberOfRowsInTableView:nil], 1L, @"Should have one");
	
	[column setIdentifier:@"done"];
	doneCheckbox = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:@"description"];
	description = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, @"Add hidden option", @"Wrong task description");
	
	[column setIdentifier:@"project"];
	projectName = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"libsecretary", @"Should have project Chocrotary");	
	
	[column setIdentifier:@"scheduled"];
	NSString *nothing = [dataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(nothing, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(nothing, @"", @"Should have no date");	
}

-(void) testSelectProjectInPopUpMenu {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	
	ChocrotaryProject *project1 = [notebook.secretary createProject:@"A project"];
	ChocrotaryProject *project2 = [notebook.secretary createProject:@"Another project"];
	
	ChocrotaryTask *task1 = [notebook.secretary createTask:@"task 1"],
	*task2 = [notebook.secretary createTask:@"task 2"];
	[project1 addTask:task1];
	[project2 addTask:task2];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	NSTableView *projectTableView = [NSTableView new];
	NSTableView *taskTableView = [NSTableView new];
	
	NSPopUpButtonCell *projectCell = [NSPopUpButtonCell new];
	[projectCell addItemWithTitle:@"A project"];
	[projectCell addItemWithTitle:@"Another project"];
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"project"];
	[column setDataCell:projectCell];
	[taskTableView addTableColumn:column];
	
	// Finally!!!

	ChocrotaryTaskTableViewController *taskController= [ChocrotaryTaskTableViewController new];
	
	ChocrotaryProjectTableViewDataSource *projectDataSource =
	[[ChocrotaryProjectTableViewDataSource alloc] init];
	ChocrotaryProjectTableViewDelegate *projectDelegate =
	[[ChocrotaryProjectTableViewDelegate alloc] init];
	
	
	// Here controller will be needed
	projectDataSource.controller = controller;
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	[taskTableView setDelegate:taskController];
	[taskTableView setDataSource:taskController];
	
	[controller setTaskTableView:taskTableView];
	[controller setProjectTableView:projectTableView];
	[controller setTaskTableViewDataSource:taskController];
	
	NSIndexSet *index = [[NSIndexSet alloc] 
						 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	// The actually relevant part is here
	[taskController tableView:taskTableView willDisplayCell:projectCell 
				  forTableColumn:column row:0];
	STAssertEqualObjects([projectCell titleOfSelectedItem], @"A project", @"Should be the first project");
	
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	// The actually relevant part is here
	[taskController tableView:taskTableView willDisplayCell:projectCell 
				  forTableColumn:column row:0];
	STAssertEqualObjects([projectCell titleOfSelectedItem], @"Another project", @"Should be the second project");
	
}

-(void) testMarkAsDone{
#warning implement testMarkAsDone
}
-(void) testEditDescription{
#warning implement testEditDescription
}
-(void) testMoveToProject {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"somefile"];
	
	ChocrotaryProject *project1 = [notebook.secretary createProject:@"A project"];
	ChocrotaryProject *project2 = [notebook.secretary createProject:@"Another project"];
	
	ChocrotaryTask *task1 = [notebook.secretary createTask:@"task 1"],
	*task2 = [notebook.secretary createTask:@"task 2"];
	[project1 addTask:task1];
	[project2 addTask:task2];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	NSTableView *projectTableView = [NSTableView new];
	NSTableView *taskTableView = [NSTableView new];
	
	// Creating popup button for selecting projects, anda column
	NSPopUpButtonCell *projectCell = [NSPopUpButtonCell new];
	//    Creating items for popup button. itemNone represents the empty line for
	//    selecting no project
	NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:@"A project" action:nil keyEquivalent:@""],
		*item2 = [[NSMenuItem alloc] initWithTitle:@"Another project" action:nil keyEquivalent:@""],
		*itemNone = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
	[itemNone setTag:-1];
	[item1 setTag:0];
	[item2 setTag:1];
	[[projectCell menu] addItem:itemNone];
	[[projectCell menu] addItem:item1];
	[[projectCell menu] addItem:item2];
	NSTableColumn *stub1 = [[NSTableColumn alloc] initWithIdentifier:@"done"],
	*stub2= [[NSTableColumn alloc] initWithIdentifier:@"description"];
	[taskTableView addTableColumn:stub1];
	[taskTableView addTableColumn:stub2];	
	
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"project"];
	[column setDataCell:projectCell];
	[taskTableView addTableColumn:column];
	
	// Finally!!!
	
	ChocrotaryTaskTableViewController *taskController= [ChocrotaryTaskTableViewController new];
	
	ChocrotaryProjectTableViewDataSource *projectDataSource =
	[[ChocrotaryProjectTableViewDataSource alloc] init];
	ChocrotaryProjectTableViewDelegate *projectDelegate =
	[[ChocrotaryProjectTableViewDelegate alloc] init];
	
	
	// Here controller will be needed
	projectDataSource.controller = controller;
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	[taskTableView setDelegate:taskController];
	[taskTableView setDataSource:taskController];
	[controller setTaskTableView:taskTableView];
	[controller setProjectTableView:projectTableView];
	[controller setTaskTableViewDataSource:taskController];
	
	NSIndexSet *index = [[NSIndexSet alloc] 
						 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	// Verifying if tasks are correctly associated to projects
	[taskController tableView:taskTableView willDisplayCell:projectCell   forTableColumn:column row:0];

	STAssertEqualObjects([projectCell titleOfSelectedItem], @"A project", @"Should be the first project");
	STAssertEquals([taskTableView numberOfRows], 1L, @"Should should have only one");
	index = [[NSIndexSet alloc] initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject+1];

	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[taskController tableView:taskTableView willDisplayCell:projectCell  forTableColumn:column row:0];
	STAssertEqualObjects([projectCell titleOfSelectedItem], @"Another project", @"Should be the second project");
	STAssertEquals([taskTableView numberOfRows], 1L, @"Should should have only one");
	
	// Now let us edit the project of a task
	index = [[NSIndexSet alloc] initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	NSNumber *number = [[NSNumber alloc] initWithInteger:2];
	
	STAssertTrue([taskController respondsToSelector:@selector(tableView:setObjectValue:forTableColumn:row:)], @"");
	NSLog(@"Itemarray %d", [[[projectCell menu] itemArray] count]);
 	[taskController tableView:taskTableView setObjectValue:number forTableColumn:column row:0];

	// Should have no more tasks
	STAssertEquals([taskTableView numberOfRows], 0L, @"Should no task");
	// Looking at other project
	index = [[NSIndexSet alloc] initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	// There should be two tasks
	STAssertEquals([taskTableView numberOfRows], 2L, @"Should two tasks");

}
-(void) testSchedule {
#warning implement testSchedule
}

@end
