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
//  TestChocrotaryController.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 05/04/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "TestChocrotaryController.h"
#import "ChocrotaryTaskTableViewController.h"
#import "ChocrotaryTestUtils.h"
#import "ChocrotaryController.h"
#import "ChocrotaryProjectTableViewController.h"
#import "ChocrotaryTaskTableViewController.h"
#import "ChocrotarySecretaryInboxPerspective.h"


@implementation TestChocrotaryController

-(void) testUpdateProjectsMenu {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	[notebook.secretary createProject:@"A project"];
	[notebook.secretary createProject:@"Another project"];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	NSMenu *menu = controller.projectsMenu;
	[controller awakeFromNib];
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

-(void) testAddTaskInbox {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	STAssertEquals([notebook.secretary countTasks], 0L, @"Should have no one");
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	/*ChocrotaryProjectTableViewController *projectController = */
	TestGetChocrotaryProjectTableViewController(controller, projectTableView);
	
	// Task table view
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewController:taskDataSource];
	
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewControllerInbox];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	[controller addTask:nil];
	
	STAssertEquals([notebook.secretary countTasks], 1L, @"Should have one");
	STAssertEquals([notebook.secretary countInboxTasks], 1L, @"Should have one");
	
	ChocrotaryTask *task = [notebook.secretary getNthInboxTask:0];
	STAssertFalse([task done], @"Should not be done");
	STAssertEqualObjects([task description], @"", @"Should be empty");
	STAssertNil([task project], @"Should be empty");
	STAssertFalse([task isScheduled], @"should be not schedued");
	
	remove("fluflufile");
}

-(void) testAddTaskScheduled {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	STAssertEquals([notebook.secretary countTasks], 0L, @"Should have no one");
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	/*ChocrotaryProjectTableViewController *projectController = */
	TestGetChocrotaryProjectTableViewController(controller, projectTableView);
	
	// Task table view
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewController:taskDataSource];
	
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewControllerScheduled];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	[controller addTask:nil];
	
	STAssertEquals([notebook.secretary countTasks], 1L, @"Should have one");
	STAssertEquals([notebook.secretary countScheduledTasks], 1L, @"Should have one");
	
	ChocrotaryTask *task = [notebook.secretary getNthScheduledTask:0];
	STAssertFalse([task done], @"Should not be done");
	STAssertEqualObjects([task description], @"", @"Should be empty");
	STAssertNil([task project], @"Should be empty");
	STAssertTrue([task isScheduled], @"should be scheduled");
	STAssertTrue(abs([[task scheduledFor] timeIntervalSinceNow]) < UTIL_SECONDS_IN_DAY, @"should be scheduled");
	
	remove("fluflufile");
}
-(void) testAddTaskScheduledForToday {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	STAssertEquals([notebook.secretary countTasks], 0L, @"Should have no one");
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	/*ChocrotaryProjectTableViewController *projectController = */
	TestGetChocrotaryProjectTableViewController(controller, projectTableView);

	
	// Task table view
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewController:taskDataSource];
	
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewControllerScheduledForToday];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	[controller addTask:nil];
	
	STAssertEquals([notebook.secretary countTasks], 1L, @"Should have one");
	STAssertEquals([notebook.secretary countScheduledTasks], 1L, @"Should have one");
	
	ChocrotaryTask *task = [notebook.secretary getNthTaskScheduledForToday:0];
	STAssertFalse([task done], @"Should not be done");
	STAssertEqualObjects([task description], @"", @"Should be empty");
	STAssertNil([task project], @"Should be empty");
	STAssertTrue([task isScheduled], @"should be scheduled");
	STAssertTrue(abs([[task scheduledFor] timeIntervalSinceNow]) < UTIL_SECONDS_IN_DAY, @"should be scheduled");
	
	remove("fluflufile");
}
-(void) testAddTaskProject {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	ChocrotaryProject *project = [notebook.secretary createProject:@"a project"];
	STAssertEquals([notebook.secretary countTasks], 0L, @"Should have no one");
	STAssertEquals([project countTasks], 0L, @"Should have no one");
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	/*ChocrotaryProjectTableViewController *projectController = */
	TestGetChocrotaryProjectTableViewController(controller, projectTableView);

	
	// Task table view
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewController:taskDataSource];
	
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewControllerFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	[controller addTask:nil];
	
	STAssertEquals([notebook.secretary countTasks], 1L, @"Should have one");
	
	ChocrotaryTask *task = [project getNthTask:0];
	STAssertFalse([task done], @"Should not be done");
	STAssertEqualObjects([task description], @"", @"Should be empty");
	STAssertNotNil([task project], @"Should not be empty");
	STAssertEqualObjects([task project], project, @"should be project");
	STAssertFalse([task isScheduled], @"should not be scheduled");
	
	remove("fluflufile");
}

