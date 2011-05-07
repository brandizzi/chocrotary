//
//  TestChocrotaryController.m
//  Secretary
//
//  Created by Adam Victor Nazareth Brandizzi on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestChocrotaryController.h"
#import "ChocrotaryController.h"
#import "ChocrotaryProjectTableViewDataSource.h"
#import "ChocrotaryProjectTableViewDelegate.h"
#import "ChocrotaryTaskTableViewDataSource.h"
#import "ChocrotaryTaskTableViewDelegate.h"


@implementation TestChocrotaryController

-(void) testUpdateProjectsMenu {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	[notebook.secretary createProject:@"A project"];
	[notebook.secretary createProject:@"Another project"];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	NSMenu *menu = controller.projectsMenu;
	STAssertNotNil(menu, @"should have menu");
	
	STAssertEquals([menu numberOfItems], 3L, @"Should have three");
	STAssertEqualObjects([[menu itemAtIndex:0] title], @"", @"Should have empty string");
	STAssertEquals([[menu itemAtIndex:0] tag], ChocrotaryControllerNoProject, @"Should point to notthing");
	STAssertEqualObjects([[menu itemAtIndex:1] title], @"A project", @"Should have first project");
	STAssertEquals([[menu itemAtIndex:1] tag], 0L, @"Should be index of project 1");
	STAssertEqualObjects([[menu itemAtIndex:2] title], @"Another project",  @"Should have snd project");
	STAssertEquals([[menu itemAtIndex:2] tag], 1L, @"Should be index of projct 2");
	
	[controller addProject:nil];
	
	STAssertEquals([menu numberOfItems], 4L, @"Should have one more");
	STAssertEqualObjects([[menu itemAtIndex:0] title], @"", @"Should have empty string");
	STAssertEquals([[menu itemAtIndex:0] tag], ChocrotaryControllerNoProject, @"Should point to notthing");
	STAssertEqualObjects([[menu itemAtIndex:1] title], @"A project", @"Should have first project");
	STAssertEquals([[menu itemAtIndex:1] tag], 0L, @"Should be index of project 1");
	STAssertEqualObjects([[menu itemAtIndex:2] title], @"Another project",  @"Should have snd project");
	STAssertEquals([[menu itemAtIndex:2] tag], 1L, @"Should be index of projct 2");
	STAssertEqualObjects([[menu itemAtIndex:3] title], @"",  @"Should have title of new project (still empty)");
	STAssertEquals([[menu itemAtIndex:3] tag], 2L, @"Should be index of new project");
	
	remove("fluflufile");
}

