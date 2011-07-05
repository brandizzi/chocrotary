/**
 * Secretary for Mac OS X (aka Chocrotary): a Objective-C-written, 
 * Cocoa-based todo list manager
 * Copyright (C) 2011  Adam Victor Nazareth Brandizzi <brandizzi@gmail.com>
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * You can get the latest version of this file at 
 * http://bitbucket.org/brandizzi/chocrotary/
 */
//  TestChocrotaryProjectTableViewDelecate.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 04/07/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "TestChocrotaryProjectTableViewDelegate.h"
#import "ChocrotaryController.h"
#import "ChocrotaryProjectTableViewDataSource.h"
#import "ChocrotaryProjectTableViewDelegate.h"
#import "ChocrotaryTaskTableViewController.h"


@implementation TestChocrotaryProjectTableViewDelegate

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
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewDataSource:taskDataSource];
	
	// Not let us go! INBOX
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewDataSourceInbox];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	NSTableColumn *column = [NSTableColumn new];
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	NSButtonCell * doneCheckbox = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	NSString *description = [taskDataSource tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [inboxTask description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	NSString *projectName = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	NSString *when = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(when,@"", @"Should be no one");
	
	remove("fluflufile");
	
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
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewDataSource:taskDataSource];
	
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewDataSourceScheduled];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	// Verifying values
	NSTableColumn *column = [NSTableColumn new];
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	NSButtonCell * doneCheckbox = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	NSString *description = [taskDataSource tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [scheduledForTodayTask description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	NSString *projectName = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	NSDatePickerCell *when = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects([when dateValue], [scheduledForTodayTask scheduledFor], @"Should be no one");
	
	// Second row
	column = [NSTableColumn new];
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	doneCheckbox = [taskDataSource tableView:nil objectValueForTableColumn:column row:1];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	description = [taskDataSource tableView:nil objectValueForTableColumn:column row:1];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [scheduledTask description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	projectName = [taskDataSource tableView:nil objectValueForTableColumn:column row:1];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	when = [taskDataSource tableView:nil objectValueForTableColumn:column row:1];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects([when dateValue], [scheduledTask scheduledFor], @"Should be the scheduled one");
	
	remove("fluflufile");
	
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
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewDataSource:taskDataSource];
	
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewDataSourceScheduledForToday];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	// Verifying values
	NSTableColumn *column = [NSTableColumn new];
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	NSButtonCell * doneCheckbox = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	NSString *description = [taskDataSource tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [scheduledForTodayTask description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	NSString *projectName = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, @"", @"Should have no project");	
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	NSDatePickerCell *when = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects([when dateValue], [scheduledForTodayTask scheduledFor], @"Should be the scheduled one");
	
	remove("fluflufile");
	
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
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewDataSource:taskDataSource];
	
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	// Verifying values
	NSTableColumn *column = [NSTableColumn new];
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	NSButtonCell * doneCheckbox = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	NSString *description = [taskDataSource tableView:nil objectValueForTableColumn:column row:(NSInteger)0];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [project1Task description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	NSString *projectName = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, [[project1Task project] name], @"Should have no project");
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	NSString *when = [taskDataSource tableView:nil objectValueForTableColumn:column row:0L];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(when, @"", @"Should be the scheduled one");
	
	// Second row
	index = [[NSIndexSet alloc] initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	[column	setIdentifier:ChocrotaryTaskTableColumnDone];
	doneCheckbox = [taskDataSource tableView:nil objectValueForTableColumn:column row:0];
	STAssertNotNil(doneCheckbox, @" done column should be Not nil");
	STAssertFalse([doneCheckbox state], @"Should not be done");
	
	[column setIdentifier:ChocrotaryTaskTableColumnDescription];
	description = [taskDataSource tableView:nil objectValueForTableColumn:column row:0];
	STAssertNotNil(description, @" description column should be Not nil");
	STAssertEqualObjects(description, [project2Task description], @"Wrong task description");
	
	[column setIdentifier:ChocrotaryTaskTableColumnProject];
	projectName = [taskDataSource tableView:nil objectValueForTableColumn:column row:0];
	STAssertNotNil(projectName, @" project column should be Not nil");
	STAssertEqualObjects(projectName, [[project2Task project] name], @"Should have no project");
	
	[column setIdentifier:ChocrotaryTaskTableColumnScheduled];
	when = [taskDataSource tableView:nil objectValueForTableColumn:column row:0];
	STAssertNotNil(when, @"For scheduled tasks date column should be Not nil");
	STAssertEqualObjects(when, @"", @"Should be the scheduled one");
	
	remove("fluflufile");
	
}

-(void) testChangeTotalLabel {
	// Content
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	ChocrotaryProject *project1 = [notebook.secretary createProject:@"Project 1"];
	ChocrotaryProject *project2 = [notebook.secretary createProject:@"Project 2"];
	
	/*ChocrotaryTask *inboxTask = */[notebook.secretary createTask:@"Inbox task"];
	ChocrotaryTask *scheduledTask = [notebook.secretary createTask:@"Scheduled task"];
	[scheduledTask scheduleFor:[NSDate dateWithTimeIntervalSinceNow:24*60*60*4]];
	ChocrotaryTask *scheduledForTodayTask = [notebook.secretary createTask:@"Scheduled for today task"];
	[scheduledForTodayTask scheduleFor:[NSDate date]];
	ChocrotaryTask *project1Task1 = [notebook.secretary createTask:@"Project 1 task 1"],
		*project1Task2 = [notebook.secretary createTask:@"Project 1 task 2"],
		*project1Task3 = [notebook.secretary createTask:@"Project 1 task 3"];
	[project1 addTask:project1Task1];
	[project1 addTask:project1Task2];
	[project1 addTask:project1Task3];
	
	ChocrotaryTask *project2Task1 = [notebook.secretary createTask:@"Project 2 task 1"],
		*project2Task2 = [notebook.secretary createTask:@"Project 2 task 2"],
		*project2Task3 = [notebook.secretary createTask:@"Project 2 task 3"],
		*project2Task4 = [notebook.secretary createTask:@"Project 2 task 4"];
	[project2 addTask:project2Task1];
	[project2 addTask:project2Task2];
	[project2 addTask:project2Task3];
	[project2 addTask:project2Task4];
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	controller.totalLabel = [NSTextField new];
	
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
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewDataSource:taskDataSource];
	
	// Now let us go! INBOX
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewDataSourceInbox];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	NSString *expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 1, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Scheduled for today
	index = [[NSIndexSet alloc] initWithIndex:ChocrotaryProjectTableViewDataSourceScheduledForToday];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 1, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Scheduled
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewDataSourceScheduled];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Project 1
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 3, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Project 2
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 4, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	remove("fluflufile");
	
}


@end