-(void) testRemoveTask {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	/*ChocrotaryTask *task = */[notebook.secretary createTask:@"task"];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Task table view
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	NSTableView *taskTableView = [NSTableView new];
	[taskTableView setDataSource:taskDataSource];
	
	[controller setTaskTableViewController:taskDataSource];
	[controller setTaskTableView:taskTableView];
	
	[taskDataSource setPerspective:[ChocrotarySecretaryInboxPerspective 
									newWithSecretary:notebook.secretary]];
	[taskTableView reloadData];
	
	STAssertEquals([notebook.secretary countTasks], 1L, @"should have one");
	STAssertEquals([taskTableView numberOfRows], 1L, @"should have one");
	// do it!
	NSIndexSet *index = [NSIndexSet indexSetWithIndex:0];
	[taskTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller removeTask:nil];
	
	STAssertEquals([taskTableView numberOfRows], 0L, @"should have no one more");
	STAssertEquals([notebook.secretary countTasks], 0L, @"should have no one more");
	remove("fluflufile");
}

-(void) testArchive {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	[notebook.secretary createTask:@"task1"];
	[[notebook.secretary createTask:@"task2"] markAsDone];
	[notebook.secretary createTask:@"task3"];
	
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Task table view
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[taskDataSource setPerspective:[ChocrotarySecretaryInboxPerspective newWithSecretary:notebook.secretary]];
	NSTableView *taskTableView = [NSTableView new];
	[taskTableView setDataSource:taskDataSource];
	
	
	[controller setTaskTableViewController:taskDataSource];
	[controller setTaskTableView:taskTableView];
	
	[taskDataSource setPerspective:[ChocrotarySecretaryInboxPerspective 
									newWithSecretary:notebook.secretary]];
	[taskTableView reloadData];
	
	STAssertEquals([notebook.secretary countTasks], 3L, @"should have 3");
	STAssertEquals([taskTableView numberOfRows], 3L, @"should have 3");
	// do it!
	[controller archiveTasksOfCurrentPerspective:nil];
	
	STAssertEquals([taskTableView numberOfRows], 2L, @"should have 2");
	STAssertEquals([notebook.secretary countInboxTasks], 2L, @"should have 2");
	remove("fluflufile");
}

-(void) testRemoveProject {
	// Content
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	[notebook.secretary createProject:@"Project 1"];
	[notebook.secretary createProject:@"Project 2"];
	[notebook.secretary createProject:@"Project 3"];
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	/*ChocrotaryProjectTableViewController *projectController = */
	TestGetChocrotaryProjectTableViewController(controller, projectTableView);

	
	// Task table view
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewController:taskDataSource];
	[controller setProjectTableView:projectTableView];
	
	STAssertEquals(3L, [notebook.secretary countProjects], @"three projects");
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewControllerFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	// Verifying values
	[controller removeProject:nil];
	STAssertEquals(2L, [notebook.secretary countProjects], @"one less");
	
	STAssertEquals(ChocrotaryProjectTableViewControllerFirstProject+1L, [projectTableView selectedRow], 
				   @"Should be same since there was a project after the deleted one");
	
	// Second row
	[controller removeProject:nil];
	STAssertEquals(1L, [notebook.secretary countProjects], @"one less");
	
	STAssertEquals(ChocrotaryProjectTableViewControllerFirstProject+0L, [projectTableView selectedRow], 
				   @"Should be the previous line because there is no project after the deleted one");	
	
	remove("fluflufile");
	
}

-(void) testUpdateTotalLabel {
	// Content
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	ChocrotarySecretary *secretary = notebook.secretary;
	
	ChocrotaryProject *project1 = [secretary createProject:@"Project 1"];
	ChocrotaryProject *project2 = [secretary createProject:@"Project 2"];
	
	/*ChocrotaryTask *inboxTask = */[secretary createTask:@"Inbox task"];
	ChocrotaryTask *scheduledTask = [secretary createTask:@"Scheduled task"];
	[secretary scheduleTask:scheduledTask forDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60*4]];
	
	ChocrotaryTask *scheduledForTodayTask = [secretary createTask:@"Scheduled for today task"];
	[secretary scheduleTask:scheduledForTodayTask forDate:[NSDate date]];
	
	ChocrotaryTask *project1Task1 = [secretary createTask:@"Project 1 task 1"],
	*project1Task2 = [secretary createTask:@"Project 1 task 2"],
	*project1Task3 = [secretary createTask:@"Project 1 task 3"];
	[secretary moveTask:project1Task1 toProject:project1];
	[secretary moveTask:project1Task2 toProject:project1];
	[secretary moveTask:project1Task3 toProject:project1];	
	
	ChocrotaryTask *project2Task1 = [secretary createTask:@"Project 2 task 1"],
	*project2Task2 = [secretary createTask:@"Project 2 task 2"],
	*project2Task3 = [secretary createTask:@"Project 2 task 3"],
	*project2Task4 = [secretary createTask:@"Project 2 task 4"];
	[secretary moveTask:project2Task1 toProject:project2];
	[secretary moveTask:project2Task2 toProject:project2];
	[secretary moveTask:project2Task3 toProject:project2];
	[secretary moveTask:project2Task4 toProject:project2];
	
	
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	/*ChocrotaryProjectTableViewController *projectController = */
	TestGetChocrotaryProjectTableViewController(controller, projectTableView);

	
	// Task table view
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewController:taskDataSource];
	// Create total label
	controller.totalLabel = [NSTextField new];
	
	// Now let us go! INBOX
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewControllerInbox];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller updateTotalLabel];
	NSString *expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Scheduled for today
	index = [[NSIndexSet alloc] initWithIndex:ChocrotaryProjectTableViewControllerScheduledForToday];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller updateTotalLabel];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");

	// Scheduled
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewControllerScheduled];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller updateTotalLabel];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 2, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Project 1
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewControllerFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller updateTotalLabel];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 3, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");

	// Project 1
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewControllerFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller updateTotalLabel];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 4, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	remove("fluflufile");
}