-(void) testChangePerspectiveToInbox {
	// Content
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	ChocrotaryProject *project1 = [notebook.secretary createProject:@"Project 1"];
	ChocrotaryProject *project2 = [notebook.secretary createProject:@"Project 2"];
	
	ChocrotaryTask *inboxTask = [notebook.secretary createTask:@"Inbox task"];
	ChocrotaryTask *scheduledTask = [notebook.secretary createTask:@"Scheduled task"];
	[scheduledTask scheduleFor:[NSDate dateWithTimeIntervalSinceNow:24*60*60*4]];
	ChocrotaryTask *scheduledForTodayTask = [notebook.secretary createTask:@"Scheduled for today task"];
	[scheduledForTodayTask scheduleFor:[NSDate date]];
	ChocrotaryTask *project1Task = [notebook.secretary createTask:@"Project 1 task"];
	ChocrotaryTask *project2Task = [notebook.secretary createTask:@"Project 2 task"];
	[project1 addTask:project1Task];
	[project2 addTask:project2Task];
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	ChocrotaryProjectTableViewDataSource *projectDataSource = [ChocrotaryProjectTableViewDataSource new];
	ChocrotaryProjectTableViewDelegate *projectDelegate = [ChocrotaryProjectTableViewDelegate new];
	
	[projectDataSource setController:controller];

	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	// Task table view
	NSTableView *taskTableView = [NSTableView new];
	ChocrotaryTaskTableViewDataSource *taskDataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotaryTaskTableViewDelegate *taskDelegate = [ChocrotaryTaskTableViewDelegate new];
	
	[taskTableView setDataSource:taskDataSource];
	[taskTableView setDelegate:taskDelegate];

	[controller setTaskTableView:taskTableView];
	[controller setTaskTableViewDataSource:taskDataSource];
	
	// Not let us go! INBOX
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
						 initWithIndex:ChocrotaryProjectTableViewDataSourceInbox];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	NSTableColumn *column = [NSTableColumn new];
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	NSButtonCell * doneCheckbox = [[taskTableView dataSource] tableView:taskTableView objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	NSString *description = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [inboxTask description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	NSString *projectName = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	NSString *when = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(when,@"", @"Should be no one");
}

-(void) testChangePerspectiveToScheduled {
	// Content
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	ChocrotaryProject *project1 = [notebook.secretary createProject:@"Project 1"];
	ChocrotaryProject *project2 = [notebook.secretary createProject:@"Project 2"];
	
	/*ChocrotaryTask *inboxTask = */[notebook.secretary createTask:@"Inbox task"];
	ChocrotaryTask *scheduledTask = [notebook.secretary createTask:@"Scheduled task"];
	[scheduledTask scheduleFor:[NSDate dateWithTimeIntervalSinceNow:24*60*60*4]];
	ChocrotaryTask *scheduledForTodayTask = [notebook.secretary createTask:@"Scheduled for today task"];
	[scheduledForTodayTask scheduleFor:[NSDate date]];
	ChocrotaryTask *project1Task = [notebook.secretary createTask:@"Project 1 task"];
	ChocrotaryTask *project2Task = [notebook.secretary createTask:@"Project 2 task"];
	[project1 addTask:project1Task];
	[project2 addTask:project2Task];
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	ChocrotaryProjectTableViewDataSource *projectDataSource = [ChocrotaryProjectTableViewDataSource new];
	ChocrotaryProjectTableViewDelegate *projectDelegate = [ChocrotaryProjectTableViewDelegate new];
	
	[projectDataSource setController:controller];
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	// Task table view
	NSTableView *taskTableView = [NSTableView new];
	ChocrotaryTaskTableViewDataSource *taskDataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotaryTaskTableViewDelegate *taskDelegate = [ChocrotaryTaskTableViewDelegate new];
	
	[taskTableView setDataSource:taskDataSource];
	[taskTableView setDelegate:taskDelegate];
	
	[controller setTaskTableView:taskTableView];
	[controller setTaskTableViewDataSource:taskDataSource];
	
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewDataSourceScheduled];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	// Verifying values
	NSTableColumn *column = [NSTableColumn new];
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	NSButtonCell * doneCheckbox = [[taskTableView dataSource] tableView:taskTableView objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	NSString *description = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [scheduledTask description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	NSString *projectName = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	NSDatePickerCell *when = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects([when dateValue], [scheduledTask scheduledFor], @"Should be the scheduled one");
	
	// Second row
	column = [NSTableColumn new];
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	doneCheckbox = [[taskTableView dataSource] tableView:taskTableView objectValueForTableColumn:column row:1];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	description = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:1];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [scheduledForTodayTask description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	projectName = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:1];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	when = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:1];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects([when dateValue], [scheduledForTodayTask scheduledFor], @"Should be no one");
}

