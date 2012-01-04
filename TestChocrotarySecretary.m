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
//  TestChocrotarySecretary.m
//  Secretary
//  Created by Adam Victor Nazareth Brandizzi on 12/03/11.
//  Copyright 2011 Adam Victor Nazareth Brandizzi. All rights reserved.

#import "TestChocrotarySecretary.h"
#import "ChocrotarySecretary.h"
#import "ChocrotaryProject.h"
#import "ChocrotarySecretaryObserverStub.h"

@implementation TestChocrotarySecretary
-(void) testZero {
	ChocrotarySecretary *chocrotary = [[ChocrotarySecretary alloc] init];
	STAssertNotNil(chocrotary, @"ChocrotarySecretary not created");
	STAssertEquals([chocrotary countTasks], 0L, @"Should not contain any task");
	[chocrotary release];
}

-(void) testMoveToProject {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];

	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[secretary moveTask:task1 toProject:project];
	
	[secretary scheduleTask:task2 forDate:[NSDate date]];
	
	STAssertEquals([secretary countInboxTasks], 1L, @"Should have only one task in inbox");
	STAssertEquals([secretary getNthInboxTask:0], task3, @"Task 3 should be the task in inbox");
}

-(void) testMoveToInbox {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];
	[secretary moveTask:task1 toProject:project];
	
	[secretary scheduleTask:task2 forDate:[NSDate date]];
	
	STAssertEquals([secretary countInboxTasks], 1L, @"Should have only one task in inbox");
	STAssertEquals([secretary getNthInboxTask:0], task3, @"Task 3 should be the task in inbox");

	[secretary removeTaskFromProject:task1];
	STAssertEquals([secretary countInboxTasks], 2L, @"Should have two tasks in inbox");
	STAssertEqualObjects([secretary getNthInboxTask:0], task1, @"Task 1 should be a task in inbox");
	STAssertEqualObjects([secretary getNthInboxTask:1], task3, @"Task 3 should be a task in inbox");
}

-(void) testCountScheduled {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	/*ChocrotaryTask *task1 = */[secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	/*ChocrotaryTask *task3 = */[secretary createTask:@"Buy pequi"];	
	[secretary scheduleTask:task2 forDate:[NSDate date]];
	
	
	STAssertEquals([secretary countScheduledTasks], 1L, @"Should have only one schduled tasks");
	STAssertEqualObjects([secretary getNthScheduledTask:0], task2, @"Should be task 2");
}

-(void) testCountScheduledForToday {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	/*ChocrotaryTask *task1 = */[secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	[secretary scheduleTask:task2 forDate:[NSDate date]];
	NSDate *future = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*72];
	[secretary scheduleTask:task3 forDate:future];
	
	STAssertEquals([secretary countTasksScheduledForToday], 1L, @"Should have only one schduled tasks");
	STAssertEquals([secretary getNthTaskScheduledForToday:0], task2, @"Should be task 2");
}

-(void) testGetProject {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotaryProject *project1 = [secretary createProject:@"Chocrotary"],
	*project2 = [secretary createProject:@"libsecretary"], *project;
	
	project = [secretary getProjectByName:@"Chocrotary"];
	STAssertEqualObjects(project, project1, @"Should be the first project");
	project = [secretary getProjectByName:@"libsecretary"];
	STAssertEqualObjects(project, project2, @"Should be the second project");	
}

-(void) testGetTaskObjectFromTask {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotaryTask *task = [secretary createTask:@"Add hidden option"];
	Task *wrapped = [task wrappedTask];
	
	ChocrotaryTask *task2 = [secretary wrapperForTask:wrapped];
	STAssertEqualObjects(task, task2, @"Should be equal");
}

-(void) testAttachDetachTaskObserver {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotarySecretaryObserverStub *stub = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachTaskObserver:stub];
	STAssertEquals([stub countTaskUpdates], 0L, @"Should have no task update");
	
	[secretary notifyTaskUpdate];
	STAssertEquals([stub countTaskUpdates], 1L, @"Now should have one task update");

	ChocrotarySecretaryObserverStub *stub2 = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachTaskObserver:stub2];
	STAssertEquals([stub2 countTaskUpdates], 0L, @"Should have no task update");
	
	[secretary notifyTaskUpdate];
	STAssertEquals([stub countTaskUpdates], 2L, @"Should have two task updates");
	STAssertEquals([stub2 countTaskUpdates], 1L, @"Now should have one task update");
	
	[secretary detachTasksObserver:stub];
	[secretary notifyTaskUpdate];
	STAssertEquals([stub countTaskUpdates], 2L, @"Should have still two task updates");
	STAssertEquals([stub2 countTaskUpdates], 2L, @"Now should have two task updates");
}