-(void) testUpdateTotalLabelAddingRemovingTask {
	// Content
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	/*ChocrotaryProject *project1 = */[notebook.secretary createProject:@"Project 1"];
	/*ChocrotaryProject *project2 = */[notebook.secretary createProject:@"Project 2"];
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	/*ChocrotaryProjectTableViewController *projectController = */
	TestGetChocrotaryProjectTableViewController(controller, projectTableView);
	
	
	
	// Task table view
	NSTableView *taskTableView = [NSTableView new];
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewController:taskDataSource];
	[taskTableView setDataSource:taskDataSource];
	[taskTableView setDelegate:taskDataSource];
	controller.taskTableView = taskTableView;
	// Create total label
	controller.totalLabel = [NSTextField new];
	
	// Now let us go! INBOX
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewControllerInbox];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	NSString *expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 1];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:0];
	[taskTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller removeTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	
	// Scheduled for today
	index = [[NSIndexSet alloc] initWithIndex:ChocrotaryProjectTableViewControllerScheduledForToday];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 1];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:0];
	[taskTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller removeTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Scheduled
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewControllerScheduled];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 1];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:0];
	[taskTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller removeTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Project 1
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewControllerFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 1];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:0];
	[taskTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller removeTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Project 1
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewControllerFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 1];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:0];
	[taskTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller removeTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	remove("fluflufile");
}

-(void) testUpdateTotalLabelArchivingTask {
	// Content
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	ChocrotaryProject *project1 = [notebook.secretary createProject:@"Project 1"];
	ChocrotaryProject *project2 = [notebook.secretary createProject:@"Project 2"];
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	/*ChocrotaryProjectTableViewController *projectController = */
	TestGetChocrotaryProjectTableViewController(controller, projectTableView);
	
	
	
	// Task table view
	NSTableView *taskTableView = [NSTableView new];
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewController:taskDataSource];
	[taskTableView setDataSource:taskDataSource];
	[taskTableView setDelegate:taskDataSource];
	controller.taskTableView = taskTableView;
	// Create total label
	controller.totalLabel = [NSTextField new];
	
	// Now let us go! INBOX
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewControllerInbox];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	NSString *expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 1];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:0];
#warning [secretary getNthTask:] should get only unvarchived tasks. Correct it at libsecretary
	[[[notebook secretary] getNthInboxTask:0] markAsDone];
	[controller archiveTasksOfCurrentPerspective:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	
	// Scheduled for today
	index = [[NSIndexSet alloc] initWithIndex:ChocrotaryProjectTableViewControllerScheduledForToday];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 1];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:0];
	[[[notebook secretary] getNthScheduledTask:0] markAsDone];
	[controller archiveTasksOfCurrentPerspective:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Scheduled
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewControllerScheduled];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 1];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:0];
	[[[notebook secretary] getNthScheduledTask:0] markAsDone];
	[controller archiveTasksOfCurrentPerspective:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Project 1
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewControllerFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 1];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:0];
	[taskTableView selectRowIndexes:index byExtendingSelection:NO];

	[[project1 getNthTask:0] markAsDone];
	[controller archiveTasksOfCurrentPerspective:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Project 2
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewControllerFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addTask:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 1];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:0];
	[[project2 getNthTask:0] markAsDone];
	[controller archiveTasksOfCurrentPerspective:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	remove("fluflufile");
}

-(void) testUpdateTotalLabelAddingRemovingProject {
	// Content
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	
	// Controller
	ChocrotaryController *controller = [[ChocrotaryController alloc] initWithNotebook:notebook];
	
	// Project table veiw
	NSTableView *projectTableView = [NSTableView new];
	/*ChocrotaryProjectTableViewController *projectController = */
	TestGetChocrotaryProjectTableViewController(controller, projectTableView);
	
	// Task table view
	NSTableView *taskTableView = [NSTableView new];
	ChocrotaryTaskTableViewController *taskDataSource = [ChocrotaryTaskTableViewController new];
	[controller setTaskTableViewController:taskDataSource];
	[taskTableView setDataSource:taskDataSource];
	[taskTableView setDelegate:taskDataSource];
	controller.taskTableView = taskTableView;
	// Create total label
	controller.totalLabel = [NSTextField new];
	
	// Now let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewControllerInbox];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	NSString *expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 0, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// Adding
	[controller addProject:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 1, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	// removing
	index = [NSIndexSet indexSetWithIndex:ChocrotaryProjectTableViewControllerFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller removeProject:nil];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 0, 0, 0];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	remove("fluflufile");
}


@end