-(void) testChangePerspectiveToScheduledForToday {
	// Content
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	ChocrotaryProject *project1 = [notebook.secretary createProject:@"Project 1"];
	ChocrotaryProject *project2 = [notebook.secretary createProject:@"Project 2"];
	
	/*ChocrotaryTask *inboxTask = */[notebook.secretary createTask:@"Inbox task"];
	ChocrotaryTask *scheduledTask = [notebook.secretary createTask:@"Scheduled task"];
	[scheduledTask scheduleFor:[NSDate dateWithTimeIntervalSinceNow:24*60*60*4]];
	ChocrotaryTask *scheduledForTodayTask = [notebook.secretary createTask:@"Scheduled for today task"];
	[scheduledForTodayTask scheduleFor:[NSDate date]];
	ChocrotaryTask *project1Task = [notebook.secretary createTask:@"Project 1 task"];
	ChocrotaryTask *project2Task = [notebook.secretary createTask:@"Project 2 task"];
	[project1 addTask:project1Task];
	[project2 addTask:project2Task];
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	ChocrotaryProjectTableViewDataSource *projectDataSource = [ChocrotaryProjectTableViewDataSource new];
	ChocrotaryProjectTableViewDelegate *projectDelegate = [ChocrotaryProjectTableViewDelegate new];
	
	[projectDataSource setController:controller];
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	// Task table view
	NSTableView *taskTableView = [NSTableView new];
	ChocrotaryTaskTableViewDataSource *taskDataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotaryTaskTableViewDelegate *taskDelegate = [ChocrotaryTaskTableViewDelegate new];
	
	[taskTableView setDataSource:taskDataSource];
	[taskTableView setDelegate:taskDelegate];
	
	[controller setTaskTableView:taskTableView];
	[controller setTaskTableViewDataSource:taskDataSource];
	
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewDataSourceScheduledForToday];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	// Verifying values
	NSTableColumn *column = [NSTableColumn new];
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	NSButtonCell * doneCheckbox = [[taskTableView dataSource] tableView:taskTableView objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	NSString *description = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [scheduledForTodayTask description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	NSString *projectName = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	NSDatePickerCell *when = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects([when dateValue], [scheduledForTodayTask scheduledFor], @"Should be the scheduled one");
}

-(void) testChangePerspectiveToProject {
	// Content
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	ChocrotaryProject *project1 = [notebook.secretary createProject:@"Project 1"];
	ChocrotaryProject *project2 = [notebook.secretary createProject:@"Project 2"];
	
	/*ChocrotaryTask *inboxTask = */[notebook.secretary createTask:@"Inbox task"];
	ChocrotaryTask *scheduledTask = [notebook.secretary createTask:@"Scheduled task"];
	[scheduledTask scheduleFor:[NSDate dateWithTimeIntervalSinceNow:24*60*60*4]];
	ChocrotaryTask *scheduledForTodayTask = [notebook.secretary createTask:@"Scheduled for today task"];
	[scheduledForTodayTask scheduleFor:[NSDate date]];
	ChocrotaryTask *project1Task = [notebook.secretary createTask:@"Project 1 task"];
	ChocrotaryTask *project2Task = [notebook.secretary createTask:@"Project 2 task"];
	[project1 addTask:project1Task];
	[project2 addTask:project2Task];
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	ChocrotaryProjectTableViewDataSource *projectDataSource = [ChocrotaryProjectTableViewDataSource new];
	ChocrotaryProjectTableViewDelegate *projectDelegate = [ChocrotaryProjectTableViewDelegate new];
	
	[projectDataSource setController:controller];
	
	[projectDelegate setController:controller];
	[projectDelegate setTableView:projectTableView];
	
	[projectTableView setDataSource:projectDataSource];
	[projectTableView setDelegate:projectDelegate];
	
	// Task table view
	NSTableView *taskTableView = [NSTableView new];
	ChocrotaryTaskTableViewDataSource *taskDataSource = [ChocrotaryTaskTableViewDataSource new];
	ChocrotaryTaskTableViewDelegate *taskDelegate = [ChocrotaryTaskTableViewDelegate new];
	
	[taskTableView setDataSource:taskDataSource];
	[taskTableView setDelegate:taskDelegate];
	
	[controller setTaskTableView:taskTableView];
	[controller setTaskTableViewDataSource:taskDataSource];
	
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	// Verifying values
	NSTableColumn *column = [NSTableColumn new];
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	NSButtonCell * doneCheckbox = [[taskTableView dataSource] tableView:taskTableView objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	NSString *description = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [project1Task description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	NSString *projectName = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, [[project1Task project] name], @"Should have no project");
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	NSString *when = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(when, @"", @"Should be the scheduled one");
	
	// Second row
	index = [[NSIndexSet alloc] initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	doneCheckbox = [[taskTableView dataSource] tableView:taskTableView objectValueForTableColumn:column row:0];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	description = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [project2Task description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	projectName = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, [[project2Task project] name], @"Should have no project");
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	when = [[taskTableView dataSource] tableView:nil objectValueForTableColumn:column row:0];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(when, @"", @"Should be the scheduled one");
}
@end