-(void) testAttachDetachProjectObserver {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotarySecretaryObserverStub *stub = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachProjectObserver:stub];
	STAssertEquals([stub countProjectUpdates], 0L, @"Should have no project update");
	
	[secretary notifyProjectUpdate];
	STAssertEquals([stub countProjectUpdates],1L, @"Now should have one project update");
	
	ChocrotarySecretaryObserverStub *stub2 = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachProjectObserver:stub2];
	STAssertEquals([stub2 countProjectUpdates], 0L, @"Should have no project update");
	
	[secretary notifyProjectUpdate];
	STAssertEquals([stub countProjectUpdates], 2L, @"Should have 2 project update");
	STAssertEquals([stub2 countProjectUpdates], 1L, @"Should have no project update");
	
	[secretary detachProjectsObserver:stub];
	[secretary notifyProjectUpdate];
	STAssertEquals([stub countProjectUpdates], 2L, @"Should have still two project updates");
	STAssertEquals([stub2 countProjectUpdates], 2L, @"Should have one project update");
}

-(void) testAttachedTaskObserverKnowsTaskUpdate {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotarySecretaryObserverStub *stub = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachTaskObserver:stub];
	STAssertEquals([stub countTaskUpdates], 0L, @"Should have no task update");
	
	ChocrotaryTask *task = [secretary createTask:@"a task"];
	STAssertEquals([stub countTaskUpdates], 1L, @"Now should have one task update");

	[task setDescription:@"better description"];
	STAssertEquals([stub countTaskUpdates], 2L, @"Now should have one task update");
	[task markAsDone];
	STAssertEquals([stub countTaskUpdates], 3L, @"Now should have one task update");
	[task scheduleFor:[NSDate date]];
	STAssertEquals([stub countTaskUpdates], 4L, @"Now should have one task update");

	ChocrotaryProject *project = [secretary createProject:@"a project"];
	// Does not change
	STAssertEquals([stub countTaskUpdates], 4L, @"Now should have one task update");
	[task setProject:project];
	STAssertEquals([stub countTaskUpdates], 5L, @"Now should have one task update");
	[task unsetProject];
	STAssertEquals([stub countTaskUpdates], 6L, @"Now should have one task update");
}

-(void) testAttachedProjectObserverKnowsProjectUpdate{
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	ChocrotarySecretaryObserverStub *stub = [[ChocrotarySecretaryObserverStub alloc] init];
	[secretary attachProjectObserver:stub];
	STAssertEquals([stub countProjectUpdates], 0L, @"Should have no task update");	
	
	ChocrotaryProject *project = [secretary createProject:@"a project"];
	STAssertEquals([stub countProjectUpdates], 1L, @"Now should have one task update");
	
	[project setProjectName:@"better description"];
	STAssertEquals([stub countProjectUpdates], 2L, @"Now should have one task update");
	
	ChocrotaryTask *task = [secretary createTask:@"a task"];
	STAssertEquals([stub countProjectUpdates], 2L, @"Does not change");
	
	[project addTask:task];
	STAssertEquals([stub countProjectUpdates], 3L, @"Now should have one task update");
	[project removeTask:task];
	STAssertEquals([stub countProjectUpdates], 4L, @"Now should have one task update");
}

-(void) testArchiveInboxTasks {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	[task2 markAsDone];
	
	STAssertEquals([secretary countInboxTasks], 3L, @"Should have only one task in inbox");
	STAssertEquals([secretary getNthInboxTask:0], task1, @"Task 1 should be a task in inbox");
	STAssertEquals([secretary getNthInboxTask:1], task2, @"Task 2 should be a task in inbox");
	STAssertEquals([secretary getNthInboxTask:2], task3, @"Task 1 should be a task in inbox");
	
	[secretary archiveDoneInboxTasks];
	
	STAssertEquals([secretary countInboxTasks], 2L, @"Should have two tasks in inbox");
	STAssertEquals([secretary getNthInboxTask:0], task1, @"Task 1 should be a task in inbox");
	STAssertEquals([secretary getNthInboxTask:1], task3, @"Task 3 should be the task in inbox");
	
}

-(void) testArchiveScheduledTasks {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30];
	[secretary scheduleTask:task1 forDate:date];
	[secretary scheduleTask:task2 forDate:date];
	[secretary scheduleTask:task3 forDate:date];
	[task2 markAsDone];
	
	STAssertEquals([secretary countScheduledTasks], 3L, @"Should have three sch tasks");
	STAssertEquals([secretary getNthScheduledTask:0], task1, @"Task 1 should be a task sch");
	STAssertEquals([secretary getNthScheduledTask:1], task2, @"Task 2 should be a task sch");
	STAssertEquals([secretary getNthScheduledTask:2], task3, @"Task 1 should be a task sch");
	
	[secretary archiveDoneScheduledTasks];
	
	STAssertEquals([secretary countScheduledTasks], 2L, @"Should have two tasks in inbox");
	STAssertEquals([secretary getNthScheduledTask:0], task1, @"Task 1 should be a task sch");
	STAssertEquals([secretary getNthScheduledTask:1], task3, @"Task 3 should be the task sch");
}

