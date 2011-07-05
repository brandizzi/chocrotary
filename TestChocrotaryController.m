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
#import "ChocrotaryController.h"
#import "ChocrotaryProjectTableViewDataSource.h"
#import "ChocrotaryProjectTableViewDelegate.h"
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
								initWithIndex:ChocrotaryProjectTableViewDataSourceInbox];
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
	
	[controller addTask:nil];
	
	STAssertEquals([notebook.secretary countTasks], 1L, @"Should have one");
	STAssertEquals([notebook.secretary countScheduledTasks], 1L, @"Should have one");
	
	ChocrotaryTask *task = [notebook.secretary getNthScheduledTask:0];
	STAssertFalse([task done], @"Should not be done");
	STAssertEqualObjects([task description], @"", @"Should be empty");
	STAssertNil([task project], @"Should be empty");
	STAssertTrue([task isScheduled], @"should be scheduled");
	STAssertTrue(abs([[task scheduledFor] timeIntervalSinceNow]) < 1, @"should be scheduled");
	
	remove("fluflufile");
}
-(void) testAddTaskScheduledForToday {
	ChocrotaryNotebook *notebook = [[ChocrotaryNotebook alloc] initWithFile:@"fluflufile"];
	STAssertEquals([notebook.secretary countTasks], 0L, @"Should have no one");
	
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
	
	[controller addTask:nil];
	
	STAssertEquals([notebook.secretary countTasks], 1L, @"Should have one");
	STAssertEquals([notebook.secretary countScheduledTasks], 1L, @"Should have one");
	
	ChocrotaryTask *task = [notebook.secretary getNthTaskScheduledForToday:0];
	STAssertFalse([task done], @"Should not be done");
	STAssertEqualObjects([task description], @"", @"Should be empty");
	STAssertNil([task project], @"Should be empty");
	STAssertTrue([task isScheduled], @"should be scheduled");
	STAssertTrue(abs([[task scheduledFor] timeIntervalSinceNow]) < 1, @"should be scheduled");
	
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
	
	[controller setTaskTableViewDataSource:taskDataSource];
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
	
	
	[controller setTaskTableViewDataSource:taskDataSource];
	[controller setTaskTableView:taskTableView];
	
	[taskDataSource setPerspective:[ChocrotarySecretaryInboxPerspective 
									newWithSecretary:notebook.secretary]];
	[taskTableView reloadData];
	
	STAssertEquals([notebook.secretary countTasks], 3L, @"should have 3");
	STAssertEquals([taskTableView numberOfRows], 3L, @"should have 3");
	// do it!
	[controller archiveTasksOfCurrentPerspective:nil];
	
	NSLog(@"number t: %d", [taskTableView numberOfRows]);
	NSLog(@"number n: %d", [notebook.secretary countTasks]);
	
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
	[controller setProjectTableView:projectTableView];
	
	STAssertEquals(3L, [notebook.secretary countProjects], @"three projects");
	// Not let us go!
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	
	// Verifying values
	[controller removeProject:nil];
	STAssertEquals(2L, [notebook.secretary countProjects], @"one less");
	
	STAssertEquals(ChocrotaryProjectTableViewDataSourceFirstProject+1L, [projectTableView selectedRow], 
				   @"Should be same since there was a project after the deleted one");
	
	// Second row
	[controller removeProject:nil];
	STAssertEquals(1L, [notebook.secretary countProjects], @"one less");
	
	STAssertEquals(ChocrotaryProjectTableViewDataSourceFirstProject+0L, [projectTableView selectedRow], 
				   @"Should be the previous line because there is no project after the deleted one");	
	
	remove("fluflufile");
	
}

-(void) testUpdateTotalLabel {
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
	// Create total label
	controller.totalLabel = [NSTextField new];
	
	// Now let us go! INBOX
	NSMutableIndexSet *index = [[NSIndexSet alloc] 
								initWithIndex:ChocrotaryProjectTableViewDataSourceInbox];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller updateTotalLabel];
	NSString *expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Scheduled for today
	index = [[NSIndexSet alloc] initWithIndex:ChocrotaryProjectTableViewDataSourceScheduledForToday];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller updateTotalLabel];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 1, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");

	// Scheduled
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewDataSourceScheduled];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller updateTotalLabel];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 2, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	// Project 1
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller updateTotalLabel];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 3, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");

	// Project 1
	index = [[NSIndexSet alloc] 
			 initWithIndex:ChocrotaryProjectTableViewDataSourceFirstProject+1];
	[projectTableView selectRowIndexes:index byExtendingSelection:NO];
	[controller updateTotalLabel];
	expected = [NSString stringWithFormat:ChocrotaryTotalLabelMask, 2, 4, 10];
	STAssertEqualObjects([controller.totalLabel stringValue], expected, @"Not as expected");
	
	remove("fluflufile");
}


@end