-(void) testArchiveScheduledForTodayTasks {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	NSDate *date = [NSDate date];
	[secretary scheduleTask:task1 forDate:date];
	[secretary scheduleTask:task2 forDate:date];
	[secretary scheduleTask:task3 forDate:date];
	[task2 markAsDone];
	
	STAssertEquals([secretary countTasksScheduledForToday], 3L, @"Should have three sch tasks");
	STAssertEquals([secretary getNthTaskScheduledForToday:0], task1, @"Task 1 should be a task sch");
	STAssertEquals([secretary getNthTaskScheduledForToday:1], task2, @"Task 2 should be a task sch");
	STAssertEquals([secretary getNthTaskScheduledForToday:2], task3, @"Task 1 should be a task sch");
	
	[secretary archiveDoneTasksScheduledForToday];
	
	STAssertEquals([secretary countTasksScheduledForToday], 2L, @"Should have two tasks in inbox");
	STAssertEquals([secretary getNthTaskScheduledForToday:0], task1, @"Task 1 should be a task sch");
	STAssertEquals([secretary getNthTaskScheduledForToday:1], task3, @"Task 3 should be the task sch");
}

-(void) testScheduleTask {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	NSDate *date = [NSDate date];
	[secretary scheduleTask:task1 forDate:date];
	[secretary scheduleTask:task2 forDate:date];
	[secretary scheduleTask:task3 forDate:date];
	[task2 markAsDone];
	
	STAssertEquals([secretary countTasksScheduledForToday], 3L, @"Should have three sch tasks");
	STAssertEquals([secretary getNthTaskScheduledForToday:0], task1, @"Task 1 should be a task sch");
	STAssertEquals([secretary getNthTaskScheduledForToday:1], task2, @"Task 2 should be a task sch");
	STAssertEquals([secretary getNthTaskScheduledForToday:2], task3, @"Task 3 should be a task sch");
	
	[secretary unscheduleTask:task2];
	
	STAssertEquals([secretary countTasksScheduledForToday], 2L, @"Should have two tasks in inbox");
	STAssertEquals([secretary getNthTaskScheduledForToday:0], task1, @"Task 1 should be a task sch");
	STAssertEquals([secretary getNthTaskScheduledForToday:1], task3, @"Task 3 should be the task sch");
}

-(void) testMoveTaskToProject {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
	
	ChocrotaryProject *project1 = [secretary createProject:@"Chocrotary"];
	ChocrotaryProject *project2 = [secretary createProject:@"libsecretary"];
	
	NSDate *date = [NSDate date];
	[secretary scheduleTask:task1 forDate:date];
	[secretary moveTask:task1 toProject:project1];
	[secretary moveTask:task2 toProject:project2];
	
	STAssertEquals([secretary countInboxTasks], 1L, @"Should have one inbox task");
	STAssertEquals([secretary getNthInboxTask:0], task3, @"Task 3 should be inbox task");

	STAssertEquals([project1 countTasks], 1L, @"Should have one proj1 task");
	STAssertEqualObjects([project1 getNthTask:0], task1, @"Task 1 should be proj1 task");
	STAssertEquals([project2 countTasks], 1L, @"Should have one proj2 task");
	STAssertEqualObjects([project2 getNthTask:0], task2, @"Task 2 should be proj2 task");	

	[secretary removeTaskFromProject:task2];
	STAssertEquals([secretary countInboxTasks], 2L, @"Should have one inbox task");
	STAssertEqualObjects([secretary getNthInboxTask:0], task2, @"Task 2 should be inbox task");
	STAssertEqualObjects([secretary getNthInboxTask:1], task3, @"Task 3 should be inbox task");
	STAssertEquals([project2 countTasks], 0L, @"Should have no proj2 task");
}
-(void) testArchiveTask {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"Buy pequi"];
		
	[task2 markAsDone];
	[secretary archiveTask:task2];
	
	STAssertEquals([secretary countInboxTasks], 2L, @"Should have one inbox task");
	STAssertEquals([secretary getNthInboxTask:0], task1, @"Task 1 should be inbox task");
	STAssertEquals([secretary getNthInboxTask:1], task3, @"Task 3 should be inbox task");
}

-(void) testArchiveTasksFromProject {
	ChocrotarySecretary *secretary = [[ChocrotarySecretary alloc] init];
	
	ChocrotaryTask *task1 = [secretary createTask:@"1 Improve interface"];
	ChocrotaryTask *task2 = [secretary createTask:@"2 Add hidden option"];
	ChocrotaryTask *task3 = [secretary createTask:@"3 Buy pequi"];
	
	ChocrotaryProject *project = [secretary createProject:@"Chocrotary"];	
	[secretary moveTask:task1 toProject:project];
	[secretary moveTask:task2 toProject:project];
	[secretary moveTask:task3 toProject:project];
		
	STAssertEquals([project countTasks], 3L, @"Should have the three tasks");
	STAssertEqualObjects([project getNthTask:0], task1, @"Task 1 should be in project");
	STAssertEqualObjects([project getNthTask:1], task2, @"Task 2 should be in project");
	STAssertEqualObjects([project getNthTask:2], task3, @"Task 3 should be in project");
	
	[task2 markAsDone];
	[secretary archiveTasksFromProject:project];
	
	STAssertEquals([project countTasks], 2L, @"Should have the three tasks");
	STAssertEqualObjects([project getNthTask:0], task1, @"Task 1 should be in project");
	STAssertEqualObjects([project getNthTask:1], task3, @"Task 2 should be in project");
	
}
@end
